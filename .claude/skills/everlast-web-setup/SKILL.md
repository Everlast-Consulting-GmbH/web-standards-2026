---
name: everlast-web-setup
description: Setup neuer Web-Projekte nach Everlast Web Standards 2026. Generiert Pflicht-Artefakte (HTML-Head, robots.txt mit AI-Crawler-Defaults, sitemap.xml, security.txt, manifest, Favicon-Set, CSP-Config stack-spezifisch, 404/500, llms.txt, Projekt-AGENTS.md). Triggert bei "neue Website", "Setup", "Projekt starten", "Boilerplate", "Pflicht-Files", "neue Landing Page".
---

# Everlast Web Setup Skill

Erste Phase im Everlast-Web-Workflow: **Foundation**. Generiert die technischen Pflicht-Artefakte aus §1, §5, §9 der AGENTS.md.

## Wann triggern

- Neues Web-Projekt: Marketing-Site, Shop, Buchung, SaaS-Marketing-Frontend, Landing Page
- Migration eines Bestandsprojekts auf Everlast-Standards (Initialphase)
- Konkrete Setup-Fragen: CSP, robots.txt für AI-Bots, Manifest, Favicons, security.txt, hreflang

Nicht triggern bei: Backend-/Admin-Tasks, internem Tooling, ML-Pipelines, reinen Design-/Brand-Fragen (→ `everlast-web-design`), Audit/Pre-Launch-Check (→ `everlast-web-audit`).

## Wo die Wahrheit liegt

Standards liegen in `./web-standards/AGENTS.md` und `./web-standards/checklist.md` im Repo-Root. Snapshot der Everlast Web Standards 2026, mit jedem Release versioniert.

Relevante Kapitel für Setup:
- §1 HTML & Document Baseline
- §5 Security
- §7 Browser-Support, Responsive & i18n
- §8 PWA & Manifest
- §10 Pflicht-Dateien im Repo-Root

**Pflicht-Schritt:** Vor jeder Generierung das relevante Kapitel mit Read laden. Nicht aus dem Gedächtnis arbeiten — Standards können sich ändern.

## Vorgehen

1. **Kontext abfragen (kompakt, in einem Schwung):**

   **Stack** — Auswahl mit kurzem Vorteil pro Option direkt sichtbar machen (nicht erst nachfragen). WordPress wird **nicht** angeboten (PHP-CMS-Workflow ist mit KI-Pipeline nicht effizient, Edge-CSP / Nonce / `llms.txt`-Tooling fehlen out-of-the-box).

   | Stack | Vorteil (kurz) | Wann nehmen |
   |---|---|---|
   | **Astro** (Default-Empfehlung) | Beste Lighthouse-Scores out-of-the-box, near-zero JS, Islands lazy-loaden Animationen pro Section. Satisfaction-Leader 2025 (94 %). | Marketing-Sites, Blogs, Doku, Multi-Page mit überwiegend statischem Content + gezielter Interaktivität. |
   | **Next.js** | Größtes Ökosystem (~60 % Marktanteil), beste AI-Tool-Unterstützung, Server Actions für Forms, Auth-Flows + Backend co-located. | App-artiges: Dashboards, E-Commerce, Auth, dynamische Listen, SSR/ISR. |
   | **Plain HTML** | Null Toolchain, schnellster Build, kein Deploy-Setup nötig. | Echte One-Pager / Landing Pages ohne Forms — Form-Service (Formspree, Resend) reicht. |
   | **SvelteKit** | Schlankere Runtime als Next, weniger Bundle-Size. | Nur wenn Team Svelte-präferent — kleineres Ökosystem als React. |
   | **Nuxt** | Wie Next, aber Vue-basiert. | Nur wenn Team Vue-locked — sonst Next oder Astro. |

   **Faustregel:** Bei Unsicherheit → **Astro** (Default). Bei "viele Forms / Auth / Dashboards" → **Next.js**. Bei "Single Landing-Page" → **Plain HTML**.

   **Domain** — Final-URL (z.B. `everlast.ai`).

   **Sprache(n)** — Default `de`, bei i18n auch `hreflang`-Schema (z.B. `de,en`).

   **Geltungsbereich** — B2C-Shop / Banking / Buchung → **BFSG-relevant** (im Output markieren, `accessibility-statement.md` mitgenerieren).

   **Brand-Name** + **Tagline** (1-Satz).

   **Primärfarbe** — akzeptiere **drei Eingabe-Formate**, frag explizit:
   - **Hex / OKLCH / RGB-Code direkt** (z.B. `#0E7C66` oder `oklch(0.65 0.18 165)`). Schnellster Weg.
   - **Bild-Pfad** (Logo, Brand-Asset, Moodboard als `.png/.jpg/.svg`). Lade das Bild mit `Read` (multimodal), identifiziere die dominante Brand-Farbe, normalisiere auf Hex + OKLCH und bestätige beim User vor dem Schreiben.
   - **Referenz-URL** (existierende Website / Brand-Page). Nutze `WebFetch`, suche nach `<meta name="theme-color">`, CSS-Custom-Properties (`--color-primary`, `--brand`), oder dominanten Inline-Styles. Bei Unklarheit zwei Kandidaten zur Wahl stellen.

   Bei Bild- oder URL-Input: gib den extrahierten Wert **vor dem Schreiben** zur Bestätigung zurück. Falls die Quelle keine eindeutige Primärfarbe hergibt, frag nach Hex-Fallback.

