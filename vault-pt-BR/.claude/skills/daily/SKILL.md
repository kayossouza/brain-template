---
name: daily
description: Create daily notes and manage morning, midday, and evening routines. Structure daily planning, task review, and end-of-day reflection. Use for daily productivity routines or when asked to create today's note.
allowed-tools: Read, Write, Edit, Glob, Grep, TaskCreate, TaskUpdate, TaskList, TaskGet
user-invocable: true
---

# Daily Workflow Skill

Creates daily notes and provides structured workflows for morning planning, midday check-ins, and evening shutdowns.

## Usage

Invoke with `/daily` or ask Claude to create today's note or help with daily routines.

### Create Today's Note
```
/daily
```

Or simply ask:
- "Create today's daily note"
- "Start my morning routine"
- "Help me with evening shutdown"

## Daily Note Creation

### What Happens
1. **Checks if today's note exists**
   - If yes: Opens the existing note
   - If no: Creates new note from template

2. **Template Processing**
   - Replaces `{{date}}` with today's date
   - Replaces `{{date:format}}` with formatted dates
   - Handles date arithmetic (e.g., `{{date-1}}` for yesterday)

3. **Automatic Organization**
   - Places note in `Daily Notes/` folder
   - Names file with today's date (YYYY-MM-DD.md)
   - Preserves template structure

### Template Variables
Your daily template can use:
- `{{date}}` - Today's date in default format
- `{{date:dddd}}` - Day name (e.g., Monday)
- `{{date:MMMM DD, YYYY}}` - Formatted date
- `{{date-1:YYYY-MM-DD}}` - Yesterday's date
- `{{date+1:YYYY-MM-DD}}` - Tomorrow's date
- `{{time}}` - Current time

## Morning Routine (5-10 minutes)

### Automated Steps
1. Create today's daily note (if not exists)
2. Pull incomplete tasks from yesterday
3. Read this week's ONE Big Thing from `Goals/3. Weekly Review.md`
4. Surface active project next-actions from `Projects/*/CLAUDE.md`
5. Review weekly goals for today's priority

### Cascade Context Surfacing
Before interactive prompts, automatically surface:
- **ONE Big Thing** from most recent weekly review
- **Active project next-actions** from `Projects/*/CLAUDE.md` (read the "Próximas ações" section)
- **Monthly priority** from `Goals/2. Monthly Goals.md` (the "Prioridade do mês" line under "Foco do mês")

Display as a brief context block at the top of the morning routine:
```markdown
### Contexto do dia
- **ONE Big Thing da semana:** [da revisão semanal]
- **Projetos ativos:** [nome de cada projeto com a primeira próxima ação]
- **Foco do mês:** [das metas do mês]
```

### Interactive Prompts
- "What's your ONE thing for today?"
- "What might get in the way?"
- "How do you want to feel at end of day?"

### Task Creation Guidance
When adding tasks to the daily note, recommend linking to goals/projects:
```markdown
- [ ] Rascunhar a spec da API — Contribui para: [[Projects/MyApp]]
- [ ] Revisar o capítulo 3 — Contribui para: [[1. Yearly Goals#Ler 12 livros]]
```

### Morning Checklist
- [ ] Daily note created
- [ ] Cascade context reviewed (ONE Big Thing, projects, monthly focus)
- [ ] Yesterday's incomplete tasks reviewed
- [ ] ONE priority identified
- [ ] Time blocks set
- [ ] Potential obstacles identified

## Midday Check-in (2-3 minutes)

### Quick Review
1. Check morning task completion
2. Compare actual vs planned time use
3. Assess energy level
4. Identify afternoon priorities

### Adjustments
- Reschedule incomplete morning tasks
- Add urgent items that emerged
- Reorder by current energy level
- Note any blockers

### Midday Questions
- "How's your energy right now?"
- "What's the most important thing for this afternoon?"
- "What can you let go of today?"

## Evening Shutdown (5 minutes)

### Capture
1. Mark completed tasks with [x]
2. Add notes and learnings
3. Log energy levels (1-10)
4. Record gratitude items

### Goal & Project Attention Summary
Automatically generate an end-of-day summary showing which goals and projects received attention:
```markdown
### Impacto do dia na cascata
- **Metas trabalhadas:** [[Meta 1]] (2 tarefas), [[Meta 3]] (1 tarefa)
- **Projetos que avançaram:** [[ProjetoA]] (3 tarefas), [[ProjetoB]] (1 tarefa)
- **Tarefas sem vínculo:** 2 (considere ligar a uma meta ou a um projeto)
```

