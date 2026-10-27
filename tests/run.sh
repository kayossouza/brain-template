#!/bin/sh
# Self-test: syntax, lint on both vaults, language-neutral files in sync, setup.sh dry run, real run and re-run.
# Uses a throwaway HOME, so your real ~/.claude and ~/brain are never touched.
set -eu
ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/brain-template-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

sh -n "$ROOT/setup.sh" || fail "setup.sh syntax"
for f in "$ROOT"/vault/.claude/hooks/*.sh "$ROOT"/vault/.claude/scripts/*.sh; do bash -n "$f" || fail "syntax $f"; done
python3 -m py_compile "$ROOT/vault/.claude/scripts/brain-lint.py" || fail "lint compile"
echo "ok   syntax"

for v in vault vault-pt-BR; do
    CLAUDE_PROJECT_DIR="$ROOT/$v" python3 "$ROOT/$v/.claude/scripts/brain-lint.py" >/dev/null || fail "lint reports actions in $v"
done
echo "ok   lint (both vaults, 0 actions)"

# Files that carry no language must be byte-identical in both vaults.
for f in .claude/settings.json .claude/hooks/auto-commit.sh .claude/hooks/session-init.sh \
         .claude/scripts/brain-lint.py .claude/scripts/statusline.sh .claude/output-styles/coach.md \
         .claude/skills/obsidian-markdown .claude/skills/obsidian-bases .claude/skills/json-canvas \
         .obsidian .gitignore FIRST_RUN LICENSE-obsidian-claude-pkm LICENSE-obsidian-skills; do
    diff -r "$ROOT/vault/$f" "$ROOT/vault-pt-BR/$f" >/dev/null || fail "$f differs between vault and vault-pt-BR"
done
diff -r "$ROOT/vault" "$ROOT/vault-pt-BR" -q | sed 's/^Files \([^ ]*\) and .*/\1/' | sed "s|$ROOT/vault/||" > "$TMP/translated"
echo "ok   language-neutral files identical ($(wc -l < "$TMP/translated" | tr -d ' ') translated files differ)"

mkdir -p "$TMP/home"
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
HOME="$TMP/home" sh "$ROOT/setup.sh" --yes --dry-run >/dev/null
[ -e "$TMP/home/brain" ] && fail "dry run created the vault"
[ -e "$TMP/home/.claude" ] && fail "dry run installed the skill"
echo "ok   dry run changes nothing"

for lang in en pt-BR; do
    v="$TMP/home/vault $lang"
    HOME="$TMP/home" sh "$ROOT/setup.sh" --yes --lang "$lang" --path "$v" >/dev/null
    [ -f "$v/FIRST_RUN" ] || fail "$lang: FIRST_RUN missing"
    [ "$(git -C "$v" branch --show-current)" = main ] || fail "$lang: branch is not main"
    [ -z "$(git -C "$v" status --porcelain)" ] || fail "$lang: uncommitted files after setup"
    CLAUDE_PROJECT_DIR="$v" python3 "$v/.claude/scripts/brain-lint.py" >/dev/null || fail "$lang: lint on the installed vault"
    rm "$v/FIRST_RUN"
    out=$(HOME="$TMP/home" sh "$ROOT/setup.sh" --yes --lang "$lang" --path "$v")
    echo "$out" | grep -q "Vault: 0 file(s) copied" || fail "$lang: re-run copied files"
    [ -e "$v/FIRST_RUN" ] && fail "$lang: re-run brought FIRST_RUN back"
    [ "$(git -C "$v" rev-list --count HEAD)" = 1 ] || fail "$lang: re-run made commits"
done
[ -f "$TMP/home/.claude/skills/brain/SKILL.md" ] || fail "skill not installed"
echo "ok   real run and idempotent re-run (en, pt-BR, path with a space)"
echo "All checks passed."
