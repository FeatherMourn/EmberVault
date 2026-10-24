# Hosting EmberVault on GitHub Pages

The public website is kept in the repository's `Site` folder. The workflow at
`.github/workflows/pages.yml` publishes that folder whenever changes are pushed
to `main`.

## One-time GitHub setup

1. Open the repository's **Settings** on GitHub.
2. Open **Pages**.
3. Under **Build and deployment**, choose **GitHub Actions**.
4. Push changes to `main`, or run **Deploy EmberVault site** from the Actions tab.

The workflow then publishes `Site/index.html` and all of its data, assets,
records, report pages, and supporting pages as one static site.

## Local preview

From the repository root, run:

```powershell
python -m http.server 8000 --directory Site
```

Then open <http://localhost:8000/>. A local server is recommended because the
site loads JSON indexes that browsers may block when an HTML file is opened
directly from the filesystem.
