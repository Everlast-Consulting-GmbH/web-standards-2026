---
name: launchgrade-audit
description: Pre-launch and post-launch audit for web projects per Launchgrade Web Standards 2026. Runs Lighthouse, Mozilla Observatory, and PageSpeed Insights, parses JSON output, maps findings to MUSTs/SHOULDs from AGENTS.md, returns a bucket report (Blockers / Recommended / Nice-to-have). Triggers on "audit", "pre-launch", "check", "Lighthouse", "score", "how fast", URL + check verb, "Audit", "prüfen", "wie schnell".
---

# Launchgrade Web Audit Skill

Dritte Phase im Launchgrade-Workflow: **Verifikation**. Führt die drei essentiellen Tools deterministisch aus und mappt die Findings auf die Standards.

## Wann triggern

- Pre-Launch-Audit einer neuen Site
- Post-Launch-Health-Check (nach Deployment, nach größerem Release)
- Migration bestehender Site auf Launchgrade-Standards: Baseline-Snapshot
- URL ist im Prompt + Wort "Audit" / "prüfen" / "wie schnell" / "Score" / "Lighthouse" / "CWV"

Nicht triggern bei: Code-Reviews ohne URL, reinen Setup-Fragen (→ `launchgrade-setup`), Design-/Brand-Fragen (→ `launchgrade-design`).

## Wo die Wahrheit liegt

Standards liegen in `./web-standards/AGENTS.md` und `./web-standards/checklist.md` im Repo-Root. Snapshot der Launchgrade Web Standards 2026, mit jedem Release versioniert.

Relevante Kapitel für Audit:
- §2 Performance (Core Web Vitals)
- §3 Accessibility (WCAG 2.2 AA & BFSG)
- §4 SEO & Discoverability
- §5 Security
- §6 Privacy & DSGVO

Pre-Launch-Liste: `checklist.md` im selben Repo.

**Pflicht-Schritt:** AGENTS.md §2–§6 + `checklist.md` lesen, bevor Findings gemappt werden.

## Drei Tools, deterministisch

### 1. Lighthouse (Performance + SEO + A11y + Best Practices)

```bash
lighthouse <url> \
  --output=json --output-path=/tmp/lh-mobile.json \
  --chrome-flags="--headless" --quiet
lighthouse <url> \
  --preset=desktop --output=json --output-path=/tmp/lh-desktop.json \
  --chrome-flags="--headless" --quiet
```

JSON-Pfade:
- `categories.performance.score` (×100 = Score 0–100)
- `categories.seo.score`
- `categories.accessibility.score`
- `categories.best-practices.score`
- `audits.largest-contentful-paint.numericValue` (ms)
- `audits.cumulative-layout-shift.numericValue`
- `audits.total-blocking-time.numericValue` (ms, Proxy für INP)
- `audits.first-contentful-paint.numericValue` (ms)

**Pass-Schwellen:**
- Performance Mobile ≥ 80, Desktop ≥ 90
- SEO ≥ 95, A11y ≥ 95, Best Practices ≥ 95

Bei Score-Varianz (±5 ist normal): 3 Runs Median empfehlen.

### 2. Mozilla Observatory (Security-Header)

```bash
# Scan triggern
curl -s -X POST "https://observatory-api.mdn.mozilla.net/api/v2/scan?host=<host>"
# Polling bis state=FINISHED:
curl -s "https://observatory-api.mdn.mozilla.net/api/v2/scan?host=<host>"
```

JSON-Pfade:
- `.grade` (A+, A, B, C, D, F)
- `.score` (0–135)
- `.tests_failed[]` für Detail-Findings (CSP, HSTS, X-Frame, X-Content-Type-Options, Referrer-Policy, Cookie-Flags, SRI)

**Pass-Schwelle:** Grade ≥ A. AGENTS.md §5 nennt A+ als Ziel — A als Mindest.

### 3. PageSpeed Insights (CrUX-Felddaten + Lab)

```bash
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=<url>&strategy=mobile&category=performance&category=seo&category=accessibility&category=best-practices"
```

JSON-Pfade (CrUX = echte User-Daten, nur wenn Domain genug Traffic hat):
- `loadingExperience.metrics.LARGEST_CONTENTFUL_PAINT_MS.percentile` (p75 in ms)
- `loadingExperience.metrics.INTERACTION_TO_NEXT_PAINT.percentile` (p75 in ms)
- `loadingExperience.metrics.CUMULATIVE_LAYOUT_SHIFT_SCORE.percentile` (×100)
- `loadingExperience.overall_category` (FAST / AVERAGE / SLOW)

