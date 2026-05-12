#!/usr/bin/env bash
# Maintainer-Tool: aktualisiert den Snapshot der Web Standards aus einem
# externen Standards-Quellrepo.
#
# Dieses Script ist nur für Repo-Maintainer relevant, die die Standards
# zentral pflegen und in dieses Template syncen. Externe Nutzer können es
# ignorieren — `web-standards/AGENTS.md` und `web-standards/checklist.md`
# sind bereits als Snapshot im Repo.
#
# Nutzung:
#   STANDARDS_REPO=/pfad/zum/standards-repo ./scripts/update-standards.sh

set -euo pipefail

if [ -z "${STANDARDS_REPO:-}" ]; then
  echo "❌ STANDARDS_REPO nicht gesetzt."
  echo ""
  echo "Setze die Variable auf den Pfad zum Standards-Quellrepo:"
  echo "  STANDARDS_REPO=/pfad/zum/standards-repo ./scripts/update-standards.sh"
  echo ""
  echo "Externe Nutzer dieses Templates brauchen dieses Script nicht — der"
  echo "Snapshot in web-standards/ ist self-contained."
  exit 1
fi

cd "$(dirname "$0")/.."

if [ ! -d "$STANDARDS_REPO" ]; then
  echo "❌ Standards-Repo nicht gefunden unter: $STANDARDS_REPO"
  exit 1
fi

echo "📥 Aktualisiere Standards-Snapshot aus: $STANDARDS_REPO"

cp "$STANDARDS_REPO/AGENTS.md" web-standards/AGENTS.md
cp "$STANDARDS_REPO/checklist.md" web-standards/checklist.md

cp "$STANDARDS_REPO/.claude/skills/everlast-web-setup/SKILL.md" .claude/skills/everlast-web-setup/SKILL.md
cp "$STANDARDS_REPO/.claude/skills/everlast-web-design/SKILL.md" .claude/skills/everlast-web-design/SKILL.md
cp "$STANDARDS_REPO/.claude/skills/everlast-web-audit/SKILL.md" .claude/skills/everlast-web-audit/SKILL.md

# Snapshot-Version aus Standards-Changelog extrahieren (erste Versions-Zeile)
version=$(grep -m1 -E '^[[:space:]]*-[[:space:]]+\*\*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$STANDARDS_REPO/AGENTS.md" | head -1 | sed -E 's/.*\*\*([0-9]{4}-[0-9]{2}-[0-9]{2}) · (v[0-9.]+).*/\2 — \1/' || echo "unknown — $(date +%Y-%m-%d)")
echo "$version" > web-standards/.snapshot-version

echo "✅ Standards aktualisiert auf: $version"
echo ""
echo "Diff zu vorher (falls in git):"
git diff --stat web-standards/ .claude/skills/ 2>/dev/null || true
