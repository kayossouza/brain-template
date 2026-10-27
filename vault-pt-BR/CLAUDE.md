# Contexto do vault PKM no Obsidian

## Propósito do sistema
[PERSONALIZE: escreva aqui sua missão pessoal]

*Exemplo: "Construir tecnologia que faça diferença, mantendo o equilíbrio entre saúde, relacionamentos e crescimento pessoal."*

## Estrutura de pastas

| Pasta | Para que serve |
|--------|---------|
| `Daily Notes/` | Notas diárias (`YYYY-MM-DD.md`) |
| `Goals/` | Cascata de metas (3 anos → ano → mês → semana) |
| `Projects/` | Projetos ativos, cada um com seu `CLAUDE.md` |
| `Templates/` | Estruturas de nota reutilizáveis |
| `Archives/` | Conteúdo concluído/inativo |
| `Inbox/` | Capturas ainda sem categoria; chegam aqui pelo `/brain` de qualquer sessão |
| `People/` | Uma nota por pessoa (`Templates/Person Template.md`) |
| `Decisions/` | Decisões com opções, critérios e data de revisão (`Templates/Decision Template.md`) |
| `Finances/` | Contas e obrigações que se repetem, com `next_due` (`Templates/Recurring Template.md`) |
| `Companies/`, `Places/`, `Tools/` | Empresas e organizações, lugares e ferramentas, uma nota cada |
| `Timeline/` | Linha do tempo por ano, mês ou semana |
| `Areas/` | Áreas da vida: resumo, fatos principais e notas ligadas |
| `Bases/` | Visões em tabela (`.base` do Obsidian) sobre as notas |

Comece por `Home.md` (índice). Projetos em `Projects/` sem `CLAUDE.md` são histórico; ganham `CLAUDE.md` quando voltam a ser ativos.

Como o agente escreve aqui: `.claude/rules/agent-writes.md`. Saúde do vault: `python3 .claude/scripts/brain-lint.py` (o resumo aparece no início de cada sessão).

## Foco atual

Veja @Goals/2. Monthly Goals.md para as prioridades do mês.

## Idioma

Notas e respostas em português do Brasil. Use os títulos de seção exatamente como estão nos templates de `Templates/`.

## Sistema de tags

**Prioridade:** `#priority/high`, `#priority/medium`, `#priority/low`
**Status:** `#active`, `#waiting`, `#completed`, `#archived`
**Contexto:** `#work`, `#personal`, `#health`, `#learning`, `#family`

## Skills disponíveis

As skills são chamadas com `/nome-da-skill` ou automaticamente pelo Claude quando fizer sentido.

| Skill | Como chamar | Para que serve |
|-------|------------|---------|
| `daily` | `/daily` | Cria a nota do dia e conduz as rotinas da manhã, do meio do dia e da noite |
| `weekly` | `/weekly` | Faz a revisão semanal: reflexão e planejamento |
| `monthly` | `/monthly` | Revisão mensal, checagem dos marcos do trimestre e plano do próximo mês |
| `project` | `/project` | Cria, acompanha e arquiva projetos ligados às metas |
| `review` | `/review` | Roteador inteligente: detecta se é hora da revisão diária, semanal ou mensal |
| `push` | `/push` | Faz commit e push das mudanças no Git |
| `onboard` | `/onboard` | Configuração interativa (primeira execução) + carga do contexto do vault |
| `adopt` | `/adopt` | Instala o sistema PKM em um vault do Obsidian que já existe |
| `upgrade` | `/upgrade` | Atualiza a partir do obsidian-claude-pkm upstream, preservando seu conteúdo |
| `search` | `/search` | Busca no vault por conteúdo, tags ou links |
| `check-links` | `/check-links` | Encontra wikilinks quebrados |
| `goal-tracking` | (automática) | Acompanha o progresso na cascata de metas, considerando os projetos |
| `obsidian-vault-ops` | (automática) | Lê e escreve arquivos do vault, cuida dos wikilinks |
| `obsidian-markdown` | (automática) | Sintaxe do Obsidian: callouts, embeds, propriedades (kepano/obsidian-skills) |
| `obsidian-bases` | (automática) | Tabelas e visões `.base` sobre as notas (kepano/obsidian-skills) |
| `json-canvas` | (automática) | Mapas visuais `.canvas` (kepano/obsidian-skills) |

