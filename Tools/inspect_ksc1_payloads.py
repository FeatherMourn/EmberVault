"""Inspect KSC1 blob payloads without modifying or reconstructing saves."""
from __future__ import annotations

import argparse
import bz2
import gzip
import json
import lzma
import struct
import zlib
from pathlib import Path

MAX_BLOB = 64 * 1024 * 1024
MAX_OUTPUT = 128 * 1024 * 1024


def parse(data: bytes) -> list[dict[str, object]]:
    if len(data) < 24 or data[:4] != b"KSC1":
        raise ValueError("not a KSC1 container")
    count = struct.unpack_from("<I", data, 4)[0]
    table_end = 24 + count * 12
    if count > 100000 or table_end > len(data):
        raise ValueError("invalid or unbounded blob table")
    cursor = table_end
    blobs = []
    for index in range(count):
        owner, tag, size = struct.unpack_from("<I4sI", data, 24 + index * 12)
        if size > MAX_BLOB or size > len(data) - cursor:
            raise ValueError(f"blob {index} exceeds bounds")
        payload = data[cursor : cursor + size]
        blobs.append(inspect_blob(index, owner, tag, cursor, payload))
        cursor += size
    return blobs


def inspect_blob(index: int, owner: int, tag: bytes, offset: int, payload: bytes) -> dict[str, object]:
    result: dict[str, object] = {
        "index": index,
        "owner_id": owner,
        "tag": tag.decode("ascii", errors="replace"),
        "payload_offset": offset,
        "compressed_size": len(payload),
        "prefix_hex": payload[:16].hex(),
        "encoding": "unknown",
        "decoded": False,
    }
    decoder = None
    if payload.startswith(b"\x1f\x8b"):
        result["encoding"] = "gzip"
        decoder = gzip.decompress
    elif payload.startswith(b"BZh"):
        result["encoding"] = "bzip2"
        decoder = bz2.decompress
    elif payload.startswith(b"\xfd7zXZ\x00"):
        result["encoding"] = "xz/lzma"
        decoder = lzma.decompress
    elif len(payload) >= 2 and payload[0] == 0x78:
        result["encoding"] = "zlib-candidate"
        decoder = zlib.decompress
    if decoder is None:
        return result
    try:
        decoded = decoder(payload)
        if len(decoded) > MAX_OUTPUT:
            result["decode_error"] = "decoded output exceeds bound"
        else:
            result["decoded"] = True
            result["decoded_size"] = len(decoded)
            result["decoded_prefix_hex"] = decoded[:32].hex()
    except Exception as exc:  # format probe only; never treat a guess as proof
        result["decode_error"] = type(exc).__name__
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    report = {
        "schema": "embervault.ksc1_payload_inspection.v1",
        "read_only": True,
        "reconstructed_save": False,
        "source": str(args.save.resolve()),
        "file_size": args.save.stat().st_size,
        "blobs": parse(args.save.read_bytes()),
    }
    text = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
