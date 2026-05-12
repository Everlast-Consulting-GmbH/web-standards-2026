# Security Policy

## Reporting a Vulnerability

Sicherheitslücken bitte vertraulich melden:

- **Email**: {{SECURITY_EMAIL}}
- **Subject**: `[SECURITY] <Projektname>`

Antwort innerhalb von 72 Stunden. Bitte keine Details öffentlich posten, bis ein Fix released ist.

## Pflicht-Header pro Projekt

Siehe `./web-standards/AGENTS.md` §5 — alle Security-Header sind dort als MUST/SHOULD spezifiziert.

## Secret-Scan

`.env*` ist gitignored. Vor Push manuell prüfen:

```bash
git diff --cached | grep -iE "(api[_-]?key|secret|token|password)" || echo "✓ keine offensichtlichen Secrets"
```
