# Web Standards 2026

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Stack-agnostisches Starter-Template + technische Pflicht-Baseline für moderne Web-Projekte (Stand 2026). Maintained von [Everlast Consulting GmbH](https://everlast.ai).

Was drin ist:

- **Everlast Web Standards 2026** (`web-standards/AGENTS.md` + `checklist.md`) — versionierte Baseline für Performance (Core Web Vitals 2026), Accessibility (WCAG 2.2 AA + BFSG), SEO (klassisch + AI-Crawler), Security (CSP, Header), Privacy (DSGVO/TDDDG), Motion, PWA. Mit RFC-2119-Härtegraden (MUST / Conditional MUST / SHOULD / MAY).
- **Drei Claude-Code-Skills** (`.claude/skills/`) — Workflow Foundation → Design → Audit:
  - `everlast-web-setup` — Pflicht-Artefakte scaffolden (robots.txt mit AI-Crawler-Defaults, security.txt, CSP, JSON-LD, Favicon-Set, Manifest, 404/500)
  - `everlast-web-design` — Anti-Slop Design-Layer, DESIGN.md, Named Aesthetics, Visual-Diff-Loop
  - `everlast-web-audit` — Pre-/Post-Launch via Lighthouse + Mozilla Observatory + PageSpeed Insights
- **Pflicht-Files** in `public/` mit `{{PLACEHOLDER}}`-Tokens (robots.txt, sitemap.xml, llms.txt, security.txt, site.webmanifest, 404/500)
- **Claude Code Settings** (`.claude/settings.json`) — Permissions-Allowlist für die Audit-Tools, Deny-Regeln gegen Force-Push und Publish
- **Dev-Defaults**: `.gitignore`, `.nvmrc` (Node 20+)

## Nutzung

```bash
# Template klonen
git clone https://github.com/Everlast-Consulting-GmbH/web-standards-2026.git meine-neue-site
cd meine-neue-site
rm -rf .git && git init

# Dependencies (für lokales Tooling, falls vorhanden)
nvm use && npm install

# Audit-CLIs einmalig global
npm install -g lighthouse @axe-core/cli
```

Dann in Claude Code: `/everlast-web-setup` triggern. Der Skill fragt Stack, Brand, Domain, BFSG-Relevanz ab und füllt die Platzhalter.

## Workflow

```
1. /everlast-web-setup    →  Placeholder füllen, Stack scaffolden, Pflicht-Files + Configs (CSP, Header, JSON-LD)
2. /everlast-web-design   →  DESIGN.md, Brand-DNA, Anti-Slop
3. Bauen
4. /everlast-web-audit    →  Pre-Launch (Lighthouse + Observatory + PSI), Findings als Blocker/Empfohlen/Nice-to-have
```

## Standards einsehen

- **[`web-standards/AGENTS.md`](web-standards/AGENTS.md)** — die vollständigen Standards mit §-Struktur und Pass-Schwellen
- **[`web-standards/checklist.md`](web-standards/checklist.md)** — kompakte Pre-Launch-Checkliste zum Abhaken

Diese Dateien sind self-contained — du brauchst weder das Template noch die Skills zu nutzen, um die Standards als Referenz heranzuziehen. Auch verwendbar als Vertragsanhang ("Konformität mit Everlast Web Standards 2026").

## Was NICHT im Template ist

- Framework-spezifischer Code (Next.js, Astro, SvelteKit) — der Setup-Skill scaffoldet den gewählten Stack
- DESIGN.md — pro Projekt individuell via `everlast-web-design`
- Favicons als PNG/ICO — Brand-Asset, pro Projekt
- CI/CD-Setup — bewusst weggelassen für Solo-/Small-Team-Repos

## Stack-Entscheidung

Siehe [`docs/STACK_CHOICE.md`](docs/STACK_CHOICE.md) — Entscheidungsmatrix für Marketing-Site / Blog / Shop / SaaS-Marketing.

## Beitragen

Issues und Pull Requests sind willkommen. Größere Änderungen bitte vorher als Issue diskutieren. Siehe [`CONTRIBUTING.md`](CONTRIBUTING.md) für Branch-Konventionen und Commit-Style.

## Maintenance

Best-effort Maintenance durch Everlast Consulting GmbH. Keine SLA, keine Garantien — siehe [`LICENSE`](LICENSE). Standards-Updates folgen dem Changelog in `web-standards/AGENTS.md`.

> Das Script `scripts/update-standards.sh` ist ein Maintainer-Tool zum Syncen aus einem zentralen Standards-Quellrepo und für externe Nutzer nicht relevant — der Snapshot in `web-standards/` ist bereits self-contained.

## Lizenz

[MIT](LICENSE) © Everlast Consulting GmbH
