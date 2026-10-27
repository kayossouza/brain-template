# Obsidian PKM Vault Context

## System Purpose
[CUSTOMIZE: Add your personal mission statement here]

*Example: "Build meaningful technology while maintaining balance across health, relationships, and personal growth."*

## Directory Structure

| Folder | Purpose |
|--------|---------|
| `Daily Notes/` | Daily journal entries (`YYYY-MM-DD.md`) |
| `Goals/` | Goal cascade (3-year → yearly → monthly → weekly) |
| `Projects/` | Projects; active ones have their own `CLAUDE.md` |
| `Templates/` | Reusable note structures |
| `Archives/` | Completed or inactive content |
| `Inbox/` | Uncategorized captures; `/brain` from any Claude Code session drops them here |
| `People/` | One note per person (`Templates/Person Template.md`) |
| `Decisions/` | Decisions with options, criteria and a review date (`Templates/Decision Template.md`) |
| `Finances/` | Recurring bills and obligations, with `next_due` (`Templates/Recurring Template.md`) |
| `Companies/`, `Places/`, `Tools/` | Companies and organizations, places and tools, one note each |
| `Timeline/` | Timeline notes by year, month or week |
| `Areas/` | Areas of life: summary, key facts and linked notes |
| `Bases/` | Obsidian Bases (`.base`) table views over the notes |

Start at `Home.md` (index). Projects in `Projects/` without a `CLAUDE.md` are history; they get one when they become active again.

How the agent writes here: `.claude/rules/agent-writes.md`. Vault health: `python3 .claude/scripts/brain-lint.py` (the summary shows at the start of every session).

## Current Focus

See @Goals/2. Monthly Goals.md for this month's priorities.

## Language

Notes and replies in English. Use the section headings exactly as they are in the templates in `Templates/`.

## Tag System

**Priority:** `#priority/high`, `#priority/medium`, `#priority/low`
**Status:** `#active`, `#waiting`, `#completed`, `#archived`
**Context:** `#work`, `#personal`, `#health`, `#learning`, `#family`

## Available Skills

Skills are invoked with `/skill-name` or automatically by Claude when relevant.

| Skill | Invocation | Purpose |
|-------|------------|---------|
| `daily` | `/daily` | Create daily notes, morning/midday/evening routines |
| `weekly` | `/weekly` | Run weekly review, reflect and plan |
| `monthly` | `/monthly` | Monthly review, quarterly milestone check, next month planning |
| `project` | `/project` | Create, track, and archive projects linked to goals |
| `review` | `/review` | Smart router: detects whether a daily, weekly or monthly review is due |
| `push` | `/push` | Commit and push changes to Git |
| `onboard` | `/onboard` | Interactive setup (first run) + load vault context |
| `adopt` | `/adopt` | Scaffold the PKM system onto an existing Obsidian vault |
| `upgrade` | `/upgrade` | Update from upstream obsidian-claude-pkm, preserving your content |
| `search` | `/search` | Search the vault by content, tags or links |
| `check-links` | `/check-links` | Find broken wiki-links |
| `goal-tracking` | (auto) | Track progress across goal cascade with project awareness |
| `obsidian-vault-ops` | (auto) | Read/write vault files, manage wiki-links |
| `obsidian-markdown` | (auto) | Obsidian syntax: callouts, embeds, properties (kepano/obsidian-skills) |
| `obsidian-bases` | (auto) | `.base` tables and views over notes (kepano/obsidian-skills) |
| `json-canvas` | (auto) | `.canvas` visual maps (kepano/obsidian-skills) |

### Progress Visibility

Skills and agents use session task tools to show progress during multi-step operations:

```
[Spinner] Creating daily note...
[Spinner] Pulling incomplete tasks...
[Done] Morning routine complete (4/4 tasks)
```

Session tasks are temporary progress indicators; your actual to-do items remain as markdown checkboxes in daily notes.

## Available Agents

| Agent | Purpose |
|-------|---------|
| `note-organizer` | Organize vault, fix links, consolidate notes |
| `weekly-reviewer` | Facilitate weekly review aligned with goals |
| `goal-aligner` | Check daily/weekly alignment with long-term goals |
| `inbox-processor` | GTD-style inbox processing |

## Output Styles

**Productivity Coach** (`/output-style coach`)
- Challenges assumptions constructively
- Holds you accountable to commitments
- Asks powerful questions for clarity
- Connects daily work to mission

## The Cascade

The full goals-to-tasks flow:

```
3-Year Vision  →  Yearly Goals  →  Projects  →  Monthly Goals  →  Weekly Review  →  Daily Tasks
   /goal-tracking     /project        /project      /monthly          /weekly         /daily
```

## Inbox Flow

1. Capture: `/brain <text>` from any Claude Code session (or a note dropped in `Inbox/`). Captures stay verbatim.
2. Triage: in a session opened in this vault, run the `inbox-processor` agent or `/weekly`. Each item becomes a task, a note in the right folder, or is deleted.
3. Lint: an inbox item older than 7 days shows up as an action in `brain-lint.py`.

## Daily Workflow

### Morning (5 min)
1. Run `/daily` to create today's note
2. Review cascade context (ONE Big Thing, project next-actions)
3. Identify ONE main focus
4. Review yesterday's incomplete tasks
5. Set time blocks

### Evening (5 min)
1. Complete reflection section
2. Review goal/project attention summary
3. Move unfinished tasks
4. Run `/push` to save changes

### Weekly (30 min - Sunday)
1. Run `/weekly` for guided review
2. Triage the inbox
3. Review project progress table
4. Calculate goal progress
5. Plan next week's focus
6. Archive old notes

### Monthly (30 min - End of month)
1. Run `/monthly` for guided review
2. Roll up weekly wins/challenges
3. Check quarterly milestones
4. Plan next month's focus

## Best Practices

1. **Be Specific** - Give clear context about what you need
2. **Reference Goals** - Connect daily tasks to objectives
3. **Use Coach Mode** - When you need accountability
4. **Keep It Current** - Update project CLAUDE.md files regularly

## Customization

For personal overrides that shouldn't be committed, create `CLAUDE.local.md`.
See `CLAUDE.local.md.template` for format.

---

*See @.claude/rules/ for detailed conventions*
*Last Updated: 2026-10-27*
*System Version: 3.1*
