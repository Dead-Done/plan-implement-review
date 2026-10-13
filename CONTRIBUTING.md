# Contributing

Thanks for taking a look. Bug reports, measurements and PRs are all welcome.

## Reporting problems

Open an issue using the bug template. The most useful reports include:
- your Claude Code version and OS
- the task you gave `/plan-implement-review`
- the generated plan (`vault/Plans/...`) and review (`vault/Reviews/...`), if any
- what you expected vs. what happened

## Making changes

1. Fork and create a branch: `git checkout -b fix/short-description`
2. Edit the files under `skills/`, `agents/` or `templates/`.
3. Run the checks:
   ```bash
   python scripts/validate.py
   ```
4. Try it for real: run `./install.sh <some-test-project>` and use the skill on a small task.
5. Add a line to `CHANGELOG.md` under **Unreleased**.
6. Open a PR describing what changed and how you tested it.

## Guidelines

- Keep `SKILL.md` short and direct. Every line of it costs tokens on every run.
- The implementer agent's name (`implementer`) and the vault file names
  (`Status.md`, `Log.md`) are part of the interface. Renaming them breaks existing
  vaults, so flag it clearly in the PR if you need to.
- Claims about token or cost savings need numbers and a description of how you
  measured them.

By contributing you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md) and to
license your work under the [MIT License](LICENSE).
