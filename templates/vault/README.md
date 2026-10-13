# Vault guide

Shared memory for every session and agent working on this project.

| Note | Purpose |
|---|---|
| [[Status]] | Doing / Todo / Done / Decisions. Read first, keep current. |
| [[Log]] | Append-only history of what each agent did. |
| `Plans/` | One note per task: goal, steps, acceptance criteria. Frontmatter `status:` tracks progress. |
| `Reviews/` | Review verdict and issues for each implemented plan. |

## Workflow
1. **Plan** (Opus): write `Plans/<date>-<slug>.md`, add the task to Status → Doing.
2. **Implement** (Sonnet `implementer` agent): follows the plan, appends to Log.
3. **Review** (Opus): checks the diff and tests, writes `Reviews/<date>-<slug>.md`, fixes or sends back.
4. **Close**: Status → Done, follow-ups → Todo, decisions → Decisions.

Trigger it in Claude Code with `/plan-implement-review <task>`.

## Rules
- Facts, not narration. A new reader should understand the state in 30 seconds.
- Append to Log; never rewrite other agents' entries.
- Link notes with wikilinks, e.g. `[[Plans/2026-10-14-example]]`.