2. **AGENTS.md §1, §5, §7, §8, §10 lesen.**

3. **Auto-Scaffold (nach Kontext, ohne weitere Rückfrage):**

   **Pre-Check (Bash):** prüfe ob ein Stack bereits initialisiert wurde — wenn ja, Scaffold überspringen und im Output vermerken.

   ```bash
   if [ -f package.json ] || [ -f astro.config.mjs ] || [ -f astro.config.ts ] \
     || [ -f next.config.js ] || [ -f next.config.ts ] || [ -f next.config.mjs ] \
     || [ -f svelte.config.js ] || [ -f nuxt.config.ts ]; then
     echo "STACK_ALREADY_PRESENT"
   fi
   ```

   **Wenn frisch (kein STACK_ALREADY_PRESENT):** Stack-spezifischen Non-Interactive-Befehl ausführen — keine User-Bestätigung einholen, das ist reine Mechanik. Annahmen aus User-CLAUDE.md: **npm**, **TypeScript strict**, App-Router-Pattern.

   | Stack | Scaffold-Befehl (non-interactive) |
   |---|---|
   | **Astro** | `npm create astro@latest . -- --template minimal --typescript strict --install --git --skip-houston --yes` |
   | **Next.js** | `npx create-next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*" --use-npm --eslint --yes` |
   | **SvelteKit** | `npx sv create . --template minimal --types ts --no-add-ons --install npm` |
   | **Nuxt** | `npx nuxi@latest init . --packageManager npm --gitInit --force` |
   | **Plain HTML** | kein Scaffold — Template-Files bleiben Repo-Wurzel. |

   **Konflikt-Handling:** Scaffold läuft in nicht-leerem Dir (Template-Pflicht-Files in `public/` existieren bereits). Astro/Next melden ggf. existing files — die Pflicht-Files werden danach in Phase 4 sowieso überschrieben, also Output ignorieren und weitermachen. Bei harten Fehlern (npm-Install-Crash, fehlende Berechtigung): abbrechen und User-Output mit konkretem Fix vorschlagen.

   **Nach dem Scaffold:** kurz mit `ls` verifizieren dass `package.json` + Framework-Config existieren.