### Reflect
- What went well today?
- What could be better?
- What did I learn?
- What am I grateful for?

### Prepare
1. Identify tomorrow's priority (preview)
2. Move incomplete tasks to tomorrow or delete
3. Commit changes to git (`/push`)

### Shutdown Checklist
- [ ] All tasks updated (done/moved/deleted)
- [ ] "Reflexão do fim do dia" section completed
- [ ] Tomorrow's priority identified
- [ ] Changes committed

## Daily Note Structure

Standard daily note template (simplified; the full one is `Templates/Daily Template.md`, and the headings must match it):

```markdown
# {{date}}

## 🎯 Foco do dia
> Qual é a UMA coisa que faria o dia de hoje valer a pena?

## ⏰ Blocos de tempo
- Manhã (9h-12h):
- Tarde (12h-17h):
- Noite (17h+):

## ✅ Tarefas
### 🔴 Obrigatório hoje
- [ ]

### 💼 Trabalho
- [ ]

### 🏠 Pessoal
- [ ]

## 📝 Notas do dia
[Pensamentos, notas de reunião, ideias]

## 🔍 Reflexão do fim do dia
- **Vitórias:**
- **Desafios:**
- **Aprendizados:**
- **Gratidão:**
- **Energia:** /10
- **Prioridade de amanhã:**
```

## Time Block Strategies

### Energy-Based
- High energy tasks in morning
- Administrative work after lunch
- Creative work when naturally alert

### Context-Based
- Batch similar tasks together
- Minimize context switching
- Protect deep work blocks

## Configuration

Customize paths to match your vault:
- Daily notes folder: `Daily Notes/`
- Template location: `Templates/Daily Template.md`
- Date format: `YYYY-MM-DD`

### Different Date Formats
- `YYYY-MM-DD` - Standard ISO format (recommended)
- `MM-DD-YYYY` - US format
- `DD-MM-YYYY` - European format
- `YYYY-MM-DD-ddd` - Include day abbreviation

### Folder Organization by Month
Organize daily notes by month/year:
```
Daily Notes/2024/01/2024-01-15.md
```

## Task-Based Progress Tracking

The daily skill uses session tasks to show progress during multi-step routines.

### Morning Routine Tasks

Create tasks at skill start:

```
TaskCreate:
  subject: "Create daily note"
  description: "Create or open today's daily note from template"
  activeForm: "Creating daily note..."

TaskCreate:
  subject: "Pull incomplete tasks"
  description: "Carry forward uncompleted tasks from yesterday"
  activeForm: "Pulling incomplete tasks from yesterday..."

TaskCreate:
  subject: "Surface relevant goals"
  description: "Review weekly/monthly goals for today's priority"
  activeForm: "Surfacing relevant goals..."

TaskCreate:
  subject: "Set time blocks"
  description: "Establish time blocks based on energy and priorities"
  activeForm: "Setting time blocks..."
```

### Dependencies

Morning routine tasks run sequentially:
```
TaskUpdate: "Pull incomplete tasks", addBlockedBy: [create-daily-note-id]
TaskUpdate: "Surface relevant goals", addBlockedBy: [pull-incomplete-tasks-id]
TaskUpdate: "Set time blocks", addBlockedBy: [surface-relevant-goals-id]
```

### Evening Shutdown Tasks

```
TaskCreate:
  subject: "Update task statuses"
  description: "Mark completed tasks, note blockers"
  activeForm: "Updating task statuses..."

TaskCreate:
  subject: "Generate reflection prompts"
  description: "Prompt for wins, challenges, learnings, gratitude"
  activeForm: "Generating reflection prompts..."

TaskCreate:
  subject: "Prepare tomorrow's preview"
  description: "Identify tomorrow's priority and move incomplete tasks"
  activeForm: "Preparing tomorrow's preview..."
```

Mark each task `in_progress` when starting, `completed` when done using TaskUpdate.

Task tools provide visibility into what's happening during longer operations. Tasks are session-scoped and don't persist between Claude sessions—your actual work items remain in your daily note markdown checkboxes.

## Integration

Works with:
- `/push` - Commit end-of-day changes
- `/weekly` - Weekly planning uses daily notes
- `/monthly` - Monthly goals inform daily focus
- `/project` - Surface project next-actions in morning
- `/onboard` - Load context before planning
- Goal tracking skill - Align daily tasks to goals
- Productivity Coach - Accountability for daily routines
