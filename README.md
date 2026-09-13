# LinkQ8 App Downloads

Public release binaries and update metadata for [apps.linkq8.com](https://apps.linkq8.com).

This repository intentionally contains no application source code. Each release uses a tag in the form:

```text
<app-id>-v<semantic-version>
```

Example:

```text
qalam-v1.2.0
```

## Add an application

Add its public metadata to `catalog.json` with an explicit `"public": true` marker, then validate the file. Applications absent from this catalog remain private and are never shown on the public portal.

```bash
./scripts/validate-catalog.sh
```

## Publish a release

From a trusted workstation authenticated with GitHub CLI:

```bash
./scripts/publish-release.sh qalam 1.2.0 ./dist/Qalam-1.2.0.dmg
```

You can pass multiple files. The script creates `SHA256SUMS.txt` and publishes the files as a GitHub Release.

Never upload private keys, signing certificates, source archives, provisioning profiles, or `.env` files.
