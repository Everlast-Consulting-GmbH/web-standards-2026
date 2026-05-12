#!/usr/bin/env bash
# Maintainer-only tool: syncs the web-standards snapshot and skills from an
# external standards source repo into this template.
#
# This script is only relevant for repo maintainers who keep standards
# centrally and propagate them into this template. External users can
# ignore it — `web-standards/AGENTS.md` and `web-standards/checklist.md`
# are already a self-contained snapshot in this repo.
#
# Usage:
#   STANDARDS_REPO=/path/to/standards-repo ./scripts/update-standards.sh

set -euo pipefail

if [ -z "${STANDARDS_REPO:-}" ]; then
  echo "❌ STANDARDS_REPO is not set."
  echo ""
  echo "Point the variable at the path of your standards source repo:"
  echo "  STANDARDS_REPO=/path/to/standards-repo ./scripts/update-standards.sh"
  echo ""
  echo "External users of this template do not need this script — the snapshot"
  echo "in web-standards/ is self-contained."
  exit 1
fi

cd "$(dirname "$0")/.."

if [ ! -d "$STANDARDS_REPO" ]; then
  echo "❌ Standards source repo not found at: $STANDARDS_REPO"
  exit 1
fi

echo "📥 Updating standards snapshot from: $STANDARDS_REPO"

cp "$STANDARDS_REPO/AGENTS.md" web-standards/AGENTS.md
cp "$STANDARDS_REPO/checklist.md" web-standards/checklist.md

cp "$STANDARDS_REPO/.claude/skills/launchgrade-setup/SKILL.md" .claude/skills/launchgrade-setup/SKILL.md
cp "$STANDARDS_REPO/.claude/skills/launchgrade-design/SKILL.md" .claude/skills/launchgrade-design/SKILL.md
cp "$STANDARDS_REPO/.claude/skills/launchgrade-audit/SKILL.md" .claude/skills/launchgrade-audit/SKILL.md

# Extract snapshot version from the standards changelog (first version line)
version=$(grep -m1 -E '^[[:space:]]*-[[:space:]]+\*\*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$STANDARDS_REPO/AGENTS.md" | head -1 | sed -E 's/.*\*\*([0-9]{4}-[0-9]{2}-[0-9]{2}) · (v[0-9.]+).*/\2 — \1/' || echo "unknown — $(date +%Y-%m-%d)")
echo "$version" > web-standards/.snapshot-version

echo "✅ Standards updated to: $version"
echo ""
echo "Diff (if in git):"
git diff --stat web-standards/ .claude/skills/ 2>/dev/null || true
