# Contributing

Schlanke Konventionen für Solo-Repos — kein Enforcement-Layer, kein CI, AI übernimmt Format & Style.

## Branches

- `main` — production
- `feat/<topic>` — neue Features
- `fix/<topic>` — Bugfixes
- `chore/<topic>` — Maintenance

Wenn ein Projekt Multi-Contributor wird, **GitHub Branch Protection** auf `main` aktivieren (Settings → Branches → Add rule: require PR, require status checks). Bei Solo-Repos kein Pflicht-Schritt — direct push auf main ist okay.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/) als Empfehlung:

```
feat: add cookie consent banner
fix: correct hreflang on de/en switch
refactor: extract header into component
docs: update CSP example
chore(deps): bump astro to 5.4
perf: lazy-load below-fold images
```

Kein Hook erzwingt das — nutze es als Konvention, weil CHANGELOG-Generierung und PR-Review davon profitieren.

## Standards

Alle Änderungen müssen die Everlast Web Standards einhalten — `./web-standards/AGENTS.md` (Snapshot) oder Standards-Repo (Source of Truth).

Bei BFSG-relevanten Projekten zusätzlich `@axe-core/cli` vor Merge auf `main`.

## Git-Settings (einmalig pro Projekt)

Empfohlen aber optional:

```bash
git config commit.gpgsign true       # Signierte Commits (wenn GPG eingerichtet)
git config pull.rebase true          # rebase statt merge auf pull
git config core.autocrlf input       # LF beibehalten, CRLF auf Input convertieren
```
