#!/usr/bin/env bash
set -euo pipefail

# Run from the repo root. Backs up originals with .bak
# Requires: perl (portable across macOS/Linux)

# Map real identifiers -> placeholders
declare -A MAP=(
  ["`prod-organize-arizon-4e1c0a83`"]="`{{project_id}}`"
  ["prod-organize-arizon-4e1c0a83"]="{{project_id}}"
  ["`proj-tmc-mem-mvp`"]="`{{external_project_id}}`"
  ["proj-tmc-mem-mvp"]="{{external_project_id}}"
  ["`everyaction_enhanced`"]="`{{vendor_sync_dataset}}`"
  ["everyaction_enhanced"]="{{vendor_sync_dataset}}"
  ["`organizing_view`"]="`{{analytics_dataset}}`"
  ["organizing_view"]="{{analytics_dataset}}"
  ["enh_everyaction__"]="{{vendor_table_prefix}}"
  ["christina@ruralazaction.org"]="data+oss@example.org"
)

# Target file globs (edit if needed)
FILES=$(git ls-files '*.sql' '*.md' ':!:LICENSE' || true)

for f in $FILES; do
  cp "$f" "$f.bak"
  for from in "${!MAP[@]}"; do
    to="${MAP[$from]}"
    # perl -0777 handles multiline; \Q...\E escapes literals safely
    perl -0777 -pe "s/\Q${from}\E/${to}/g" "$f" > "${f}.tmp"
    mv "${f}.tmp" "$f"
  done
done

echo "Sanitization done. Backups saved alongside as .bak"
