# brain-template

A second brain operated by Claude Code: an Obsidian vault with agents, skills, hooks and rules that keep it organized, plus a global `/brain` command to capture into it from any Claude Code session.

You write and decide. Claude Code creates the daily note, runs the weekly review, triages the inbox, keeps links healthy and tells you what is overdue.

[Leia em português](#português)

## What you get

- **A vault ready to open in Obsidian**: `Daily Notes`, `Goals`, `Projects`, `Inbox`, `People`, `Decisions`, `Finances`, `Companies`, `Places`, `Tools`, `Timeline`, `Areas`, `Archives`, `Templates` and `Bases` (table views).
- **A goal cascade**: 3-year vision, yearly goals, projects, monthly goals, weekly review, daily tasks. Each level has a skill.
- **Skills**: `/daily`, `/weekly`, `/monthly`, `/review`, `/project`, `/onboard`, `/push`, `/search`, `/check-links`, `/adopt`, `/upgrade`, plus automatic ones for goal tracking, vault operations and Obsidian syntax (Markdown, Bases, Canvas).
- **Agents**: `inbox-processor`, `weekly-reviewer`, `goal-aligner`, `note-organizer`.
- **Hooks**: at session start you see today's date, your ONE Big Thing, days since the last weekly review, active projects and the lint summary; every file Claude writes is committed to git on its own.
- **Lint**: `.claude/scripts/brain-lint.py` reports broken links, notes missing frontmatter, inbox items waiting more than 7 days, overdue recurring bills and decisions due for review.
- **Rules for the agent**: `agent-writes.md` says the agent never fills your goals or mission with guesses, marks the notes it writes with `author: claude`, dates and sources every fact, keeps captures verbatim and never writes secrets into the vault.
- **Safety**: `settings.json` denies reading `.env`, keys and `~/.ssh`, and denies `git push --force`, `git reset --hard`, `git clean` and `rm -rf`.
- **Capture from anywhere**: the global `/brain` skill saves a thought to `Inbox/` from any Claude Code session, or answers a question from the vault with `/brain ? question`.
- **English or Brazilian Portuguese**.

## Requirements

[Claude Code](https://docs.claude.com/en/docs/claude-code), [Obsidian](https://obsidian.md), `git`, `python3` (lint) and `jq` (auto-commit hook). macOS or Linux.

## Quick start

```sh
git clone https://github.com/kayossouza/brain-template.git
cd brain-template
./setup.sh                      # asks for the path (default ~/brain) and language
```

Or without questions:

```sh
./setup.sh --path ~/brain --lang en --yes
./setup.sh --path ~/brain --lang pt-BR --yes
./setup.sh --dry-run            # show what would happen, change nothing
```

`setup.sh` copies the vault, installs the global skill in `~/.claude/skills/brain/`, runs `git init` in the vault and prints the next steps. It never overwrites a file that already exists, so running it again is safe. Other flags: `--no-skill`, `--no-git`, `--help`.

Then:

1. Open the vault folder in Obsidian.
2. `cd ~/brain && claude`, then run `/onboard` (name, review day, goal areas).
3. Run `/daily` to start the day.
4. Keep the vault private. If you add a remote, make it a private repository.

## How it works

### Capture

From any Claude Code session, in any folder:

```
/brain call the dentist before the 15th
/brain ? when did I last talk to the accountant
```

The first line writes `Inbox/YYYY-MM-DD-HHMM-<slug>.md` with your words as they are and commits only that file. The second searches the vault and answers with links to the notes, or says nothing was found. `/brain` only runs when you type it; other sessions never read the vault on their own. The vault path is `$BRAIN_DIR` when set, otherwise the path you chose in `setup.sh`.

### Triage

Open a session inside the vault and run the `inbox-processor` agent (or do it as part of `/weekly`). Each item becomes a task in the daily note, a note in the right folder (person, decision, project, recurring bill) or is deleted. Items older than 7 days show up in the lint summary at the start of every session.

### Daily, weekly and monthly

- `/daily` creates today's note with the week's ONE Big Thing, the next action of each active project and yesterday's open tasks. At night it walks you through the reflection.
- `/weekly` (30 minutes, on your review day) collects the week's wins and challenges, updates goal and project progress, triages the inbox and sets next week's ONE Big Thing. `/review` picks the right review for the day.
- `/monthly` rolls the weeks up, checks the quarter's milestones and plans the next month.

### Lint

```sh
python3 .claude/scripts/brain-lint.py      # full report, exit 1 when something needs action
python3 .claude/scripts/brain-lint.py --summary
```

## Customization

- **Mission and goals**: `/onboard`, then edit `CLAUDE.md` (System Purpose) and the files in `Goals/`. Placeholders look like `[CUSTOMIZE: ...]` (English) or `[PERSONALIZE: ...]` (Portuguese); lint counts the ones left.
- **Private preferences**: copy `CLAUDE.local.md.template` to `CLAUDE.local.md`. It is in `.gitignore`.
- **Tags, folders and templates**: `CLAUDE.md`, `Templates/` and `.claude/rules/`. If you rename a folder, update the `env` block in `.claude/settings.json` too.
- **Coaching tone**: `/output-style coach` for a coach that holds you to your commitments.
- **Automatic commits**: set `GIT_AUTO_COMMIT` to `false` in `.claude/settings.json` to turn them off.
- **An existing vault**: run `/adopt` inside it instead of using the template folders.

## Repository layout

```
brain-template/
├── setup.sh                 installer (POSIX sh)
├── vault/                   the vault in English (default)
├── vault-pt-BR/             the same vault in Brazilian Portuguese
├── global-skill/brain/      the global /brain skill
├── tests/run.sh             self-test (uses a throwaway HOME)
├── LICENSE                  MIT, this project
├── LICENSE-obsidian-claude-pkm
└── LICENSE-obsidian-skills
```

**Why two vault folders.** The translations live inside skill bodies, templates and goal files, so a find-and-replace switch cannot produce the Portuguese vault. Each folder is complete and opens directly in Obsidian; `setup.sh --lang` only picks one. Files that carry no language (hooks, settings, lint, the kepano skills, Obsidian config) must stay byte-identical in both, and `tests/run.sh` fails when they drift. Folder and file names are English in both vaults, so skills and hooks find them the same way.

**Note on `/upgrade`.** It pulls the English files from the upstream obsidian-claude-pkm. That replaces the Portuguese translation and this template's additions (lint, agent rules, extra folders, safety denies). Review each diff before applying it.

## Credits

- [ballred/obsidian-claude-pkm](https://github.com/ballred/obsidian-claude-pkm), MIT: the base vault (commit ef1e4da): goal cascade, skills, agents, hooks, rules and the coach output style. See `LICENSE-obsidian-claude-pkm` and `vault/ORIGIN.md` for what changed.
- [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), MIT: `obsidian-markdown`, `obsidian-bases` and `json-canvas` skills (commit 3ccff53), unmodified. See `LICENSE-obsidian-skills`.
- Made by Kayo Souza, [kinho.dev](https://kinho.dev).

## License

MIT. See `LICENSE`. The upstream licenses travel with each vault folder.

---

## Português

Um segundo cérebro operado pelo Claude Code: um vault do Obsidian com agentes, skills, hooks e regras que o mantêm organizado, e um comando global `/brain` para capturar coisas de qualquer sessão do Claude Code.

**O que vem:** a estrutura de pastas (notas diárias, metas, projetos, caixa de entrada, pessoas, decisões, finanças, empresas, lugares, ferramentas, linha do tempo, áreas), a cascata de metas com `/daily`, `/weekly` e `/monthly`, os agentes de triagem e revisão, o commit automático de cada arquivo que o Claude escreve, o lint de saúde do vault e as regras de como o agente escreve (nunca inventa suas metas, marca o que escreveu com `author: claude`, data e fonte em todo fato, nada de segredo no vault).

**Como instalar:**

```sh
git clone https://github.com/kayossouza/brain-template.git
cd brain-template
./setup.sh --lang pt-BR            # pergunta o caminho (padrão ~/brain)
./setup.sh --lang pt-BR --dry-run  # mostra o que faria, sem mudar nada
```

Depois abra a pasta no Obsidian, rode `cd ~/brain && claude` e `/onboard`, e comece o dia com `/daily`.

**Captura:** de qualquer sessão, `/brain ligar para o dentista antes do dia 15` grava a frase literal em `Inbox/` e commita só esse arquivo; `/brain ? quando falei com o contador` busca no vault e responde com links. A triagem acontece numa sessão aberta no vault, com o agente `inbox-processor` ou no `/weekly`.

**Personalização:** missão e metas em `CLAUDE.md` e `Goals/` (os placeholders são `[PERSONALIZE: ...]`), preferências privadas em `CLAUDE.local.md`, tags e templates em `CLAUDE.md` e `Templates/`. Mantenha o vault privado; se puser num remoto, que seja um repositório privado.

O vault em português fica em `vault-pt-BR/`. Os nomes de pasta e arquivo continuam em inglês nas duas versões. Cuidado com o `/upgrade`: ele traz os arquivos em inglês do upstream e substitui a tradução.

Feito por Kayo Souza, [kinho.dev](https://kinho.dev). Licença MIT.
