# Origem

Este vault vem do [brain-template](https://github.com/kayossouza/brain-template).

## Base

[ballred/obsidian-claude-pkm](https://github.com/ballred/obsidian-claude-pkm) `vault-template/`, commit ef1e4da, licença MIT (`LICENSE-obsidian-claude-pkm`).

Mudanças sobre a base:
- Notas, templates e `Goals/` traduzidos para pt-BR; skills, agentes e regras citam os títulos novos. Nomes de arquivo e pasta continuam os originais, em inglês.
- Pastas `People/`, `Decisions/`, `Finances/`, `Companies/`, `Places/`, `Tools/`, `Timeline/`, `Areas/` e `Bases/`; templates de pessoa, decisão e recorrente; visões `.base` genéricas.
- `.claude/rules/agent-writes.md` (como o agente escreve aqui) e `.claude/scripts/brain-lint.py` (saúde do vault, resumida no início da sessão).
- `settings.json` bloqueia a leitura de segredos (`.env`, chaves, `~/.ssh`) e git destrutivo (`push --force`, `reset --hard`, `clean`).
- `auto-commit.sh` lê o arquivo editado do JSON que o hook recebe no stdin e commita só ele; os hooks usam `$CLAUDE_PROJECT_DIR`.
- Sem `.claude-plugin/`, sem o hook `skill-discovery` e sem notas de exemplo; anos fixos viraram `[ANO]`.
- `AGENTS.md` aponta o Codex e outros agentes para o `CLAUDE.md`.

**Revise antes de rodar `/upgrade`:** ele traz os arquivos em inglês do upstream e substitui a tradução e os acréscimos acima.

## Skills de terceiros, sem modificação

Do [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), commit 3ccff53, licença MIT (`LICENSE-obsidian-skills`): `.claude/skills/obsidian-markdown/`, `.claude/skills/obsidian-bases/`, `.claude/skills/json-canvas/`.