**Pass-Schwellen (CWV 2026, p75 echter User):**
- LCP ≤ 2500 ms
- INP ≤ 200 ms
- CLS ≤ 0.1 (im JSON ×100, also ≤ 10)

Wenn keine CrUX-Daten vorliegen (kleiner Traffic / neue Site): nur Lab-Daten aus Lighthouse gelten als Smoke-Test, das im Report dokumentieren.

## Vorgehen

1. **Kontext klären:**
   - URL (vollständig mit Protokoll)
   - Geltungsbereich: BFSG-relevant (B2C-Shop / Banking / Buchung)?
   - Single-Page-Check oder Multi-Page (mehrere URLs nacheinander)?

2. **AGENTS.md §2–§6 + `checklist.md` lesen.**

3. **Drei Tools nacheinander ausführen, JSON in `/tmp/` speichern.**

4. **JSON parsen** und gegen Pass-Schwellen + AGENTS.md-MUSTs prüfen. Nicht den JSON-Output in die Antwort dumpen — nur die relevanten Werte zitieren.

5. **Report in drei Buckets:**

   - **Blocker** (offene MUSTs, Release-stoppend):
     - Performance < Schwelle (Mobile < 80, Desktop < 90)
     - Observatory Grade < A
     - LH A11y < 95 oder critical/serious violations
     - Fehlende Pflicht-Files (security.txt, robots.txt, sitemap.xml, manifest)
     - DSGVO-Verstöße (Google Fonts CDN, Pre-Consent-Tracking)
     - CrUX (falls vorhanden): CWV-Werte im "schlecht"-Bereich

   - **Empfohlen** (offene SHOULDs):
     - LH-Score knapp unter Ziel (z.B. SEO 92 statt ≥95)
     - JSON-LD Lücken (Organization ohne sameAs, fehlende Article/FAQPage)
     - Fehlendes `llms.txt`
     - hreflang-Schwächen
     - HSTS ohne `preload`
     - LH SEO-Audit-IDs mit `score < 1`

   - **Nice-to-have** (MAYs):
     - PWA-Manifest erweitern
     - View Transitions / Speculation Rules
     - AVIF-Pipeline
     - Service Worker

6. **Konkrete Patches für Blocker:**
   - Bei Code-Zugriff: direkt umsetzbare `Edit`s vorschlagen oder anwenden
   - Sonst: konkrete Konfigurations-Snippets (CSP-Direktive, Cache-Header, JSON-LD)
   - Verweis auf AGENTS.md-Sektion pro Finding

## Verhalten

- Alle drei Tools laufen lassen — auch wenn Lighthouse "alles" zu zeigen scheint. Observatory deckt Security-Header tiefer, PSI liefert echte Felddaten.
- Bei BFSG-Relevanz: Lighthouse-A11y reicht NICHT — zusätzlich `@axe-core/cli` ausführen (`axe <url> --tags wcag22aa --save /tmp/axe.json`) und critical/serious violations als Blocker werten.
- JSON nicht im Output dumpen — nur die relevanten Werte zitieren + Bucket-Mapping.
- Auf Deutsch antworten, Tool-Namen / Metriken / Header / JSON-Pfade auf Englisch.
- CrUX-Daten nie erfinden, wenn das Feld leer ist.
- Bei Lighthouse-Varianz: 3 Runs Median bilden.

## Anti-Patterns

- ❌ Nur Lighthouse laufen lassen — Security & CrUX fehlen.
- ❌ Score zitieren ohne Bucket-Mapping und ohne AGENTS.md-Verweis.
- ❌ Lighthouse-A11y-Score 100 als "BFSG-konform" verkaufen — A11y braucht axe-core + manueller Test.
- ❌ CrUX-Daten erfinden wenn das Feld leer ist.
- ❌ "Pass" sagen wenn Pflicht-Files (security.txt, llms.txt, manifest) fehlen.
- ❌ Reports ohne Verweis auf AGENTS.md-Sektionen oder checklist.md.
- ❌ Findings als JSON-Blob dumpen statt strukturiert auswerten.

## Übergabe

- Wenn Audit grün: Site ist **technisch** ready.
- Design-Qualität bleibt manueller Check via **`launchgrade-design`** (DESIGN.md vs. Output).
- Bei Bestandsmigration: Mid-/Long-Term-Roadmap aus AGENTS.md §11 als Folge-Plan vorschlagen.

## Aktualität

Schwellen (CWV, LH-Scores) sind in der AGENTS.md verankert und werden über deren Changelog versioniert. Wenn Google CWV-Schwellen ändert oder eine neue Metrik einführt (Stand 2026: INP hat FID 2024 abgelöst), AGENTS.md §2 zuerst updaten, nicht hier.
