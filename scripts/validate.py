"""Checks that the skill, agent and templates are well-formed. Run: python scripts/validate.py"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
errors: list[str] = []


def frontmatter(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    match = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n", text, re.DOTALL)
    if not match:
        errors.append(f"{path.relative_to(ROOT)}: missing YAML frontmatter")
        return {}
    fields = {}
    for line in match.group(1).splitlines():
        key, sep, value = line.partition(":")
        if sep and not line.startswith(" "):
            fields[key.strip()] = value.strip()
    return fields


def require(path: Path, keys: list[str]) -> dict[str, str]:
    fields = frontmatter(path)
    for key in keys:
        if not fields.get(key):
            errors.append(f"{path.relative_to(ROOT)}: frontmatter missing '{key}'")
    return fields


skill = require(ROOT / "skills/plan-implement-review/SKILL.md", ["name", "description"])
if skill.get("name") != "plan-implement-review":
    errors.append("SKILL.md: name must match its folder 'plan-implement-review'")

agent = require(ROOT / "agents/implementer.md", ["name", "description", "model"])
if agent.get("name") != "implementer":
    errors.append("implementer.md: name must be 'implementer' (the skill spawns it by that name)")

skill_text = (ROOT / "skills/plan-implement-review/SKILL.md").read_text(encoding="utf-8")
if 'subagent_type: "implementer"' not in skill_text:
    errors.append("SKILL.md: no longer spawns the 'implementer' agent")

for rel in [
    "templates/CLAUDE.md",
    "templates/AGENTS.md",
    "templates/vault/Status.md",
    "templates/vault/Log.md",
    "templates/vault/README.md",
]:
    if not (ROOT / rel).is_file():
        errors.append(f"missing template: {rel}")

status = (ROOT / "templates/vault/Status.md").read_text(encoding="utf-8")
for section in ["## Doing", "## Todo", "## Done", "## Decisions"]:
    if section not in status:
        errors.append(f"templates/vault/Status.md: missing section '{section}'")

if errors:
    print("\n".join(f"FAIL {e}" for e in errors))
    sys.exit(1)
print("OK: skill, agent and templates are valid")
