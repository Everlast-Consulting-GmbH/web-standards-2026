# AGENTS.md

Constitution for any AI agent working in this project — Claude Code, Codex, or others. This file and `CLAUDE.md` are identical (symlink).

The technical web baseline lives in `./web-standards/AGENTS.md` (snapshot of the Launchgrade Web Standards 2026, versioned per release). That document is intentionally in German because it references German/EU legal frameworks (BFSG, DDG, TDDDG, MStV, EU rulings).

## Setup

```bash
nvm use && npm install
```

Global prerequisites (once):

- Node ≥ 20 (see `.nvmrc`)
- `lighthouse` and `@axe-core/cli` for the audit skill: `npm i -g lighthouse @axe-core/cli`

Then trigger the `launchgrade-setup` skill in Claude Code / Codex — it asks for stack, brand, domain, BFSG relevance, **auto-scaffolds the chosen stack** (Astro/Next/SvelteKit/Nuxt, non-interactive), and replaces the `{{PLACEHOLDER}}` tokens in `public/*` and `SECURITY.md`.

## Workflow (three phases, three skills)

```
1. /launchgrade-setup    →  context capture, auto-scaffold, required files + stack-specific configs (CSP, headers, JSON-LD)
2. /launchgrade-design   →  DESIGN.md, brand DNA, anti-slop, visual-diff loop (Playwright MCP)
3. Build
4. /launchgrade-audit    →  before every release (Lighthouse + Mozilla Observatory + PageSpeed Insights)
```

## When does what trigger

- **New page, robots.txt, CSP, manifest, security.txt** → `launchgrade-setup`
- **DESIGN.md, "looks generic", brand refactor** → `launchgrade-design`
- **URL given + "audit" / "Lighthouse" / "pre-launch"** → `launchgrade-audit`

## Required files in the repo (stack-agnostic)

Already in the template with `{{PLACEHOLDER}}` tokens — the setup skill fills them:

- `public/robots.txt` with AI-crawler defaults (GPTBot, ClaudeBot, Google-Extended, PerplexityBot, Applebot-Extended)
- `public/sitemap.xml`
- `public/llms.txt` for AI discoverability
- `public/.well-known/security.txt` with `Expires` 12 months out
- `public/site.webmanifest`
- `public/404.html`, `public/500.html`
- `SECURITY.md`

Not in the template (stack- or asset-specific, comes via skill or manually):

- Favicons (SVG + 192/512/180 PNG) — brand asset, per project
- CSP / security headers (`vercel.json`, `next.config.js`, nginx, Cloudflare)
- JSON-LD Organization on the homepage

## Build / test / audit

```bash
# Stack-specific, added by the chosen stack:
npm run dev          # local dev
npm run build        # production build
npm test             # if tests exist
```

Trigger the audit directly via `/launchgrade-audit <URL>` in Claude Code / Codex. No `npm run audit` — the skill is context-aware and needs no npm wiring.

## Git workflow

- **Branches**: `feat/<topic>`, `fix/<topic>`, `chore/<topic>`, `docs/<topic>`
- **Commits**: Conventional Commits as a recommendation (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `perf:`) — no hook enforces this, but changelog generation and PR review benefit from it
- **Solo repos**: direct push to `main` is fine
- **Multi-contributor repos**: enable GitHub Branch Protection on `main` (Settings → Branches → Add rule: require PR + status checks)

## Code standards

- Prefer TypeScript strict mode
- Early returns over deep nesting
- Input validation at system boundaries (Zod / TypeBox / valibot)
- At minimum happy path + 1 edge case per public function
- No empty catch blocks
- Web standards: honor all MUSTs from `./web-standards/AGENTS.md`

## Security

- Never commit secrets — `.env*` is gitignored
- Before push, spot-check: `git diff --cached | grep -iE "(api[_-]?key|secret|token|password)"`
- For BFSG-relevant projects (B2C shop, banking, booking): run `@axe-core/cli` with `--tags wcag22aa` before merge

## Keeping standards current

Standards updates come via the public repo (`git pull` or fresh template clone). Version marker lives in `web-standards/.snapshot-version`.

The maintainer-only script `scripts/update-standards.sh` is not relevant for external users.

## Response style (for AI agents)

- The standards documentation in `web-standards/` is in German. When answering questions about it, respond in the language the user used. Code / headers / commits / tokens stay in English.
- Concise, direct, structured — plan first, then execute
- Em-dashes in user-facing copy: use sparingly — maximum one per longer paragraph
- For BFSG relevance: flag proactively
- For GDPR violations (Google Fonts CDN, hardcoded reCAPTCHA, US tools without DPA): mark clearly

## Anti-patterns

- ❌ Reciting standards from memory instead of reading `./web-standards/AGENTS.md`
- ❌ Generic `robots.txt` without AI-crawler configuration
- ❌ CSP with `unsafe-inline` without documented justification
- ❌ Embedding Google Fonts via `fonts.googleapis.com`
- ❌ Multiple `<h1>` per page
- ❌ Images without `width`/`height` attributes
- ❌ `security.txt` without `Expires` or with `Expires < today`