### Visibilidade do progresso

Skills e agentes usam as ferramentas de tarefas da sessão para mostrar o progresso em operações com várias etapas:

```
[Spinner] Creating daily note...
[Spinner] Pulling incomplete tasks...
[Done] Morning routine complete (4/4 tasks)
```

As tarefas da sessão são só indicadores temporários de progresso; seus afazeres de verdade continuam como checkboxes em markdown nas notas diárias.

## Agentes disponíveis

| Agente | Para que serve |
|-------|---------|
| `note-organizer` | Organiza o vault, corrige links, junta notas |
| `weekly-reviewer` | Conduz a revisão semanal alinhada às metas |
| `goal-aligner` | Confere se o dia e a semana estão alinhados às metas de longo prazo |
| `inbox-processor` | Processa a caixa de entrada no estilo GTD |

## Estilos de resposta

**Coach de produtividade** (`/output-style coach`)
- Questiona suposições de forma construtiva
- Cobra os compromissos assumidos
- Faz perguntas certeiras para trazer clareza
- Liga o trabalho do dia à missão

## A cascata

O fluxo completo, das metas às tarefas:

```
Visão de 3 anos  →  Metas do ano  →  Projetos  →  Metas do mês  →  Revisão semanal  →  Tarefas do dia
  /goal-tracking      /project        /project      /monthly           /weekly            /daily
```

## Fluxo da caixa de entrada

1. Captura: `/brain <texto>` de qualquer sessão do Claude Code (ou uma nota solta em `Inbox/`). A captura fica literal.
2. Triagem: numa sessão aberta neste vault, rode o agente `inbox-processor` ou o `/weekly`. Cada item vira tarefa, nota na pasta certa ou é apagado.
3. Lint: item com mais de 7 dias na caixa de entrada aparece como ação no `brain-lint.py`.

## Rotina diária

### Manhã (5 min)
1. Rode `/daily` para criar a nota de hoje
2. Revise o contexto da cascata (ONE Big Thing, próximas ações dos projetos)
3. Escolha UM foco principal
4. Revise as tarefas que ficaram pendentes ontem
5. Defina os blocos de tempo

### Noite (5 min)
1. Preencha a seção de reflexão
2. Revise o resumo de atenção às metas e aos projetos
3. Mova as tarefas não concluídas
4. Rode `/push` para salvar as mudanças

### Semanal (30 min - domingo)
1. Rode `/weekly` para a revisão guiada
2. Faça a triagem da caixa de entrada
3. Revise a tabela de andamento dos projetos
4. Calcule o progresso das metas
5. Planeje o foco da próxima semana
6. Arquive as notas antigas

### Mensal (30 min - fim do mês)
1. Rode `/monthly` para a revisão guiada
2. Consolide as vitórias e os desafios das semanas
3. Confira os marcos do trimestre
4. Planeje o foco do próximo mês

## Boas práticas

1. **Seja específico** - Dê contexto claro sobre o que você precisa
2. **Cite as metas** - Ligue as tarefas do dia aos objetivos
3. **Use o modo coach** - Quando precisar de cobrança
4. **Mantenha tudo em dia** - Atualize com frequência o `CLAUDE.md` de cada projeto

## Personalização

Para ajustes pessoais que não devem ir para o Git, crie `CLAUDE.local.md`.
Veja o formato em `CLAUDE.local.md.template`.

---

*Veja @.claude/rules/ para as convenções detalhadas*
*Última atualização: 2026-10-27*
*Versão do sistema: 3.1*
