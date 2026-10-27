#!/bin/bash
# Session initialization hook for Obsidian PKM vault
# Sets up environment variables and surfaces priorities for the Claude Code session

# Set vault path (defaults to current directory)
export VAULT_PATH="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Date variables for daily operations
export TODAY=$(date +%Y-%m-%d)
export YESTERDAY=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "yesterday" +%Y-%m-%d)
export CURRENT_WEEK=$(date +%Y-W%V)

# Daily note path
export DAILY_NOTE="$VAULT_PATH/${DAILY_NOTES_DIR:-Daily Notes}/$TODAY.md"

# First-run detection
if [ -f "$VAULT_PATH/FIRST_RUN" ]; then
    echo ""
    echo "Welcome to the Obsidian + Claude Code AI Accountability System!"
    echo ""
    echo "  The Cascade — your goals-to-tasks execution system:"
    echo ""
    echo "  3-Year Vision -> Yearly Goals -> Projects -> Monthly -> Weekly -> Daily"
    echo "       |               |             |           |          |        |"
    echo "  /goal-tracking  /goal-tracking  /project   /monthly   /weekly   /daily"
    echo ""
    echo "  Run /onboard to personalize your vault (takes ~2 minutes)."
    echo "  This will ask your name, preferred review day, and goal areas."
    echo ""
    echo "  After that, try /daily to start your first morning routine."
    echo ""
    exit 0
fi

# Verify vault structure
if [ ! -f "$VAULT_PATH/CLAUDE.md" ]; then
    echo "Note: Not in a vault root directory (no CLAUDE.md found)"
fi

# Output session info
echo "PKM Session initialized"
echo "  Vault: $VAULT_PATH"
echo "  Today: $TODAY"

# Surface today's ONE Big Thing from most recent weekly review
WEEKLY_REVIEW="$VAULT_PATH/${GOALS_DIR:-Goals}/3. Weekly Review.md"
if [ -f "$WEEKLY_REVIEW" ]; then
    ONE_BIG_THING=$(grep -A 1 "ONE Big Thing" "$WEEKLY_REVIEW" | tail -1 | sed 's/^[> ]*//' | sed 's/^[[:space:]]*//')
    if [ -n "$ONE_BIG_THING" ] && [ "$ONE_BIG_THING" != "" ]; then
        echo "  ONE Big Thing: $ONE_BIG_THING"
    fi

    # Days since last weekly review
    LAST_REVIEW_DATE=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$WEEKLY_REVIEW" | tail -1)
    if [ -n "$LAST_REVIEW_DATE" ]; then
        if date -j -f "%Y-%m-%d" "$LAST_REVIEW_DATE" +%s >/dev/null 2>&1; then
            # macOS
            LAST_EPOCH=$(date -j -f "%Y-%m-%d" "$LAST_REVIEW_DATE" +%s 2>/dev/null)
            NOW_EPOCH=$(date +%s)
        else
            # Linux
            LAST_EPOCH=$(date -d "$LAST_REVIEW_DATE" +%s 2>/dev/null)
            NOW_EPOCH=$(date +%s)
        fi
        if [ -n "$LAST_EPOCH" ] && [ -n "$NOW_EPOCH" ]; then
            DAYS_SINCE=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))
            if [ "$DAYS_SINCE" -gt 7 ]; then
                echo "  Weekly review overdue! Last review: $DAYS_SINCE days ago"
            else
                echo "  Last weekly review: $DAYS_SINCE days ago"
            fi
        fi
    fi
fi

# Active project count
PROJECTS_DIR_PATH="$VAULT_PATH/${PROJECTS_DIR:-Projects}"
if [ -d "$PROJECTS_DIR_PATH" ]; then
    PROJECT_COUNT=$(find "$PROJECTS_DIR_PATH" -maxdepth 2 -name "CLAUDE.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$PROJECT_COUNT" -gt 0 ]; then
        echo "  Active projects: $PROJECT_COUNT"
    fi
fi

# Inbox and overdue items (recurring, decisions, stale inbox)
python3 "$VAULT_PATH/.claude/scripts/brain-lint.py" --summary 2>/dev/null
