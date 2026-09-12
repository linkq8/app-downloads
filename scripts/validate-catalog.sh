#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 -m json.tool "$repo_dir/catalog.json" >/dev/null

python3 - "$repo_dir/catalog.json" <<'PY'
import json
import re
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    catalog = json.load(handle)

seen = set()
for app in catalog.get("apps", []):
    app_id = app.get("id", "")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", app_id):
        raise SystemExit(f"Invalid app id: {app_id!r}")
    if app_id in seen:
        raise SystemExit(f"Duplicate app id: {app_id}")
    seen.add(app_id)

print(f"Catalog valid: {len(seen)} application(s)")
PY