4. **Pflicht-Files anpassen ODER generieren:**

   **Fall A — Template-Klon (häufig):** `public/robots.txt`, `public/sitemap.xml`, `public/llms.txt`, `public/site.webmanifest`, `public/.well-known/security.txt`, `public/404.html`, `public/500.html`, `SECURITY.md` existieren bereits mit `{{PLACEHOLDER}}`-Tokens. Ersetze sie via `Edit` mit den User-Werten:
   - `{{BRAND_NAME}}`, `{{BRAND_TAGLINE}}`, `{{DOMAIN}}`, `{{LANG}}`, `{{BRAND_PRIMARY}}`, `{{CONTACT_EMAIL}}`, `{{SECURITY_EMAIL}}`, `{{SECURITY_EXPIRES}}` (12 Monate ab heute, ISO 8601)
   - Schreibe danach `project.config.json` ins Repo-Root mit den gleichen Werten + `standards_snapshot` (Inhalt von `web-standards/.snapshot-version`)

   **Fall B — Greenfield ohne Template:** Pflicht-Artefakte from-scratch generieren:
   - HTML5-Boilerplate-`<head>` mit Pflicht-Metas (charset, viewport, title, description, canonical, OG, Twitter Card, color-scheme, theme-color)
   - `/robots.txt` mit AI-Crawler-Defaults (GPTBot, ClaudeBot, Claude-SearchBot, Google-Extended, PerplexityBot, Applebot-Extended, OAI-SearchBot, Meta-ExternalAgent) — explizite Allow/Disallow-Policy, keine Default-Schwammigkeit
   - `/sitemap.xml` (Template oder Generator-Hook) + Verweis in robots.txt
   - `/llms.txt` mit H1 + 1-Satz-Site-Summary + Sections-Links (für AI-Discoverability)
   - `/site.webmanifest` mit Pflicht-Feldern (name, short_name, icons 192/512, theme_color, background_color, display, start_url)
   - `/.well-known/security.txt` mit `Expires` 12 Monate in der Zukunft
   - Security-Header-Config stack-spezifisch (`vercel.json`, `next.config.js`, nginx-Block, Cloudflare-Workers, Apache `.htaccess`)
   - CSP Level 3 mit Nonce-Pattern, `frame-ancestors 'self'` + Allowlist falls Whitelabel-Previews / Kunden-Embeds
   - JSON-LD Organization + WebSite auf Homepage, BreadcrumbList Template
   - Favicon-Set (SVG + 32/180/512 PNG) — RealFaviconGenerator-Hinweis bei Bedarf
   - `/404.html` und `/500.html` Templates mit Branding
   - **Projekt-eigene `AGENTS.md`** im Repo-Root mit: Setup, Build, Test, Conventions, Deploy, Verweis auf Everlast-Web-Standards-Repo
   - Bei BFSG-Relevanz: `accessibility-statement.md` Template + Hinweis auf Pflicht (ab Juni 2025)

   **Default-Welcome-Page ersetzen:** Der Scaffold legt eine Framework-Welcome-Page ab (`src/pages/index.astro`, `app/page.tsx`, `src/routes/+page.svelte`, `app.vue`). Ersetze sie durch einen **minimalen Placeholder** — kein Marketing-Text, keine Sections, keine Designs:

   ```
   <h1>{{BRAND_NAME}}</h1>
   <p>{{BRAND_TAGLINE}}</p>
   <p><small>Setup abgeschlossen. Inhalt und Design folgen mit /everlast-web-design.</small></p>
   ```

   Begründung: solange Default-Content steht, ist die Versuchung groß "drauf aufzubauen" und damit Brand-DNA aus dem Skill `everlast-web-design` zu umgehen. Saubere Übergabe = klarer Stopppunkt.

5. **Smoke-Test im Browser (Foundation-Verifikation, kein Visual-Diff):**

   **Tool-Wahl in dieser Präferenz-Reihenfolge** — erstes verfügbares Tool gewinnt, nicht hardcoden:
   1. `agent-browser` CLI — wenn `command -v agent-browser` erfolgreich
   2. Chrome MCP / `claude-in-chrome` — wenn `mcp__claude-in-chrome__*` Tools verfügbar
   3. Playwright via `npx playwright` — Fallback
   4. Keines verfügbar → Phase überspringen mit Hinweis im Output, Foundation bleibt valid

   **Ablauf:**

   a) Dev-Server im Hintergrund starten (Stack-Default-Port):
      - Astro: `npm run dev` → 4321
      - Next.js: `npm run dev` → 3000
      - SvelteKit: `npm run dev` → 5173
      - Nuxt: `npm run dev` → 3000
      - Plain HTML: `npx serve public -p 8080`

      Bash mit `run_in_background: true`, dann 3–5 s warten bis Ready.

   b) Browser-DOM-Check auf `http://localhost:<port>/`:
      - `<title>` enthält `{{BRAND_NAME}}`
      - `<meta name="theme-color">` = `{{BRAND_PRIMARY}}`
      - `<html lang="{{LANG}}">` gesetzt
      - genau 1 `<h1>` im DOM

   c) Pflicht-Files via `curl` (ohne Browser):
      ```bash
      for p in /robots.txt /sitemap.xml /llms.txt /site.webmanifest /.well-known/security.txt; do
        curl -fsSL -o /dev/null -w "%{http_code} $p\n" "http://localhost:<port>$p"
      done
      ```
      Plus inhaltliche Checks:
      - `robots.txt` enthält `GPTBot` (AI-Crawler-Konfig vorhanden)
      - `security.txt` `Expires` ≥ heute (ISO-Datum parsen)
      - `site.webmanifest` `theme_color` === `{{BRAND_PRIMARY}}`

   d) Dev-Server killen (`kill -TERM $BG_PID`) — keine Zombie-Prozesse.

   e) Report:
      ```
      Smoke-Test (<tool>):
        DOM:    title ✓  theme-color ✓  lang ✓  h1 ✓
        Files:  robots ✓  sitemap ✓  llms ✓  manifest ✓  security ✓
        Status: PASS
      ```

   Bei Fail: Skill bricht **nicht** ab — Foundation steht, der konkrete Fehler kommt in den Output als Aufgabe für den User / nächste Phase.

