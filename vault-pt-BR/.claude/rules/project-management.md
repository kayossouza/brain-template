---
paths: "Projects/**/*.md"
---

# Project Management Rules

These conventions apply to project folders and documentation.

## Project Structure

Each project gets its own folder:
```
Projects/
└── Project-Name/
    ├── CLAUDE.md           # Required: Project context for AI
    ├── README.md           # Optional: Overview if complex
    ├── notes/              # Optional: Related notes
    └── resources/          # Optional: Reference materials
```

## Project CLAUDE.md

Every project must have a CLAUDE.md file with:

```markdown
# Projeto: [Nome]

## Visão geral
[Uma ou duas frases sobre o que é este projeto]

## Status
- **Fase:** Planejamento | Ativo | Pausado | Concluído
- **Progresso:** X%
- **Início:** YYYY-MM-DD
- **Prazo:** YYYY-MM-DD

## Metas
Como é o sucesso neste projeto.

## Foco atual
No que estou trabalhando agora.

## Decisões-chave
Decisões importantes e o motivo de cada uma.

## Próximas ações
- [ ] Próximo passo imediato
- [ ] Passo seguinte

## Bloqueios
O que está impedindo o avanço.

## Recursos
- [[Nota relacionada]]
- [Link externo](url)

## Notas para o Claude
[Contexto específico que o Claude precisa saber para ajudar neste projeto]
```

## Phase Values

Use these labels on the `**Fase:**` line:
- `Planejamento` - Defining scope and approach
- `Ativo` - Currently being worked on
- `Pausado` - Temporarily paused (note reason)
- `Bloqueado` - Waiting on external dependency
- `Revisão` - Work complete, needs review
- `Concluído` - Done and ready for archive

## Progress Tracking

### Percentage Guidelines
- 0-10%: Planning and setup
- 10-30%: Initial implementation
- 30-70%: Core work
- 70-90%: Refinement and polish
- 90-100%: Final review and completion

### Update Frequency
- Update progress weekly at minimum
- Update status when it changes
- Update blockers immediately

## Linking Projects

### To Goals
Link projects to their parent goals:
```markdown
**Contribui para:** [[1. Yearly Goals#Nome da meta]]
```

### To Daily Notes
Reference project work in daily notes:
```markdown
## Registro de trabalho
- Trabalhei em [[Nome do projeto]] - concluí X
```

### Between Projects
Link related projects:
```markdown
**Relacionado:** [[Outro projeto]]
```

## Project Lifecycle

### Starting a Project
1. Create folder in `Projects/`
2. Create CLAUDE.md from template
3. Link to relevant goal
4. Define first next action
5. Set target completion date

### During Project
1. Update CLAUDE.md with progress
2. Log work in daily notes
3. Capture decisions and rationale
4. Track blockers immediately
5. Adjust timeline if needed

### Completing a Project
1. Set `**Fase:** Concluído`
2. Add completion date and summary
3. Document lessons learned
4. Move folder to Archives/Projects/
5. Update goal progress

## Best Practices

1. Keep project scope realistic
2. One primary focus at a time
3. Break large projects into phases
4. Review all active projects weekly
5. Archive completed projects promptly
6. Document decisions as they're made
7. Link to relevant context liberally
