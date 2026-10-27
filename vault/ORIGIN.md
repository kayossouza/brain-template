# Origin

This vault comes from [brain-template](https://github.com/kayossouza/brain-template).

## Base

[ballred/obsidian-claude-pkm](https://github.com/ballred/obsidian-claude-pkm) `vault-template/`, commit ef1e4da, MIT license (`LICENSE-obsidian-claude-pkm`).

Changes over the base:
- `People/`, `Decisions/`, `Finances/`, `Companies/`, `Places/`, `Tools/`, `Timeline/`, `Areas/` and `Bases/` folders; Person, Decision and Recurring templates; generic `.base` views.
- `.claude/rules/agent-writes.md` (how the agent writes here) and `.claude/scripts/brain-lint.py` (vault health, summarized at session start).
- `settings.json` denies reading secrets (`.env`, keys, `~/.ssh`) and destructive git (`push --force`, `reset --hard`, `clean`).
- `auto-commit.sh` reads the edited file from the hook's JSON on stdin and commits only that file; hooks use `$CLAUDE_PROJECT_DIR`.
- No `.claude-plugin/`, no `skill-discovery` hook, no example notes; fixed years became `[YEAR]`.
- `AGENTS.md` points Codex and other agents to `CLAUDE.md`.

**Review before running `/upgrade`:** it pulls the upstream English files and replaces the additions above and any translation.

## Third-party skills, unmodified

From [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), commit 3ccff53, MIT license (`LICENSE-obsidian-skills`): `.claude/skills/obsidian-markdown/`, `.claude/skills/obsidian-bases/`, `.claude/skills/json-canvas/`.