6. **Übersicht ausgeben:** kurze Liste "Was wurde gesetzt" mit Pfaden + Scaffold-Status (frisch initialisiert / bereits vorhanden / Plain HTML) + Smoke-Test-Ergebnis + expliziter Hinweis "Content + Visual Design folgen — bitte `/everlast-web-design` aufrufen, nicht selbst Hero/Sections schreiben".

## Verhalten

- AGENTS.md immer lesen vor Generierung — nie aus dem Kopf.
- Stack-spezifisch — frag bei Unklarheit. Headers, Manifest, CSP unterscheiden sich zwischen Vercel / Cloudflare Pages / Cloudflare Workers / nginx / Apache. Bei Astro & Next standardmäßig Vercel-Deploy annehmen, sonst nachfragen.
- Nur Pflicht-Artefakte. Optionales (Service Worker, View Transitions, Speculation Rules) erst nach Nachfrage.
- **Setup ist Foundation, kein Content.** Erlaubt: scaffold, Pflicht-Files in `public/`, `<head>`-Metas, Manifest, Favicons, minimaler Placeholder-Index mit Brand-Name + Tagline. Verboten: Hero-Sections, Marketing-Copy, konkrete Section-Inhalte, Layouts mit Brand-Farbschema / Fonts, globale Styles über `theme-color` hinaus. Content + Visual-Design → `everlast-web-design`.
- Auf Deutsch antworten, Code/Header/Werte/Tokens auf Englisch.
- Em-dashes in user-facing Copy sparsam.
- Bei BFSG-Relevanz aktiv darauf hinweisen (B2C-Shop / Banking / Buchung).
- Bei DSGVO-Verstößen klar markieren (Google Fonts CDN, hardcoded reCAPTCHA, US-Tools ohne AVV).

## Anti-Patterns

- ❌ Standards aus dem Kopf rezitieren statt AGENTS.md zu lesen.
- ❌ Hero-Sections, Marketing-Copy oder konkrete Section-Inhalte in `src/pages/`, `app/`, `src/routes/` schreiben — gehört zu `everlast-web-design`.
- ❌ Layouts oder globale Styles mit Brand-Farben / Fonts / Komponenten anlegen — `theme-color` im Manifest ist die einzige Brand-Farb-Berührung im Setup.
- ❌ Default-Welcome-Page des Scaffolds "verbessern" statt durch sauberen Placeholder zu ersetzen.
- ❌ Generische `robots.txt` ohne AI-Crawler-Konfiguration.
- ❌ CSP mit `unsafe-inline` ohne dokumentierte Begründung.
- ❌ Google Fonts via `fonts.googleapis.com` einbauen.
- ❌ Favicon nur als `.ico`.
- ❌ `security.txt` ohne `Expires` oder mit `Expires < heute`.
- ❌ `frame-ancestors 'none'` ohne Allowlist-Hinweis — bricht Whitelabel-Previews.
- ❌ Mehrere `<h1>` pro Seite.
- ❌ Bilder ohne `width`/`height`-Attribute.

## Übergabe an nächste Phase

- **`everlast-web-design`** für Brand-DNA, DESIGN.md, Anti-Slop-Setup.
- **`everlast-web-audit`** vor jedem Release (Lighthouse + Mozilla Observatory + PageSpeed Insights).

## Aktualität

Die Standards haben einen Changelog am Ende der AGENTS.md. Wenn die Nutzerin nach einem Punkt fragt, der nach dem letzten Changelog-Eintrag liegen könnte (z.B. neue Web-Platform-Baseline-Features), kurz darauf hinweisen.
