---
name: brain
description: Capture a thought into the user's personal brain (an Obsidian vault) or look something up there, from any Claude Code session. Only when the user types /brain.
disable-model-invocation: true
argument-hint: "[text to save | ? question]"
---

# /brain

The user's personal brain is an Obsidian vault operated by Claude Code. Its path is `${BRAIN_DIR:-$HOME/brain}`: the `BRAIN_DIR` environment variable when set, otherwise `~/brain`. Resolve it once with `echo "${BRAIN_DIR:-$HOME/brain}"` and use that absolute path below as `<vault>`. If `<vault>/CLAUDE.md` does not exist, say the vault was not found and stop.

This skill is the only door to the brain from other sessions: never read or cite the brain unless the user invoked `/brain` in this turn, and never carry what you read into the current session's subject.

## Capture (default)

Arguments: `$ARGUMENTS`

1. If the arguments are empty, capture what the user just said or pointed at in the conversation. If that is unclear, ask what to save in one line.
2. Write `<vault>/Inbox/YYYY-MM-DD-HHMM-<slug>.md` (slug: 3 to 5 words, kebab-case, ASCII only):

   ```markdown
   ---
   date: YYYY-MM-DD
   source: <current session folder or "conversation">
   status: inbox
   tags: [inbox]
   ---

   <the user's words, as close to verbatim as possible, in the language they used>
   ```

3. Do not file, summarize, merge or link it. Triage happens in a session opened in the vault (`inbox-processor` agent, `/weekly`).
4. Never write passwords, tokens, card numbers or ID numbers into the note; write where they live instead.
5. If `<vault>` is a git repository, commit only that file: `git -C "<vault>" add -- "<file>" && git -C "<vault>" commit -q -m "Inbox: <slug>" -- "<file>"`. Do not push; `/push` inside the vault does it.
6. Reply in one line with the file path.

## Lookup (arguments start with `?`)

1. Search the vault, skipping `.git/` and `.obsidian/`: `grep -rli "<terms>" "<vault>" --include="*.md"`, then read the best 1 to 5 matches.
2. Answer in the user's language, citing each note as `[[Note Name]]` with its path. If nothing matches, say so; do not answer from general knowledge.
3. Read-only: no edits, no commits.
