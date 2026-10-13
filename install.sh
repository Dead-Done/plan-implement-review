#!/usr/bin/env sh
# Installs the plan-implement-review skill and implementer agent for Claude Code.
# Usage: ./install.sh [project-dir]
#   project-dir (optional): also scaffold vault/, CLAUDE.md and AGENTS.md there.
#   Existing files are never overwritten.
set -eu

src=$(cd "$(dirname "$0")" && pwd)
claude="$HOME/.claude"

mkdir -p "$claude/skills/plan-implement-review" "$claude/agents"
cp "$src/skills/plan-implement-review/SKILL.md" "$claude/skills/plan-implement-review/SKILL.md"
cp "$src/agents/implementer.md" "$claude/agents/implementer.md"
echo "Installed skill and agent into $claude"

if [ $# -ge 1 ]; then
  project=$(cd "$1" && pwd)
  (cd "$src/templates" && find . -type f) | while read -r rel; do
    rel=${rel#./}
    dest="$project/$rel"
    if [ -e "$dest" ]; then
      echo "  skip (exists): $rel"
    else
      mkdir -p "$(dirname "$dest")"
      cp "$src/templates/$rel" "$dest"
      echo "  created: $rel"
    fi
  done
  echo "Scaffolded vault in $project"
fi

echo "Restart Claude Code, then run: /plan-implement-review <task>"
