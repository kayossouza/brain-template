#!/usr/bin/env python3
"""Vault health check. Usage: brain-lint.py [--summary]. Exits 1 when something needs action.

Messages follow "language" in vault-config.json ("en" or "pt-BR")."""
import datetime as dt
import json
import os
import re
import sys
from pathlib import Path

VAULT = Path(os.environ.get("CLAUDE_PROJECT_DIR") or Path(__file__).resolve().parents[2])
SKIP = {".git", ".obsidian", ".claude", "Templates"}
NEEDS_FRONTMATTER = {"Daily Notes", "Inbox", "People", "Decisions", "Finances"}
PLACEHOLDERS = ("[CUSTOMIZE", "[PERSONALIZE:")
REVIEWED = {"reviewed", "revista"}
INBOX_MAX_DAYS = 7
TODAY = dt.date.today()

WIKILINK = re.compile(r"\[\[([^\]|#]+)")
FIELD = re.compile(r"^(\w+):\s*(.+?)\s*$", re.M)
CODE = re.compile(r"```.*?```", re.S)

MESSAGES = {
    "en": {
        "broken": "broken link: {rel} -> [[{target}]]",
        "no_frontmatter": "missing frontmatter: {rel}",
        "placeholders": "{n} placeholder(s) to customize in {rel}",
        "stale_inbox": "inbox item waiting for {age} days: {rel}",
        "overdue": "recurring item due on {due}: {rel}",
        "decision": "decision due for review since {review}: {rel}",
        "summary": "  Inbox: {inbox} item(s) | needs action: {n} (run .claude/scripts/brain-lint.py)",
        "action": "ACTION",
        "total": "{notes} note(s), {inbox} in the inbox, {n} need action.",
    },
    "pt-BR": {
        "broken": "link quebrado: {rel} -> [[{target}]]",
        "no_frontmatter": "sem frontmatter: {rel}",
        "placeholders": "{n} placeholder(s) para personalizar em {rel}",
        "stale_inbox": "caixa de entrada parada há {age} dias: {rel}",
        "overdue": "recorrente vencida em {due}: {rel}",
        "decision": "decisão para revisar desde {review}: {rel}",
        "summary": "  Inbox: {inbox} item(s) | precisa de ação: {n} (rode .claude/scripts/brain-lint.py)",
        "action": "AÇÃO",
        "total": "{notes} nota(s), {inbox} na caixa de entrada, {n} pedem ação.",
    },
}


def language():
    try:
        lang = json.loads((VAULT / "vault-config.json").read_text(encoding="utf-8")).get("language", "en")
    except (OSError, ValueError):
        lang = "en"
    return lang if lang in MESSAGES else "en"


def notes():
    for path in VAULT.rglob("*.md"):
        rel = path.relative_to(VAULT)
        if rel.parts[0] in SKIP or path.is_symlink():
            continue
        yield rel, path.read_text(encoding="utf-8", errors="replace")


def frontmatter(text):
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    return dict(FIELD.findall(text[4:end])) if end != -1 else None


def as_date(value):
    try:
        return dt.date.fromisoformat(str(value).strip()[:10])
    except ValueError:
        return None


def main():
    m = MESSAGES[language()]
    all_notes = list(notes())
    names = {p.stem for p in VAULT.rglob("*") if p.is_file()} | {p.name for p in VAULT.rglob("*")}
    action, info = [], []

    for rel, text in all_notes:
        meta = frontmatter(text)
        for target in WIKILINK.findall(CODE.sub("", text)):
            target = target.strip()
            if Path(target).name not in names and "[" not in target:
                action.append(m["broken"].format(rel=rel, target=target))
        if meta is None and rel.parts[0] in NEEDS_FRONTMATTER:
            action.append(m["no_frontmatter"].format(rel=rel))
        placeholders = sum(text.count(token) for token in PLACEHOLDERS)
        if placeholders:
            info.append(m["placeholders"].format(n=placeholders, rel=rel))
        meta = meta or {}
        if rel.parts[0] == "Inbox":
            created = as_date(meta.get("date")) or dt.date.fromtimestamp((VAULT / rel).stat().st_mtime)
            age = (TODAY - created).days
            if age > INBOX_MAX_DAYS:
                action.append(m["stale_inbox"].format(age=age, rel=rel))
        due = as_date(meta.get("next_due"))
        if due and due < TODAY:
            action.append(m["overdue"].format(due=due, rel=rel))
        review = as_date(meta.get("review_on"))
        if review and review < TODAY and meta.get("status", "").strip() not in REVIEWED:
            action.append(m["decision"].format(review=review, rel=rel))

    inbox = sum(1 for rel, _ in all_notes if rel.parts[0] == "Inbox")
    if "--summary" in sys.argv:
        print(m["summary"].format(inbox=inbox, n=len(action)))
    else:
        for line in action:
            print(f"{m['action']}  {line}")
        for line in info:
            print(f"INFO  {line}")
        print(m["total"].format(notes=len(all_notes), inbox=inbox, n=len(action)))
    return 1 if action else 0


if __name__ == "__main__":
    sys.exit(main())
