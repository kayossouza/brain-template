#!/bin/bash
# Auto-commit hook for vault changes (PostToolUse on Write|Edit).
# Claude Code sends the tool call as JSON on stdin; the edited path is tool_input.file_path.

command -v jq >/dev/null 2>&1 || exit 0

VAULT_PATH="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MODIFIED_FILE=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ "${GIT_AUTO_COMMIT}" != "true" ]; then
    exit 0
fi

cd "$VAULT_PATH" || exit 0
[ -d .git ] || exit 0

# Only commit files inside this vault
case "$MODIFIED_FILE" in
    "$VAULT_PATH"/*) REL="${MODIFIED_FILE#"$VAULT_PATH"/}" ;;
    *) exit 0 ;;
esac

git add -- "$REL" 2>/dev/null || exit 0
git diff --cached --quiet && exit 0

TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
case "$REL" in
    "${DAILY_NOTES_DIR:-Daily Notes}"/*) MSG="Daily note: $(basename "$REL" .md)" ;;
    "${GOALS_DIR:-Goals}"/*) MSG="Goals: $(basename "$REL" .md)" ;;
    "${PROJECTS_DIR:-Projects}"/*) PROJECT=$(echo "$REL" | cut -d/ -f2); MSG="Project: $PROJECT" ;;
    "${TEMPLATES_DIR:-Templates}"/*) MSG="Template: $(basename "$REL" .md)" ;;
    *) MSG="Update: $REL" ;;
esac

git commit -q -m "$MSG ($TIMESTAMP)" -- "$REL" >/dev/null 2>&1 && echo "Auto-committed: $MSG"
exit 0
