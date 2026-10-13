# Changelog

All notable changes are recorded here. Format based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow
[Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-10-14

### Added
- `plan-implement-review` skill: Opus plans, a Sonnet subagent implements, Opus reviews.
- Size check that skips delegation for small tasks.
- Review fix loop that reuses the same implementer, capped at 2 rounds.
- `implementer` subagent pinned to Sonnet.
- Obsidian vault templates (`Status.md`, `Log.md`, `Plans/`, `Reviews/`) plus `CLAUDE.md` and `AGENTS.md` so other sessions and agents pick up project state.
- `install.sh` and `install.ps1`, which never overwrite existing project files.
- CI that validates skill/agent structure and smoke-tests the installer.
