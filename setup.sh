#!/bin/sh
# brain-template setup: copies the vault, installs the global /brain skill and git-inits the vault.
# POSIX sh, idempotent (existing files are never overwritten), no sudo, no downloads.
set -eu

usage() {
    cat <<'EOF'
Usage: ./setup.sh [options]

  --path DIR     Where to create the vault (default: ~/brain)
  --lang LANG    Vault language: en (default) or pt-BR
  --no-skill     Do not install the global /brain skill
  --no-git       Do not run git init in the vault
  --dry-run      Print what would happen and change nothing
  --yes          Do not ask; use flags and defaults
  -h, --help     Show this help

Running it again is safe: files that already exist are left alone.
EOF
}

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
VAULT=""
LANG_CODE=""
INSTALL_SKILL=1
GIT_INIT=1
DRY_RUN=0
ASSUME_YES=0

while [ $# -gt 0 ]; do
    case "$1" in
        --path) [ $# -ge 2 ] || { echo "--path needs a value" >&2; exit 2; }; VAULT=$2; shift 2 ;;
        --path=*) VAULT=${1#--path=}; shift ;;
        --lang) [ $# -ge 2 ] || { echo "--lang needs a value" >&2; exit 2; }; LANG_CODE=$2; shift 2 ;;
        --lang=*) LANG_CODE=${1#--lang=}; shift ;;
        --no-skill) INSTALL_SKILL=0; shift ;;
        --no-git) GIT_INIT=0; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        --yes|-y) ASSUME_YES=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
done

ask() {
    # ask "Question" default -> prints the answer (default when not interactive)
    if [ "$ASSUME_YES" -eq 0 ] && [ -t 0 ]; then
        printf '%s [%s]: ' "$1" "$2" >&2
        read -r answer || answer=""
        [ -n "$answer" ] && { printf '%s' "$answer"; return; }
    fi
    printf '%s' "$2"
}

# shellcheck disable=SC2088 # a literal "~" is shown to the user and expanded below
[ -n "$VAULT" ] || VAULT=$(ask "Vault path" "~/brain")
[ -n "$LANG_CODE" ] || LANG_CODE=$(ask "Language (en or pt-BR)" "en")

case "$LANG_CODE" in
    en|EN|english) LANG_CODE=en; SRC="$SCRIPT_DIR/vault" ;;
    pt-BR|pt-br|pt|pt_BR) LANG_CODE=pt-BR; SRC="$SCRIPT_DIR/vault-pt-BR" ;;
    *) echo "Unsupported language: $LANG_CODE (use en or pt-BR)" >&2; exit 2 ;;
esac
[ -d "$SRC" ] || { echo "Template folder not found: $SRC" >&2; exit 1; }

# shellcheck disable=SC2088
case "$VAULT" in
    "~") VAULT=$HOME ;;
    "~/"*) VAULT="$HOME/${VAULT#"~/"}" ;;
