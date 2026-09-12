#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  printf 'Usage: %s <app-id> <version> <file> [file ...]\n' "$0" >&2
  exit 64
fi

app_id="$1"
version="${2#v}"
shift 2

if [[ ! "$app_id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  printf 'Invalid app id: %s\n' "$app_id" >&2
  exit 65
fi

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]; then
  printf 'Invalid semantic version: %s\n' "$version" >&2
  exit 65
fi

for release_file in "$@"; do
  if [ ! -f "$release_file" ]; then
    printf 'File not found: %s\n' "$release_file" >&2
    exit 66
  fi
done

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

if command -v shasum >/dev/null 2>&1; then
  for release_file in "$@"; do
    shasum -a 256 "$release_file"
  done >"$work_dir/SHA256SUMS.txt"
else
  for release_file in "$@"; do
    sha256sum "$release_file"
  done >"$work_dir/SHA256SUMS.txt"
fi

tag="${app_id}-v${version}"

gh release create "$tag" "$@" "$work_dir/SHA256SUMS.txt" \
  --repo linkq8/app-downloads \
  --title "$app_id v$version" \
  --generate-notes \
  --latest=false

printf 'Published %s\n' "$tag"
