---
name: goal-tracking
description: Track progress toward 3-year, yearly, monthly, and weekly goals. Calculate completion percentages, surface stalled goals, connect daily tasks to objectives. Use for goal reviews and progress tracking.
allowed-tools: Read, Grep, Glob, Edit, TaskCreate, TaskUpdate, TaskList, TaskGet
model: sonnet
---

# Goal Tracking Skill

Track and manage the cascading goal system from long-term vision to daily tasks.

## Goal Hierarchy

```
Goals/0. Three Year Goals.md   <- Vision (Life areas)
    ↓
Goals/1. Yearly Goals.md       <- Annual objectives
    ↓
Projects/*/CLAUDE.md           <- Active projects (bridge layer)
    ↓
Goals/2. Monthly Goals.md      <- Current month focus
    ↓
Goals/3. Weekly Review.md      <- Weekly planning
    ↓
Daily Notes/*.md               <- Daily tasks and actions
```

## Goal File Formats

### Three Year Goals
```markdown
## 🎯 Áreas da vida
- Carreira: [Visão]
- Saúde: [Visão]
- Relacionamentos: [Visão]
- Finanças: [Visão]
- Aprendizado: [Visão]
- Pessoal: [Visão]
```

### Yearly Goals
```markdown
## Metas de [ANO]
- [ ] Meta 1 (XX% concluída)
- [ ] Meta 2 (XX% concluída)
- [x] Meta 3 (100% concluída)
```

### Monthly Goals
```markdown
## 🎯 Foco do mês
1. **Principal:** [Foco principal]
2. **Secundária:** [Meta de apoio]
3. **Desafio:** [Se der tempo]

### Resultados-chave
- [ ] Resultado mensurável 1
- [ ] Resultado mensurável 2
```

## Progress Calculation

### Checklist-Based Goals
```
Progress = (Completed checkboxes / Total checkboxes) * 100
```

### Metric-Based Goals
```
Progress = (Current value / Target value) * 100
```

### Time-Based Goals
```
Progress = (Days elapsed / Total days) * 100
```

## Common Operations

### View Goal Progress
1. Read all goal files
2. Parse checkbox completion rates
3. Calculate overall and per-goal progress
4. Identify stalled or at-risk goals

### Update Goal Status
1. Find goal in appropriate file
2. Update checkbox or percentage
3. Add date stamp for significant milestones
4. Update related weekly review

### Connect Task to Goal
When adding tasks to daily notes:
1. Identify which goal the task supports
2. Add goal reference: `Contribui para: [[1. Yearly Goals#Nome da meta]]`
3. Use appropriate priority tag

### Surface Stalled Goals
1. Check last activity date for each goal
2. Flag goals with no progress in 14+ days
3. Suggest actions to restart momentum

## Project-Aware Progress

### Project Integration
When calculating goal progress, include project data:
1. Scan `Projects/*/CLAUDE.md` for all active projects
2. Match projects to goals via their "Meta vinculada" section / "Contribui para:" line
3. Include project completion % in goal progress calculations
4. Surface which projects support each goal

### Orphan Goal Detection
Flag goals that have no active project supporting them:
- A goal with 0 linked projects may need a project created (`/project new`)
- A goal with only completed/archived projects may need a new initiative

## Progress Report Format

```markdown
## Relatório de progresso das metas

### Geral: XX%

### Por meta
| Meta | Progresso | Projetos | Última atividade | Status |
|------|----------|----------|---------------|--------|
| Meta 1 | 75% | [[ProjetoA]] (80%), [[ProjetoB]] (60%) | há 2 dias | No prazo |
| Meta 2 | 30% | (nenhum) | há 14 dias | Parada |

### Status dos projetos
| Projeto | Meta | Progresso | Fase |
|---------|------|----------|-------|
| [[ProjetoA]] | Meta 1 | 80% | Ativo |
| [[ProjetoB]] | Meta 1 | 60% | Ativo |

### Metas órfãs (sem projeto ativo)
- Meta 2 — considere `/project new` para criar um projeto de apoio

### Contribuições desta semana
- [Tarefa] -> [[Meta 1]] via [[ProjetoA]]
- [Tarefa] -> [[Meta 2]]

### Foco recomendado
1. [Meta parada que precisa de atenção]
2. [Meta quase concluída: termine]
3. [Meta órfã que precisa de um projeto]
```

## Task-Based Progress Tracking

The goal tracking skill uses session tasks when generating comprehensive progress reports.

### Progress Report Tasks

Create tasks at skill start:

```
TaskCreate:
  subject: "Read three-year goals"
  description: "Load vision statements from Goals/0. Three Year Goals.md"
  activeForm: "Reading three-year goals..."

TaskCreate:
  subject: "Read yearly goals"
  description: "Load annual objectives from Goals/1. Yearly Goals.md"
  activeForm: "Reading yearly goals..."

TaskCreate:
  subject: "Read monthly goals"
  description: "Load current month focus from Goals/2. Monthly Goals.md"
  activeForm: "Reading monthly goals..."

TaskCreate:
  subject: "Scan recent daily notes"
  description: "Find task completions and goal contributions from past week"
  activeForm: "Scanning recent daily notes..."

TaskCreate:
  subject: "Calculate completion percentages"
  description: "Compute progress for each goal based on checkboxes and metrics"
  activeForm: "Calculating completion percentages..."

TaskCreate:
  subject: "Identify stalled goals"
  description: "Flag goals with no progress in 14+ days"
  activeForm: "Identifying stalled goals..."
```

### Dependencies

Goal file reads can run in parallel, but analysis depends on having all data:
```
TaskUpdate: "Scan recent daily notes", addBlockedBy: [read-monthly-goals-id]
TaskUpdate: "Calculate completion percentages", addBlockedBy: [scan-recent-daily-notes-id]
TaskUpdate: "Identify stalled goals", addBlockedBy: [calculate-completion-percentages-id]
```

Mark each task `in_progress` when starting, `completed` when done using TaskUpdate.

Task tools are session-scoped and don't persist—your actual goal progress is tracked through markdown checkboxes and percentages in your goal files.

## Integration Points

- `/weekly` review: Full progress assessment with project rollup
- `/daily` planning: Surface relevant goals and project next-actions
- `/monthly` review: Adjust goals as needed, check quarterly milestones
- `/project status`: Project completion feeds goal calculations
- Every quarter: re-cascade from the 3-year vision (`Divisão por trimestre` in `Goals/1. Yearly Goals.md`)
