[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$KfcRoot,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

$source = Get-ChildItem -LiteralPath (Join-Path $KfcRoot 'CharacterPresetCollection') -Filter '*.json' -File | Select-Object -First 1
if (-not $source) { throw 'CharacterPresetCollection source was not found.' }

$payload = Get-Content -LiteralPath $source.FullName -Raw | ConvertFrom-Json
$rows = foreach ($preset in $payload.presets) {
    [ordered]@{
        preset_id = $preset.presetId.value
        gender = $preset.gender
        is_player_customization_option = [bool]$preset.references.isPlayerCustomizationOption
        voice_pack_id = $preset.voicePackId.value
        hair_id = $preset.hair.value
        beard_id = $preset.beard.value
        hair_color_id = $preset.hairColorPresetId.value
        beard_color_id = $preset.beardColorPresetId.value
        skin_color_id = $preset.skinColorPresetId.value
        eye_brow_color_id = $preset.eyeBrowColorPresetId.value
        eye_color_id = $preset.eyeColorPresetId.value
        head_id = $preset.head.value
        neck_id = $preset.neck.value
        chest_id = $preset.chest.value
        waist_id = $preset.waist.value
        crotch_id = $preset.crotch.value
        upper_arms_id = $preset.upperArms.value
        lower_arms_id = $preset.lowerArms.value
        hands_id = $preset.hands.value
        upper_legs_id = $preset.upperLegs.value
        lower_legs_id = $preset.lowerLegs.value
        feet_id = $preset.feet.value
        reference_hair_guid = $preset.references.hair
        reference_beard_guid = $preset.references.beard
        preview_image_guid = $preset.references.previewImage.image
    }
}

$result = [ordered]@{
    schema_version = 1
    adapter_id = 'embervault-character-appearance'
    game_scope = 'Enshrouded 1.0'
    source_file = $source.Name
    preset_count = @($rows).Count
    player_customization_option_count = @($rows | Where-Object is_player_customization_option).Count
    nonzero_hair_count = @($rows | Where-Object { $_.hair_id -ne 0 }).Count
    nonzero_beard_count = @($rows | Where-Object { $_.beard_id -ne 0 }).Count
    evidence_state = 'observed-static'
    promotion_state = 'research-only'
    limitation = 'Does not prove live player ownership or writability.'
    presets = @($rows)
}

$parent = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $parent | Out-Null
$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
