# Security Policy

## Supported versions

Only the latest release on `main` gets fixes.

## What's in scope

This project is a set of Markdown instructions plus two small install scripts. The
realistic risks are:

- **Install scripts** writing outside `~/.claude/` or overwriting files in a project.
- **Instructions that cause unsafe agent behavior**, for example a skill or agent
  prompt that leads Claude to run destructive commands, or that leaks secrets into
  vault notes (which people often sync or commit).
- **Prompt injection through the vault.** Vault notes are read by agents as context.
  If a vault can be edited by people you don't trust, its contents can steer the
  agent. Treat a shared vault like shared code.

Bugs in Claude Code itself should be reported to Anthropic, not here.

## Reporting a vulnerability

Please **don't open a public issue**. Use GitHub's
[private vulnerability reporting](https://github.com/Dead-Done/plan-implement-review/security/advisories/new)
and include steps to reproduce. You should get a response within 7 days.

## Tips for users

- Don't put API keys, tokens or credentials in vault notes.
- If you commit your vault, check it for sensitive content first.
- Read `install.sh` / `install.ps1` before running them. They're short.
