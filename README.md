# Launchgrade — Web Standards 2026

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Stack-agnostic starter template + technical baseline for modern web projects (2026 edition). Compliance-grade defaults for EU markets (BFSG / GDPR / TDDDG), Core Web Vitals, security headers, AI-crawler policy, and anti-slop design hygiene. Operationalized as three Claude Code skills.

> The standards documentation in `web-standards/` is intentionally in German — it cites German/EU legal frameworks (BFSG, DDG, TDDDG, MStV, ECJ rulings) where translation would lose legal precision. Tech terms (WCAG, CWV, CSP, JSON-LD) are English throughout, so most of the document is readable without German.

## How to use

You drive this template through an AI agent (Claude Code, Codex, Cursor). The template itself installs nothing.

1. Click **"Use this template"** on this repo → "Create a new repository"
2. Open the new repo in **Claude Code** (or Codex / Cursor)
3. Say: **"setup"**

The agent reads `AGENTS.md`, asks for stack, brand, domain, and BFSG relevance, then fills in everything. If a Node-based stack (Astro / Next / SvelteKit / Nuxt) is chosen, the agent installs Node on demand — it never installs anything upfront.

## What you actually need installed

- **A browser**
- **An AI agent** — [Claude Code](https://docs.claude.com/en/docs/claude-code), Codex, or Cursor
- **Git** — or just use the GitHub template button + GitHub web editor

That's it. No Node, no nvm, no global CLIs. Anything beyond this is installed on demand by the agent, only when your stack choice requires it.

## What's inside

- **Launchgrade Web Standards 2026** (`web-standards/AGENTS.md` + `checklist.md`) — versioned baseline covering Performance (Core Web Vitals 2026), Accessibility (WCAG 2.2 AA + BFSG), SEO (classic + AI-crawler era), Security (CSP, headers, cookies, auth), Privacy (GDPR / TDDDG), Motion, PWA. RFC-2119 levels (MUST / Conditional MUST / SHOULD / MAY).
- **Three Claude Code skills** (`.claude/skills/`) — Foundation → Design → Audit:
  - `launchgrade-setup` — scaffolds required artifacts (robots.txt with AI-crawler defaults, security.txt, CSP, JSON-LD, favicon set, manifest, 404/500), optionally scaffolds the chosen stack
  - `launchgrade-design` — anti-slop design layer, DESIGN.md, named aesthetics, visual-diff loop
  - `launchgrade-audit` — pre-/post-launch via PageSpeed Insights + Mozilla Observatory (web-based, zero install); Lighthouse CLI optional
- **Required files** in `public/` with `{{PLACEHOLDER}}` tokens (robots.txt, sitemap.xml, llms.txt, security.txt, site.webmanifest, 404/500)
- **Claude Code settings** (`.claude/settings.json`) — permission allowlist for audit tooling, deny rules against force push and publish

## Workflow

```
1. /launchgrade-setup    →  fill placeholders, optional stack scaffold, required files + configs (CSP, headers, JSON-LD)
2. /launchgrade-design   →  DESIGN.md, brand DNA, anti-slop
3. Build
4. /launchgrade-audit    →  pre-launch (PageSpeed Insights + Observatory), findings as Blockers / Recommended / Nice-to-have
```

## Reading the standards directly

- **[`web-standards/AGENTS.md`](web-standards/AGENTS.md)** — full standards with §-structure and pass thresholds
- **[`web-standards/checklist.md`](web-standards/checklist.md)** — compact pre-launch checklist

These files are self-contained — you don't need the template or the skills to use them as a reference. Also usable as a contract appendix ("Conformance to Launchgrade Web Standards 2026").

## What's NOT in the template

- Framework-specific code (Next.js, Astro, SvelteKit) — the setup skill scaffolds the chosen stack on demand
- DESIGN.md — per project via `launchgrade-design`
- Favicons as PNG/ICO — brand asset, per project
- CI/CD setup — intentionally omitted for solo / small-team repos
- `package.json` at root — there's nothing to install; the chosen stack adds its own

## Manual path (no agent)

If you really want to work without an agent: clone the repo, edit the `{{PLACEHOLDER}}` tokens in `public/*` and `SECURITY.md` by hand, follow `web-standards/checklist.md`, deploy. The standards work as a contract reference even without the skill workflow.

## Stack choice

See [`docs/STACK_CHOICE.md`](docs/STACK_CHOICE.md) — decision matrix for marketing site / blog / shop / SaaS marketing.

## Contributing

Issues and pull requests welcome. For larger changes, please open an issue first. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for branch conventions and commit style.

## Maintenance

Best-effort maintenance. No SLA, no warranty — see [`LICENSE`](LICENSE). Standards updates follow the changelog in `web-standards/AGENTS.md`.

> The script `scripts/update-standards.sh` is a maintainer-only bash tool for syncing from a private standards source repo and is not relevant for external users — the snapshot in `web-standards/` is already self-contained.

## License

[MIT](LICENSE) © Everlast Consulting GmbH