esac
case "$VAULT" in
    /*) ;;
    *) VAULT="$(pwd)/$VAULT" ;;
esac
VAULT=${VAULT%/}

SKILL_SRC="$SCRIPT_DIR/global-skill/brain/SKILL.md"
SKILL_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/brain"

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "  [dry-run] $*"
    else
        "$@"
    fi
}

echo "brain-template setup"
echo "  Vault:    $VAULT"
echo "  Language: $LANG_CODE"
[ "$DRY_RUN" -eq 1 ] && echo "  Mode:     dry run (nothing will change)"
echo ""

DID="copied"
INSTALLED="installed"
if [ "$DRY_RUN" -eq 1 ]; then DID="to copy"; INSTALLED="to install"; fi

FRESH=0
[ -f "$VAULT/CLAUDE.md" ] || FRESH=1

# 1. Copy the vault, never overwriting an existing file.
LIST=$(mktemp "${TMPDIR:-/tmp}/brain-setup.XXXXXX")
trap 'rm -f "$LIST"' EXIT
(cd "$SRC" && find . -type f ! -name FIRST_RUN ! -name .DS_Store | sed 's|^\./||' | sort) > "$LIST"
copied=0
kept=0
while IFS= read -r rel; do
    if [ -e "$VAULT/$rel" ]; then
        kept=$((kept + 1))
        continue
    fi
    copied=$((copied + 1))
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "  [dry-run] copy $rel"
    else
        mkdir -p "$(dirname -- "$VAULT/$rel")"
        cp -p "$SRC/$rel" "$VAULT/$rel"
    fi
done < "$LIST"
if [ "$FRESH" -eq 1 ]; then
    run cp -p "$SRC/FIRST_RUN" "$VAULT/FIRST_RUN"
    copied=$((copied + 1))
fi
echo "Vault: $copied file(s) $DID, $kept already there (left untouched)."

# 2. Git.
if [ "$GIT_INIT" -eq 1 ]; then
    if ! command -v git >/dev/null 2>&1; then
        echo "Git: not installed, skipped."
    elif [ -d "$VAULT/.git" ]; then
        echo "Git: repository already exists, left as is."
    elif [ "$DRY_RUN" -eq 1 ]; then
        echo "  [dry-run] git init -b main in $VAULT and commit the vault"
    else
        if ! git -C "$VAULT" init -q -b main 2>/dev/null; then
            git -C "$VAULT" init -q
            git -C "$VAULT" symbolic-ref HEAD refs/heads/main
        fi
        git -C "$VAULT" add -A
        if git -C "$VAULT" commit -q -m "Initial vault from brain-template" 2>/dev/null; then
            echo "Git: repository created on branch main with the first commit."
        else
            echo "Git: repository created; commit skipped (set git user.name and user.email, then commit)."
        fi
    fi
fi

# 3. Global /brain skill, with the default path pointing at this vault.
if [ "$INSTALL_SKILL" -eq 1 ]; then
    SKILL_TMP=$(mktemp "${TMPDIR:-/tmp}/brain-skill.XXXXXX")
    trap 'rm -f "$LIST" "$SKILL_TMP"' EXIT
    if [ "$VAULT" = "$HOME/brain" ]; then
        cp "$SKILL_SRC" "$SKILL_TMP"
    else
        escaped=$(printf '%s' "$VAULT" | sed 's/[\\|&]/\\&/g')
        sed -e "s|\\\$HOME/brain|$escaped|g" -e "s|otherwise \`~/brain\`|otherwise \`$escaped\`|" "$SKILL_SRC" > "$SKILL_TMP"
    fi
    if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
        run mkdir -p "$SKILL_DIR"
        run cp "$SKILL_TMP" "$SKILL_DIR/SKILL.md"
        echo "Skill: /brain $INSTALLED in $SKILL_DIR."
    elif cmp -s "$SKILL_TMP" "$SKILL_DIR/SKILL.md"; then
        echo "Skill: /brain already installed and up to date."
    else
        run cp "$SKILL_TMP" "$SKILL_DIR/SKILL.md.new"
        echo "Skill: a different /brain skill exists and was left alone; new version $DID as $SKILL_DIR/SKILL.md.new for you to compare."
    fi
fi

# 4. Next steps.
missing=""
for tool in python3 jq git; do
    command -v "$tool" >/dev/null 2>&1 || missing="$missing $tool"
done

cat <<EOF

Next steps:
  1. Open "$VAULT" as a vault in Obsidian.
  2. Start Claude Code there:  cd "$VAULT" && claude
  3. Run /onboard to set your name, review day and goal areas, then /daily.
  4. From any other Claude Code session, capture with:  /brain <text>   (lookup: /brain ? <question>)
  5. Optional: add a private remote and use /push to back it up.
EOF
[ -n "$missing" ] && printf '\nInstall these for the hooks and lint to work:%s\n' "$missing"
[ "$DRY_RUN" -eq 1 ] && printf '\nDry run finished: nothing was changed.\n'
exit 0
