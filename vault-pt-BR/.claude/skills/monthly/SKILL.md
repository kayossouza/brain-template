---
name: monthly
description: Monthly review and planning. Roll up weekly reviews, check quarterly milestones, set next month's focus. Use at end of month or start of new month.
allowed-tools: Read, Write, Edit, Glob, Grep, TaskCreate, TaskUpdate, TaskList, TaskGet
model: sonnet
user-invocable: true
---

# Monthly Review Skill

Facilitates monthly review and planning by rolling up weekly reviews, checking quarterly milestones, and setting next month's focus.

## Usage

```
/monthly              # Run monthly review for current month
```

Or ask:
- "Help me with my monthly review"
- "Plan next month"
- "How did this month go?"

## What This Skill Does

1. **Creates or opens monthly goals file** (`Goals/2. Monthly Goals.md`)
2. **Rolls up weekly reviews** from the past month
3. **Checks quarterly milestones** against yearly goals
4. **Plans next month's** focus areas and priorities

## Review Process

### Phase 1: Collect Monthly Data (10 minutes)

1. Read all weekly reviews from the past month (`Goals/3. Weekly Review.md` or weekly review notes)
2. Read daily notes from past 30 days (scan for patterns)
3. Read current `Goals/2. Monthly Goals.md` for this month's targets
4. Scan `Projects/*/CLAUDE.md` for project status updates

**Extract:**
- Wins from each week
- Challenges and recurring blockers
- Goal progress percentages
- Project milestones completed
- Habits tracked (completion rates)

### Phase 2: Reflect on Month (10 minutes)

1. Read `Goals/1. Yearly Goals.md` for quarterly milestones
2. Calculate which quarter we're in and check milestone progress
3. Identify patterns across weeks (energy, productivity, focus areas)
4. Compare planned vs actual outcomes

**Generate:**
- Monthly accomplishment summary
- Progress check on this quarter's milestones
- Pattern analysis (what worked, what didn't)
- Goal alignment assessment

### Phase 3: Plan Next Month (10 minutes)

1. Identify next month's quarterly milestones
2. Surface projects that need attention
3. Set next month's primary focus (ONE thing)
4. Define 3-tier priorities (the `Obrigatório` / `Importante` / `Se der` sections of `Goals/2. Monthly Goals.md`)
5. Plan habits to build or maintain

**Write:**
- Update `Goals/2. Monthly Goals.md` with next month's plan
- Set specific weekly milestones for the month ahead

## Output Format

```markdown
## Revisão mensal: [Mês Ano]

### Resumo do mês
- Semanas revisadas: 4
- Notas diárias analisadas: [N]
- Projetos ativos: [N]

### Vitórias
1. [Grande conquista]
2. [Marco alcançado]
3. [Hábito que funcionou]

### Desafios
1. [Bloqueio recorrente]
2. [Meta não alcançada]

### Padrões
- **Energia:** [Quando você foi mais produtivo?]
- **Foco:** [O que recebeu mais atenção?]
- **Lacunas:** [O que foi evitado o tempo todo?]

### Progresso das metas
| Meta | Início do mês | Fim do mês | Variação |
|------|---------------|-------------|-------|
| [Meta 1] | 30% | 45% | +15% |
| [Meta 2] | 50% | 55% | +5% |

### Checagem dos marcos do trimestre
**Trimestre: T[N] ([meses])**
| Marco | Status | Notas |
|-----------|--------|-------|
| [Marco 1] | No prazo | [Detalhe] |
| [Marco 2] | Em risco | [O que falta] |

### Status dos projetos
| Projeto | Progresso | Status | Foco do próximo mês |
|---------|----------|--------|-----------------|
| [Projeto 1] | 60% | Ativo | [Entrega principal] |

### Plano do próximo mês

**Foco único:** [Objetivo principal]

**Obrigatório:**
1. [Entrega inegociável]
2. [Marco crítico]
3. [Compromisso-chave]

**Importante:**
1. [Importante, mas flexível]
2. [Meta de apoio]

**Se der:**
1. [Meta desafiadora]

**Marcos semanais:**
- Semana 1: [Foco]
- Semana 2: [Foco]
- Semana 3: [Foco]
- Semana 4: [Foco + revisão mensal]

### Checagem de bem-estar
- Saúde física: /10
- Saúde mental: /10
- Relacionamentos: /10
- Satisfação com o trabalho: /10
- Geral: /10

### Perguntas para pensar
- "O que faria o próximo mês ser um sucesso de verdade?"
- "Que compromisso você deveria largar ou delegar?"
- "Qual meta precisa de outra abordagem?"
```

## Data Sources

Always read these files:
- `Goals/0. Three Year Goals.md` - Long-term vision context
- `Goals/1. Yearly Goals.md` - This quarter's milestones (`Divisão por trimestre`) and annual objectives
- `Goals/2. Monthly Goals.md` - Current month's plan (to review) and next month's (to write)
- `Goals/3. Weekly Review.md` - Weekly reviews from past month
- `Daily Notes/*.md` - Past 30 days of notes
- `Projects/*/CLAUDE.md` - All active project statuses

## Task-Based Progress Tracking

### Monthly Review Tasks
```
TaskCreate:
  subject: "Phase 1: Collect monthly data"
  description: "Read weekly reviews, daily notes, and project files from past month"
  activeForm: "Collecting monthly data..."

TaskCreate:
  subject: "Phase 2: Reflect on month"
  description: "Analyze patterns, check quarterly milestones, assess goal alignment"
  activeForm: "Reflecting on monthly patterns..."

TaskCreate:
  subject: "Phase 3: Plan next month"
  description: "Set focus, define priorities, establish weekly milestones"
  activeForm: "Planning next month..."

TaskCreate:
  subject: "Write monthly review note"
  description: "Generate and save the monthly review document"
  activeForm: "Writing monthly review..."
```

### Dependencies
```
TaskUpdate: "Phase 2: Reflect", addBlockedBy: [phase-1-id]
TaskUpdate: "Phase 3: Plan", addBlockedBy: [phase-2-id]
TaskUpdate: "Write monthly review", addBlockedBy: [phase-3-id]
```

Mark each task `in_progress` when starting, `completed` when done.

## Integration

Works with:
- `/weekly` - Monthly review rolls up weekly reviews
- `/goal-tracking` - Progress on this quarter's milestones
- `/project status` - Project progress feeds monthly assessment
- `/daily` - Next month's plan informs daily priorities
- `/push` - Commit after completing review
