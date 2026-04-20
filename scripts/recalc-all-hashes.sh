#!/usr/bin/env bash
# Recalculate all SKILL.md SHA-256 hashes into .claude-plugin/marketplace.json.
#
# Used after batch-editing SKILL.md files. Inspects each plugin's `source` field
# to locate the owning SKILL.md, computes its SHA-256, and writes it back to
# plugins[i].integrity.skill-md-sha256. Idempotent.

set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$REPO_ROOT"

python3 - <<'PY'
import hashlib, json, pathlib, sys

mk_path = pathlib.Path(".claude-plugin/marketplace.json")
data = json.loads(mk_path.read_text())
changed = 0
for p in data["plugins"]:
    source = p.get("source", "./").lstrip("./").rstrip("/")
    skill_md = pathlib.Path(source, "SKILL.md") if source else pathlib.Path("SKILL.md")
    if not skill_md.exists():
        print(f"[skip] {p['name']}: {skill_md} not found", file=sys.stderr)
        continue
    new_hash = hashlib.sha256(skill_md.read_bytes()).hexdigest()
    old_hash = p.get("integrity", {}).get("skill-md-sha256", "")
    if new_hash != old_hash:
        p.setdefault("integrity", {})["skill-md-sha256"] = new_hash
        changed += 1
        print(f"[update] {p['name']}: {old_hash[:12]}... -> {new_hash[:12]}...")
    else:
        print(f"[ok]     {p['name']}: {new_hash[:12]}... (unchanged)")

mk_path.write_text(json.dumps(data, indent=4, ensure_ascii=False) + "\n")
print(f"\n{changed} hash(es) updated; {len(data['plugins']) - changed} unchanged.")
PY
