# AGENTS.md

Constitution für jeden AI-Agenten, der in diesem Projekt arbeitet — Claude Code, Codex, oder andere. Diese Datei und `CLAUDE.md` sind via Symlink **identisch**.

Universelle Web-Pflicht-Standards stehen in `./web-standards/AGENTS.md` (Snapshot der Everlast Web Standards 2026, mit jedem Release versioniert).

## Setup

```bash
nvm use && npm install
```

Voraussetzungen (einmalig, global):

- Node ≥ 20 (siehe `.nvmrc`)
- `lighthouse` und `@axe-core/cli` für den Audit-Skill: `npm i -g lighthouse @axe-core/cli`

Dann den `everlast-web-setup` Skill in Claude Code / Codex triggern — er fragt Stack, Brand, Domain, BFSG-Relevanz ab, **scaffoldt den gewählten Stack automatisch** (Astro/Next/SvelteKit/Nuxt non-interaktiv) und ersetzt die `{{PLACEHOLDER}}`-Tokens in `public/*` und `SECURITY.md`.

## Workflow (drei Phasen, drei Skills)

```
1. /everlast-web-setup    →  Kontext-Abfrage, Auto-Scaffold, Pflicht-Files + stack-spezifische Configs (CSP, Header, JSON-LD)
2. /everlast-web-design   →  DESIGN.md, Brand-DNA, Anti-Slop, Visual-Diff-Loop (Playwright MCP)
3. Bauen
4. /everlast-web-audit    →  vor jedem Release (Lighthouse + Mozilla Observatory + PageSpeed Insights)
```

## Wann was triggert

- **Neue Seite, robots.txt, CSP, Manifest, security.txt** → `everlast-web-setup`
- **DESIGN.md, "sieht generisch aus", Brand-Refactor** → `everlast-web-design`
- **URL gegeben + "prüfen" / "Lighthouse" / "Pre-Launch"** → `everlast-web-audit`

## Pflicht-Files im Repo (stack-agnostisch)

Bereits im Template mit `{{PLACEHOLDER}}`-Tokens — der Setup-Skill füllt sie:

- `public/robots.txt` mit AI-Crawler-Defaults (GPTBot, ClaudeBot, Google-Extended, PerplexityBot, Applebot-Extended)
- `public/sitemap.xml`
- `public/llms.txt` für AI-Discoverability
- `public/.well-known/security.txt` mit `Expires` 12 Monate
- `public/site.webmanifest`
- `public/404.html`, `public/500.html`
- `SECURITY.md`

Nicht im Template (stack- oder asset-spezifisch, kommt durch Skill oder manuell):

- Favicons (SVG + 192/512/180-PNG) — brand-Asset, pro Projekt
- CSP/Security-Header (`vercel.json`, `next.config.js`, nginx, Cloudflare)
- JSON-LD Organization auf Homepage

## Build / Test / Audit

```bash
# Stack-spezifisch, wird durch den gewählten Stack ergänzt:
npm run dev          # local dev
npm run build        # production build
npm test             # falls Tests existieren
```

Audit triggert man in Claude Code/Codex direkt via `/everlast-web-audit <URL>`. Kein `npm run audit` — der Skill ist context-aware und braucht keine npm-Mechanik.

## Git-Workflow

- **Branches**: `feat/<topic>`, `fix/<topic>`, `chore/<topic>`, `docs/<topic>`
- **Commits**: Conventional Commits als Empfehlung (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `perf:`) — kein Hook erzwingt das, aber CHANGELOG-Generierung + PR-Review profitieren davon
- **Solo-Repos**: direct push auf `main` ist okay
- **Multi-Contributor-Repos**: GitHub Branch Protection auf `main` aktivieren (Settings → Branches → Add rule: require PR + status checks)

## Code-Standards

- TypeScript strict mode bevorzugen
- Frühe Returns statt tiefer Verschachtelung
- Input-Validierung an System-Grenzen (Zod / TypeBox / valibot)
- Mindestens Happy Path + 1 Edge Case pro öffentlicher Funktion
- Keine leeren catch-Blöcke
- Web-Standards: alle MUSTs aus `./web-standards/AGENTS.md` einhalten

## Sicherheit

- Niemals secrets committen — `.env*` ist gitignored
- Vor Push: `git diff --cached | grep -iE "(api[_-]?key|secret|token|password)"` als Spot-Check
- Bei BFSG-Relevanz (B2C-Shop, Banking, Buchung): zusätzlich `@axe-core/cli` mit `--tags wcag22aa` vor Merge

## Standards aktuell halten

Standards-Updates kommen über das öffentliche Repo (`git pull` oder neuen Template-Klon). Versions-Marker liegt in `web-standards/.snapshot-version`.

Das interne Maintainer-Script `scripts/update-standards.sh` ist für externe Nutzer nicht relevant.

## Antwort-Stil (für AI-Agenten)

- Auf Deutsch antworten (User-Präferenz), Code / Header / Commits / Werte auf Englisch
- Knapp, direkt, strukturiert — erst Plan, dann Umsetzung
- Em-dashes in user-facing Copy sparsam — maximal einer pro längerem Absatz
- Bei BFSG-Relevanz aktiv darauf hinweisen
- Bei DSGVO-Verstößen (Google Fonts CDN, hardcoded reCAPTCHA, US-Tools ohne AVV) klar markieren

## Anti-Patterns

- ❌ Standards aus dem Kopf rezitieren statt `./web-standards/AGENTS.md` zu lesen
- ❌ Generische `robots.txt` ohne AI-Crawler-Konfiguration
- ❌ CSP mit `unsafe-inline` ohne dokumentierte Begründung
- ❌ Google Fonts via `fonts.googleapis.com` einbauen
- ❌ Mehrere `<h1>` pro Seite
- ❌ Bilder ohne `width`/`height`-Attribute
- ❌ `security.txt` ohne `Expires` oder mit `Expires < heute`
