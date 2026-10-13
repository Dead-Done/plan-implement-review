---
name: plan-implement-review
description: Opus plans, a Sonnet subagent implements, Opus reviews — and the project's Obsidian vault is kept current (doing / done / todo) so any new session or agent can pick up the work. Use when the user says "plan-implement-review", "/plan-implement-review", "opus plan sonnet build", or asks to delegate implementation of a planned change to Sonnet.
---

# Plan → Implement → Review

You (the main session, ideally Opus) own planning and review. A Sonnet subagent
(`implementer`) does the bulk editing. The vault is the shared memory between
sessions and agents: read it first, update it at every phase.

## 0. Locate and read the vault

Vault = `<project root>/vault` unless the project's `CLAUDE.md` names another path.
If it doesn't exist, create it from the layout below.

```
vault/
  Status.md          # single source of truth: Doing / Todo / Done / Decisions
  Log.md             # append-only, newest at bottom: "- YYYY-MM-DD HH:MM [agent] what happened"
  Plans/<date>-<slug>.md
  Reviews/<date>-<slug>.md
```

Read `Status.md` and the tail of `Log.md` before planning. Check whether the
task is already in progress or conflicts with something in Doing.

## 1. Size check — should we delegate at all?

Delegate only if the change is substantial: roughly 3+ files, or 150+ lines, or
mechanical/repetitive work (boilerplate, migrations, tests). Otherwise implement
it yourself, still do steps 2's vault updates and 5, and say why you skipped
delegation. Handoffs cost tokens (the subagent re-reads files cold), so small
tasks are cheaper done directly.

## 2. Plan (you)

Explore just enough to plan concretely. Write `vault/Plans/<date>-<slug>.md`:

```markdown
---
status: planned        # planned | implementing | in-review | done | abandoned
created: YYYY-MM-DD
---
# <Title>

## Goal
One paragraph: what and why.

## Context the implementer needs
Key files, existing patterns to copy (with paths), gotchas you found.
Paste short relevant snippets so the implementer doesn't re-explore.

## Steps
1. `path/to/file.ext` — exact change: functions/signatures/behavior.
2. ...

## Acceptance criteria
- [ ] Concrete, checkable items (tests pass: `<command>`, behavior X, no change to Y)

## Out of scope
Things the implementer must NOT touch.
```

The plan is the whole handoff. Name files, signatures, and commands; vague
plans produce rework, which erases the savings.

Update `Status.md`: add the task under **Doing** with a `[[Plans/<file>]]` link.
Append to `Log.md`.

## 3. Implement (Sonnet subagent)

Spawn the agent with `subagent_type: "implementer"` (it runs on Sonnet). If that
agent type is unavailable, use `general-purpose` with `model: "sonnet"`.
Run it in the foreground (`run_in_background: false`) — the next step depends on it.

Prompt it with: the plan file path, the project root, the vault path, and
"follow the plan exactly; report deviations; do not edit Status.md". Set the plan's
`status: implementing`.

## 4. Review (you)

Read the implementer's report, then verify yourself — don't trust the summary:
- Look at the actual diff (`git diff` if it's a repo; otherwise read the changed files listed in the report).
- Run the acceptance commands (tests/build/lint).
- Check each acceptance criterion, plus: correctness, edge cases, consistency with
  surrounding code, anything touched that was out of scope.

Write `vault/Reviews/<date>-<slug>.md`: verdict (approve / fixes needed),
checked criteria, issues found with file:line, what was fixed.

Fix loop:
- Small issues (a few lines): fix them yourself.
- Larger issues: send them back to the **same** implementer via SendMessage
  (it keeps its context — cheaper than a new spawn) with specific file:line notes.
- Cap at 2 round-trips; after that, finish it yourself or ask the user.

## 5. Close out the vault

- Plan frontmatter → `status: done` (or `abandoned`, with reason).
- `Status.md`: move the item from **Doing** to **Done** (date + one line + plan/review links).
  Add follow-ups discovered during review to **Todo**. Record any lasting
  decisions under **Decisions** (what + why).
- Append to `Log.md`.

Then report to the user: what was built, review verdict, test results, follow-ups.

## Vault rules (for every agent)

- Keep `Status.md` short and current; it's what new sessions read first. Move old
  Done items (>20) into `Log.md` rather than letting the file grow.
- Never delete other agents' log lines. Append only.
- Use Obsidian wikilinks (`[[Plans/2026-10-14-auth]]`) between notes.
- Write facts, not narration: a cold reader should know what's happening in 30 seconds.
