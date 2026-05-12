# Everlast Web Standards 2026

**Stand:** Mai 2026 · **Version:** 1.5 · **Geltung:** Pflicht-Baseline für jede von Everlast gebaute oder betreute Website.

Dieses Dokument definiert die technischen Mindestanforderungen, die für **jede** öffentliche Website gelten, unabhängig von Stack, CMS oder Framework. Es enthält **keine** Design-Entscheidungen — nur messbare, prüfbare Fakten.

Das Dokument ist gleichzeitig:

- **Briefing** für Entwickler:innen vor Projektstart
- **AGENTS.md** für Coding-Agents (Claude Code, Codex, Cursor, etc.)
- **Audit-Vorlage** für Pre-Launch und für die Migration bestehender Projekte
- **Vertragsanhang** für Kundenangebote ("Konformität mit Everlast Web Standards 2026")

---

## Wie man dieses Dokument liest

Vier Härtegrade nach RFC 2119:

- **MUST** = Launch-Blocker, ohne Diskussion erfüllen.
- **Conditional MUST** = MUST, sobald das Projekt eine bestimmte Funktion oder rechtliche Anwendung hat (z.B. Shop, Login, Buchung, Mehrsprachigkeit, PWA, Ads, B2C-BFSG).
- **SHOULD** = Everlast-Default. Abweichung erlaubt, aber im Projekt-README kurz begründen.
- **MAY** = Optional, ohne Launch-Blocker-Status.

Verbindliche Pre-Launch-Liste: [`checklist.md`](./checklist.md).

---

## 0. Geltungsbereich

Diese Standards gelten für:

- Marketing-Websites, Landing Pages, Corporate Sites
- Online-Shops, Buchungssysteme, B2C-Plattformen
- Blogs, Magazine, Dokumentationen
- SaaS-Marketing-Sites (das öffentliche Frontend, nicht das App-Backend)

Nicht im Geltungsbereich: interne Tools, Admin-Backends, Mitarbeiter-Dashboards (für die gelten separate interne Standards).

---

## 1. HTML & Document Baseline

### 1.1 Doctype, Sprache, Encoding (MUST)

Standard HTML5-Boilerplate mit:

- `<html lang>` gesetzt (z.B. `de`, `de-AT`, `en-US`); bei Mehrsprachigkeit pro Sprachversion korrekt.
- `<meta charset="UTF-8">` als erstes `<head>`-Element.
- `<meta name="viewport" content="width=device-width, initial-scale=1">` — **darf nicht** `user-scalable=no` oder `maximum-scale=1` enthalten (WCAG 1.4.4).

**Prüfung:** W3C HTML Validator, Lighthouse Best Practices.

### 1.2 Title & Description (MUST)

**MUST:** eindeutiger `<title>` und sinnvolle `<meta name="description">` pro indexierbarer Seite. `meta keywords` ist obsolet und darf nicht gesetzt werden.

**SHOULD:** `<title>` ca. 50–60 Zeichen (Faustregel — Pixel-Breite zählt, Google kürzt bei ~580 px). `<meta description>` 120–160 Zeichen — Google kürzt mobil oft schon bei 120 und generiert Snippets dynamisch.

**Prüfung:** Screaming Frog, manueller SERP-Preview.

### 1.3 Semantic HTML Structure (MUST)

Jede Seite MUST folgende Landmarks nutzen:

Standard-Skeleton: Skip-Link → `<header>` → `<nav aria-label="...">` → `<main id="main">` (mit H1) → `<footer>`.

**MUST:**
- `<button>` für Aktionen, `<a href>` für Navigation. **Niemals** `<div onclick>`.
- `<section>` ohne Überschrift oder `aria-labelledby` ist semantisch falsch.
- Skip-Link als erstes fokussierbares Element, sichtbar bei `:focus`.
- Headings bilden eine nachvollziehbare Inhaltsstruktur, nicht rein visuell eingesetzt.

**SHOULD (Everlast-Default):**
- Genau ein sichtbarer `<h1>` pro Seite. Abweichungen nur dokumentiert begründen.
- Keine Heading-Level-Sprünge (h1 → h2 → h3).

**Prüfung:** axe DevTools, WAVE, Screen-Reader-Landmark-Navigation.

### 1.4 Color-Scheme & Theme-Color (MUST)

```html
<meta name="color-scheme" content="light dark">
<meta name="theme-color" media="(prefers-color-scheme: light)" content="#ffffff">
<meta name="theme-color" media="(prefers-color-scheme: dark)" content="#0b0b0b">
```

### 1.5 Favicon-Set 2026 (MUST)

Minimal-Konsens:

```html
<link rel="icon" href="/favicon.ico" sizes="32x32">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
```

**Pflicht (MUST):** `favicon.ico` (multi-size 16/32/48), `favicon.svg`, `apple-touch-icon.png` (180×180). **SHOULD** (für installierbare PWAs MUST): `icon-192.png`, `icon-512.png`, `icon-512-maskable.png`, `site.webmanifest` — siehe 8.1.

---

## 2. Performance (Core Web Vitals)

### 2.1 Core Web Vitals Zielwerte (MUST)

Gemessen am 75. Perzentil über reale Nutzer (CrUX), Mobile **und** Desktop separat:

| Metrik | Good (Pflicht) | Poor (Blocker) |
|---|---|---|
| **LCP** (Largest Contentful Paint) | < 2.5 s | > 4.0 s |
| **INP** (Interaction to Next Paint) | < 200 ms | > 500 ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | > 0.25 |

INP hat am 12. März 2024 FID ersetzt und ist Bestandteil der Core Web Vitals. Google nutzt CWV als "Page Experience"-Signal — Tiebreaker / schwacher Ranking-Faktor, nicht primäres Ranking-Kriterium.

CWV werden aus realen Nutzerdaten (CrUX field data) gemessen — das ist die **verbindliche Wahrheit** nach ausreichend Traffic.

### 2.2 Lighthouse als Pre-Launch-Smoketest (SHOULD)

**Vor Launch** (keine Field-Daten verfügbar): Lighthouse Mobile / WebPageTest als Smoke-Test. **Nach Launch** (ausreichend Traffic): CrUX / RUM ist Abnahme-Kriterium, Lab-Score ist nur noch Diagnostik. Lighthouse-Smoketest-Ziele:

| Score | Mobile | Desktop |
|---|---|---|
| Performance | ≥ 90 | ≥ 95 |
| Accessibility | ≥ 95 | ≥ 95 |
| Best Practices | ≥ 95 | ≥ 95 |
| SEO | ≥ 95 | ≥ 95 |

Sekundärmetriken: TTFB < 600 ms, FCP < 1.8 s, TBT < 200 ms, Speed Index < 3.4 s (Mobile).

Bei Marketing-Sites mit pflicht-3rd-party (Consent-Manager + Analytics + Pixel) kann LH-Performance ≥ 90 nicht garantierbar sein — dann CWV-Field-Daten als Abnahme-Kriterium, nicht Lab-Score.

### 2.3 Transport

**MUST:**
- HTTP/2 minimum, HTTP/3 bei modernen CDNs erwartet.
- TLS 1.3 bevorzugt, TLS 1.2 minimum.
- Brotli für Text-Assets, Gzip nur als Fallback.
- Statische Assets dürfen CWV nicht durch langsame Origin-Auslieferung gefährden.

**Conditional MUST** (internationale Zielgruppe, hoher Traffic, CWV-Risiko durch Latenz): CDN mit relevanten PoPs.
**SHOULD** (Default für Marketing-Sites): CDN- oder Edge-Hosting (Vercel / Cloudflare / Netlify / Bunny).

### 2.4 Resource Hints

**MUST:**
- Scripts: `defer` als Default, `async` nur für unabhängige Analytics.
- Inline-Scripts > 1 KB vermeiden (außer kritisches Init / CSP-Nonce-Init).

**SHOULD:**
- `preconnect` für 3rd-Party-Origins mit LCP-Relevanz, max. ~4 (sonst Connection-Contention).
- `preload` für LCP-Image, kritische Fonts (woff2), kritisches CSS — **niemals** für JS-Module.
- `modulepreload` für früh ausgeführte ES-Module.

### 2.5 Images

**MUST (für inhaltliche Bilder):**
- `width` und `height` Attribute auf jedem `<img>` (CLS-Prevention).
- Responsive: `srcset` mit min. 3 Breiten, `sizes` Attribut bei Content-/Hero-Bildern.
- `loading="lazy"` Default below-the-fold; LCP-Image `loading="eager"` + `fetchpriority="high"`.
- Alt-Text: leer (`alt=""`) für dekorativ, beschreibend für inhaltlich.

**SHOULD:** AVIF primary, WebP fallback via `<picture>`. JPEG/PNG nur als Legacy-Fallback. Bei dynamischen CMS-Uploads, alten Bildbibliotheken oder Stacks ohne stabile AVIF-Pipeline ist WebP allein akzeptabel.

### 2.6 Fonts (MUST)

**MUST:**
- Ausschließlich `woff2`.
- `font-display: swap` als Default.
- Self-Hosted (DSGVO + Performance), keine Google-Fonts-CDN.
- Max. 2 Fonts `preload`en.
- System-Font-Fallback-Stack: `font-family: 'Brand', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;`

**SHOULD** (bei messbarem CLS > 0.05 durch Font-Swap):
- Metric-Overrides (`size-adjust`, `ascent-override`, `descent-override`) auf den Fallback-Font kalibrieren — Werte via Malte Ubl's Font-Style-Matcher generieren.
- `unicode-range` bei mehrsprachigen Sites (Latin + Cyrillic etc.) zur Subset-Auslieferung.

### 2.7 JavaScript Budgets (SHOULD, hart bei Marketing-Sites)

- Initial JS Mobile: **< 170 KB compressed** (~ 350 KB uncompressed).
- Total JS pro Page: **< 350 KB compressed** Mobile.
- Max. 4 Third-Party-Scripts, gemessener TBT-Impact < 50 ms.
- Keine Long Tasks > 50 ms während Page Load. Pattern: `requestIdleCallback`, `scheduler.yield()`, Web Workers.

### 2.8 Caching (MUST)

```
# Hashed static assets
Cache-Control: public, max-age=31536000, immutable

# HTML
Cache-Control: no-cache
# oder
Cache-Control: max-age=300, stale-while-revalidate=86400
```

ETag oder Last-Modified für nicht-immutable Ressourcen.

### 2.9 Speculation Rules (MAY)

Projektabhängig, kein Baseline-Standard. **Speculation Rules** (`<script type="speculationrules">`) können auf Multi-Page-Sites Folgenavigationen prerendern (200–800 ms LCP-Gewinn). Achtung: Prerender feuert Analytics-Events — `document.prerendering` checken oder Consent/Tracking gegen Prerender absichern. View Transitions: siehe **§9.7**.

**Prüfung Gesamtblock 2:** PageSpeed Insights (CrUX field data), WebPageTest, Lighthouse, Chrome DevTools Performance.

---

## 3. Accessibility — WCAG 2.2 AA & BFSG

### 3.1 Rechtsrahmen 2026 (MUST verstehen)

- **Everlast-technische Baseline: WCAG 2.2 AA** (W3C Recommendation seit Okt 2023). Rechtliche Zielnormen können je nach Projekt EN 301 549, BFSG, BITV oder vertragliche Anforderungen sein — EN 301 549 v3.2.1 referenziert aktuell noch WCAG 2.1 AA, das Update auf 2.2 folgt im EU-Amtsblatt.
- **European Accessibility Act (EAA)** ist seit **28. Juni 2025** verpflichtend für B2C: E-Commerce, Banking, Personenverkehr, E-Books, Telekommunikation, Streaming.
- **BFSG (DE)** setzt EAA um, in Kraft seit 28. Juni 2025 — Pflicht für jeden B2C-Online-Shop / Banking / Buchung / E-Book / Streaming / Telekommunikation. Bußgelder gestaffelt nach § 37 BFSG: bis **10.000 €** für die meisten OWi-Tatbestände, bis **100.000 €** für schwere Verstöße (z.B. Inverkehrbringen trotz Untersagung).
- **Kleinstunternehmer-Ausnahme** (§ 3 Abs. 3 BFSG): Unternehmen mit **< 10 Mitarbeitenden UND < 2 Mio. € Jahresumsatz / Bilanzsumme** sind bei Dienstleistungen ausgenommen (für Produkte gilt die Ausnahme nicht). Bei Kundenprojekten zu Beginn prüfen.
- Public-Sector-Sites: **BITV 2.0** (referenziert EN 301 549 ≈ WCAG 2.1 AA, Update auf 2.2 in Vorbereitung).

### 3.2 BFSG-Konformitätserklärung (MUST bei B2C im Geltungsbereich)

Pflicht-Komponenten auf der Website:

- **Konformitätserklärung** als eigene Unterseite, im Footer verlinkt. Pflicht-Inhalte (gem. Anlage 3 BFSG):
  1. Angewandte technische Spezifikation (EN 301 549, referenziert WCAG 2.1 AA — bis Update auf 2.2)
  2. Bewertungsmethode (z.B. Selbst-Audit gegen WCAG, externer BITV-Test)
  3. Datum der Erstellung / letzten Aktualisierung
  4. Beschreibung bekannter Barrieren mit Begründung (falls vorhanden)
  5. Alternative Zugänge zu nicht-barrierefreien Inhalten
- **Feedback-Mechanismus**: E-Mail-Kontakt (oder Formular) für Barrieren-Meldungen, Antwort-Frist intern festlegen (Empfehlung: ≤ 14 Tage).
- **Marktüberwachung**: Zuständig sind die Länder; sie haben die **MLBF AöR** (Marktüberwachungsstelle der Länder für Barrierefreiheit, Sitz Magdeburg, aktiv seit 26.09.2025) als gemeinsame Stelle eingerichtet. Bei BFSG-Anfragen und Beschwerden auf MLBF verweisen und kooperieren.

### 3.3 Neue Success Criteria in WCAG 2.2 (MUST)

WCAG 2.2 enthält **9 neue Success Criteria** und entfernt SC **4.1.1 Parsing** (durch moderne HTML-Parser obsolet — Validator-Findings dieser Kategorie sind kein WCAG-Verstoß mehr).

| SC | Titel | Level | Anforderung |
|---|---|---|---|
| 2.4.11 | Focus Not Obscured (Minimum) | **AA** | Fokussiertes Element darf nicht vollständig durch Sticky-Header, Cookie-Banner etc. verdeckt werden |
| 2.4.12 | Focus Not Obscured (Enhanced) | AAA | Gar keine Verdeckung |
| 2.4.13 | Focus Appearance | AAA | Focus-Indikator min. 2 CSS-Pixel dick, Kontrast 3:1 |
| 2.5.7 | Dragging Movements | **AA** | Drag muss alternative Single-Click-Bedienung haben |
| 2.5.8 | Target Size (Minimum) | **AA** | Klickflächen min. 24×24 CSS-Pixel (Ausnahme: inline Text-Links) |
| 3.2.6 | Consistent Help | **A** | Hilfe-Mechanismen in gleicher Reihenfolge auf allen Seiten |
| 3.3.7 | Redundant Entry | **A** | Bereits eingegebene Daten nicht erneut abfragen |
| 3.3.8 | Accessible Authentication (Minimum) | **AA** | Keine kognitiven Tests (Captcha-Puzzle, Passwort merken) als einzige Auth-Option |
| 3.3.9 | Accessible Authentication (Enhanced) | AAA | Auch keine Objekterkennung |

Für die Everlast-Baseline (AA) sind alle SCs mit Level A und AA Pflicht: 2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8.

### 3.4 Color Contrast (MUST)

| Element | Mindest-Kontrast |
|---|---|
| Body-Text (< 18.66 px regular / < 24 px bold) | **4.5:1** |
| Large Text (≥ 18.66 px regular / ≥ 24 px bold) | **3:1** |
| UI-Komponenten + grafische Objekte | **3:1** |
| Focus-Indikator | **3:1** gegen Hintergrund |

APCA (WCAG 3.0 Kandidat) MAY als Sekundär-Check eingesetzt werden, ersetzt aber nicht WCAG-2.2-Kontrast.

### 3.5 Keyboard & Focus (MUST)

- Alle interaktiven Elemente per Tab erreichbar, per Enter/Space bedienbar.
- Tab-Order = visuelle Reihenfolge (keine `tabindex` > 0).
- Sichtbarer `:focus-visible`-State Pflicht (min. 2 CSS-Pixel, 3:1 Kontrast). **Niemals** `outline: none` ohne sichtbaren Ersatz.
- Keine Keyboard-Traps außer in Modals mit ESC-Exit.

### 3.6 ARIA (No-ARIA-First Rule, MUST)

Native HTML schlägt ARIA immer. ARIA nur dort, wo Native nicht reicht:

| Zweck | Pattern |
|---|---|
| Label ohne sichtbaren Text | `aria-label="..."` |
| Label durch sichtbares Element | `aria-labelledby="..."` |
| Aktive Nav | `<a aria-current="page">` |
| Toggle/Accordion | `aria-expanded`, `aria-controls` |
| Live-Updates | `aria-live="polite"` (oder `assertive` für kritisch) |
| Modal | `role="dialog" aria-modal="true" aria-labelledby` + Focus-Trap |

### 3.7 Forms (MUST)

- `<label for>` oder umschließend; **kein Placeholder als Label-Ersatz** (WCAG 1.3.1, 3.3.2).
- `autocomplete`-Attribute für persönliche Daten Pflicht (name, email, tel, street-address …) — WCAG 1.3.5.
- Required visuell + programmatisch (`required`, ggf. `aria-required`).
- Fehler textuell + per `aria-describedby` + Fokus auf erstes Fehlerfeld; bei kritischen Fehlern `role="alert"`.

### 3.8 Media (MUST)

- Video: Captions (WCAG 1.2.2), Transcript empfohlen, Audio-Description bei reinen Visual-Inhalten.
- Autoplay nur stumm und < 5 s, sonst Pause-Control.
- Motion-Pflichten (`prefers-reduced-motion`, WCAG 2.2.2, 2.3.3): siehe **§9 Motion & Animation**.

### 3.9 Language Markup (MUST)

- `<html lang="de">` auf jeder Seite, lokalisiert bei Mehrsprachigkeit.
- Fremdsprachige Passagen markieren: `<span lang="en">user experience</span>`.

**Prüfung Gesamtblock 3:** axe DevTools, WAVE, Lighthouse Accessibility, BIK BITV-Test, manueller Screen-Reader-Test (NVDA + VoiceOver), Keyboard-Only-Walkthrough.

---

## 4. SEO & Discoverability (klassisch + AI)

### 4.1 Meta-Baseline (MUST)

Siehe 1.1 und 1.2. Zusätzlich:

```html
<link rel="canonical" href="https://example.com/page/">
```

- Selbst-referenzierender Canonical auf jeder indexierbaren Seite, absolute URL, finaler HTTPS-Status 200.

### 4.2 Open Graph + X Cards (MUST)

X (vormals Twitter) liest weiterhin die `twitter:*` Meta-Tags — die Spec wurde nicht umbenannt. Wir setzen sie als zweites Set zusätzlich zu Open Graph.

```html
<meta property="og:title" content="...">
<meta property="og:description" content="...">
<meta property="og:url" content="https://example.com/page/">
<meta property="og:type" content="website"><!-- oder "article" -->
<meta property="og:locale" content="de_DE">
<meta property="og:image" content="https://example.com/og.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="...">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="...">
<meta name="twitter:description" content="...">
<meta name="twitter:image" content="https://example.com/og.png">
```

- `og:image` 1200×630 (1.91:1), < 8 MB. Kritischer Inhalt in mittlerem 1080×565-Bereich (Safe-Zone).

### 4.3 Internationalisierung (MUST bei > 1 Sprache)

```html
<link rel="alternate" hreflang="de-DE" href="https://example.com/de/">
<link rel="alternate" hreflang="en-US" href="https://example.com/en/">
<link rel="alternate" hreflang="x-default" href="https://example.com/">
```

- Symmetrisch (jede Sprache verlinkt jede andere), inkl. selbst-referenzierend.
- `x-default` Pflicht bei > 1 Sprache.
- Valide ISO-Codes.
- `Content-Language` HTTP-Header zusätzlich nice-to-have.

### 4.4 Structured Data — JSON-LD (MUST)

Everlast-Default: JSON-LD. Google empfiehlt JSON-LD, akzeptiert aber weiterhin Microdata/RDFa. Bei neuen Projekten kein Microdata/RDFa neu einführen, außer Legacy-CMS-Gründe sprechen explizit dafür.

**Pflicht-Schemas pro Seite:**

| Schema | Wo | Status |
|---|---|---|
| `Organization` | Homepage (und idealerweise via Footer-Layout auf allen Seiten) | MUST |
| `WebSite` | Homepage | MUST |
| `WebSite.potentialAction` (SearchAction) | Homepage, **nur wenn echte Site-Suche existiert** (Google hat das Sitelinks-Searchbox-Feature im Nov 2024 abgekündigt — kein SERP-Hebel mehr) | SHOULD |
| `BreadcrumbList` | Alle Seiten mit Pfad-Tiefe ≥ 2 | MUST |
| `Article` / `BlogPosting` | Blog/Magazin |
| `Product` + `Offer` | Shop |
| `Service` / `LocalBusiness` | Agentur, Dienstleister |
| `FAQPage` | FAQ-Sektionen |

Pflicht-Snippet auf jeder Site (Homepage):

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#org",
      "name": "Brand",
      "alternateName": "Brand GmbH",
      "url": "https://example.com/",
      "logo": {
        "@type": "ImageObject",
        "url": "https://example.com/logo.png",
        "width": 512,
        "height": 512
      },
      "description": "Kurzer Pitch in 1-2 Sätzen.",
      "foundingDate": "2018",
      "vatID": "DE123456789",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "Musterstraße 1",
        "postalCode": "10115",
        "addressLocality": "Berlin",
        "addressCountry": "DE"
      },
      "contactPoint": [{
        "@type": "ContactPoint",
        "contactType": "customer service",
        "telephone": "+49-30-123456",
        "email": "hello@example.com",
        "areaServed": "DE",
        "availableLanguage": ["de", "en"]
      }],
      "sameAs": [
        "https://linkedin.com/company/brand",
        "https://www.wikidata.org/wiki/Q000000"
      ]
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com/",
      "name": "Brand",
      "description": "Kurzer Pitch in 1-2 Sätzen.",
      "inLanguage": "de-DE",
      "publisher": { "@id": "https://example.com/#org" },
      "potentialAction": {
        "@type": "SearchAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": "https://example.com/suche?q={search_term_string}"
        },
        "query-input": "required name=search_term_string"
      }
    }
  ]
}
</script>
```

**Hilfreich für Knowledge-Panel und AI-Discovery**: `contactPoint`, `address`, `vatID`, `inLanguage` und — bei entity-würdigen Marken — ein Wikidata-Eintrag in `sameAs`. Strukturierte Daten und klare Entitäten helfen Maschinen, die Seite zu verstehen; ein garantierter Citation-Boost ist daraus nicht ableitbar.

### 4.5 Robots & Sitemaps (MUST)

`/robots.txt`:

```
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://example.com/sitemap.xml
```

`/sitemap.xml`:

- Nur indexierbare 200-URLs.
- Korrekte `<lastmod>` (echtes Content-Update, nicht jedes Deploy).
- `<priority>` und `<changefreq>` weglassen (Google ignoriert sie).
- Sitemap-Index bei > 50.000 URLs oder > 50 MB unkomprimiert.
- Image-Sitemap-Erweiterung bei bildlastigen Sites.

### 4.6 AI-Crawler-Defaults 2026 (MUST entscheiden, SHOULD allow)

Default-Empfehlung für Marketing-Sites: **AI-Search-Bots erlauben** (Voraussetzung für Citations in ChatGPT, Claude, Perplexity, Google AI Overviews). Trainings-Bots optional blocken.

**Kern-Bots (für Marketing-Sites relevant):**

| User-Agent | Owner | Funktion | Default |
|---|---|---|---|
| `Googlebot` | Google | Search-Indexierung inkl. AI Overviews (Snippet via `nosnippet` / `max-snippet` steuern) | **Allow** |
| `Google-Extended` | Google | Gemini-Training + Grounding **außerhalb** Search | Allow |
| `OAI-SearchBot` / `ChatGPT-User` | OpenAI | ChatGPT Live-Search + on-demand Fetch | **Allow** |
| `GPTBot` | OpenAI | Training | Allow |
| `Claude-SearchBot` / `Claude-User` | Anthropic | Claude Live-Search + on-demand | **Allow** |
| `ClaudeBot` | Anthropic | Training | Allow |
| `PerplexityBot` / `Perplexity-User` | Perplexity | Search + on-demand | **Allow** |
| `Applebot-Extended` | Apple | Apple Intelligence | Allow |

Weitere Bots (`Bytespider`, `Amazonbot`, `DuckAssistBot`, `Cohere-AI`, `Mistral-AI-User`, `YouBot`, `Diffbot`, `CCBot`, `Meta-ExternalAgent`) bei Bedarf via [darkvisitors.com](https://darkvisitors.com) nachschlagen.

Editorial / Paid Content: restriktivere Policy bewusst entscheiden und dokumentieren. Trainings-Bots zu blocken schützt nicht vor bereits trainierten Modellen. User-Agent-Strings sind fälschbar — bei echtem Schutzbedarf zusätzlich per IP-Range / reverse-DNS filtern.

### 4.7 Cloudflare Content Signals & llms.txt (MAY)

Zwei optionale 2026-Mechaniken für AI-Discovery, beide ohne Enforcement und ohne messbaren Effekt auf eine Standard-Marketing-Site:

- **Cloudflare Content Signals** — `robots.txt`-Erweiterung mit drei Token (`search`, `ai-input`, `ai-train`). Trust-based. Beispiel: `Content-Signal: search=yes, ai-input=yes, ai-train=yes`. Bei Paid/Editorial restriktiver setzen.
- **`llms.txt`** (llmstxt.org) — Markdown-Liste der wichtigsten Seiten im Root. Adoption < 10% Mai 2026, kein nachgewiesener Citation-Boost.

### 4.8 AI-Citation-Optimization (SHOULD)

Technische Hebel (keine Content-Vorschriften):

- Echte semantische HTML5-Tags (siehe 1.3).
- Answer-first-Absätze 40–75 Wörter direkt unter H2.
- Tabellen für Vergleiche.
- `FAQPage` Schema bei Q/A-Blöcken.
- Klare URL-Struktur, sprechende Slugs.

### 4.9 URL-Struktur (MUST)

- HTTPS-only, HTTP → 301 → HTTPS.
- Konsistente Trailing-Slash-Politik. **Empfehlung Everlast-Default**: Trailing-Slash für Directory-Routes (`/leistungen/`), kein Trailing-Slash für File-Routes (`/sitemap.xml`). Konsistent mit Vercel / Next / Astro / WordPress-Default. Die andere Variante 301-redirected.
- Lowercase, Bindestriche statt Underscores, keine Query-Strings in Canonicals.
- 404 → echter 404-Status, kein Soft-404.

### 4.10 Indexing Control (MUST)

- `noindex` per Meta oder `X-Robots-Tag` Header für Filter, interne Suche, Login, Thank-you-Pages.
- Nicht-indexierbare Seiten **nicht** in Sitemap aufnehmen.

**Prüfung Gesamtblock 4:** Google Search Console (Coverage, International Targeting), Rich Results Test, Schema Markup Validator, Screaming Frog, Ahrefs Site Audit, opengraph.xyz, [cards-dev.twitter.com/validator](https://cards-dev.twitter.com/validator) (X Card Validator).

---

## 5. Security

### 5.1 HTTPS & HSTS (MUST)

- TLS 1.3 bevorzugt, TLS 1.2 minimum, Mozilla SSL Config "intermediate".
- HTTP/2 minimum, HTTP/3 bevorzugt.
- HTTP → 301 → HTTPS.

```
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

Rollout-Hinweis: Erst `max-age=2592000` (1 Monat), nach Stabilisierung 2 Jahre, dann auf `hstspreload.org` eintragen.

### 5.2 Content Security Policy

**Marketing-Baseline (MUST):**

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self';
  script-src-attr 'none';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self';
  connect-src 'self';
  object-src 'none';
  base-uri 'none';
  frame-ancestors 'none';  /* Default. Bei legitimen Embeds (Whitelabel-Preview, Kunden-Portal, CMS-Preview): explizite Allowlist, niemals Wildcard. */
  form-action 'self';
  upgrade-insecure-requests;
  report-to csp-endpoint
```

`'unsafe-inline'` für Styles ist branchenüblich, weil Astro, Next, SvelteKit, Tailwind JIT laufend Inline-Styles injizieren. Für Scripts ist `'unsafe-inline'` weiterhin verboten — `script-src-attr 'none'` verhindert Inline-Event-Handler.

**Strict CSP mit Nonce + `strict-dynamic` (MUST bei Login, Shop, Buchung, Payment, sensiblen Formularen):**

```
script-src 'nonce-{RANDOM}' 'strict-dynamic';
script-src-elem 'nonce-{RANDOM}' 'strict-dynamic';
```

Nonce pro Response neu, kryptographisch zufällig (≥ 128 Bit). Setzt Edge/SSR voraus (Vercel, Cloudflare Workers, Next, Astro). Bei rein statischem Hosting: Hash-basierte Variante (`'sha256-...'`) — wartungsaufwändig.

**Rollout:** erst `Content-Security-Policy-Report-Only` für ≥ 2 Wochen, Reports monitoren, dann enforcen.

### 5.3 Security-Header-Baseline (MUST)

**MUST:**

```
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=(), usb=(), bluetooth=(), magnetometer=(), gyroscope=(), accelerometer=(), browsing-topics=()
Cross-Origin-Opener-Policy: same-origin
```

`interest-cohort=()` **nicht mehr setzen** (FLoC obsolet seit 2022, Chrome wirft Warnings). Weitere Privacy-Sandbox-Tokens (`shared-storage`, `attribution-reporting`, FLEDGE etc.) nur projektabhängig setzen, wenn Ads/Tracking aktiv reguliert werden müssen. `X-Frame-Options` ist durch CSP `frame-ancestors 'none'` ersetzt.

**SHOULD:**

- `Cross-Origin-Resource-Policy: same-origin` — bei CDN-Subdomain-Auslieferung auf `cross-origin` setzen, sonst bricht Image-Loading.

**MAY (nur bei Cross-Origin-Isolation-Bedarf — SharedArrayBuffer, High-Res-Timer, WASM-Threads):**

- `Cross-Origin-Embedder-Policy: require-corp` — bricht jeden Cross-Origin-Embed (YouTube, Stripe, Maps, Analytics) ohne eigenen `Cross-Origin-Resource-Policy` Header. Für normale Marketing-Sites destruktiv. Aktivierung via `self.crossOriginIsolated === true` verifizieren.

### 5.4 Cookies (MUST)

```
Set-Cookie: __Host-session=...; Path=/; Secure; HttpOnly; SameSite=Lax
```

- `Secure` Pflicht bei HTTPS (= immer).
- `HttpOnly` für Session/Auth-Cookies.
- `SameSite=Lax` als Default, `Strict` für reine Auth.
- `SameSite=None` nur in Kombination mit `Secure` und wenn cross-site zwingend nötig.
- `__Host-` Prefix für Auth-Cookies (erzwingt `Secure`, `Path=/`, kein `Domain`).

### 5.5 Subresource Integrity (SHOULD bei CDN-Skripten)

```html
<script src="https://cdn.example.com/lib.js"
        integrity="sha384-BASE64HASH"
        crossorigin="anonymous"></script>
```

Bevorzugt: externe Libraries selbst hosten und in den Build pinnen — dann ist SRI unnötig.

### 5.6 Mixed Content (MUST)

- Null HTTP-Subressourcen auf HTTPS-Seiten.
- CSP enforced: `upgrade-insecure-requests`, bei Bedarf zusätzlich `block-all-mixed-content`.

### 5.7 Form-Schutz (MUST)

- CSRF-Token bei jedem state-changing Request.
- Server-Rate-Limit (z.B. 5 Submissions / IP / Minute).
- Honeypot-Feld + DSGVO-konformer Captcha-Service (Cloudflare Turnstile, Friendly Captcha) — **kein reCAPTCHA ohne Consent**.
- Server-seitige Validierung mit Zod / TypeBox / Valibot.

### 5.8 Dependency-Hygiene & Application Security Level

**MUST:**
- Dependabot oder Renovate aktiv in jedem Repo.
- Auto-Merge für Patch-Updates auf grüner CI, manuelle Review für Major.
- CI-Step: `npm audit --audit-level=critical` fail-on-critical.

**SHOULD:**
- SBOM (CycloneDX oder SPDX) bei Kundenprojekten mit Compliance-Anforderung.
- **npm provenance** (Sigstore) für selbst publizierte Pakete.

**OWASP-Skalierung pro Site-Typ:**

| Site-Typ | Sicherheits-Ziel |
|---|---|
| Marketing / Corporate / Landing (kein Login) | OWASP Top 10 abdecken + Header-Baseline + Form-Schutz |
| Site mit Login, Buchung, sensiblen Formularen | OWASP ASVS L1 als Referenz |
| Shop / Payment / Accounts / SaaS / API | OWASP ASVS L2 als Referenz |
| Banking / Health / kritische Infrastruktur | OWASP ASVS L3 (High Assurance) |

### 5.9 DNS-Security (SHOULD)

- **CAA-Record** (RFC 8659): in DNS hinterlegen, welche CA Zertifikate für die Domain ausstellen darf.
  ```
  example.com.  IN  CAA  0 issue "letsencrypt.org"
  ```
- **DNSSEC** aktivieren wenn der Registrar es unterstützt (Cloudflare, Route 53, deSEC).
- **MTA-STS** + **TLS-RPT** nur bei eigenem Mailbetrieb auf der Domain.

### 5.10 Authentifizierung (SHOULD bei Login-Sites)

Wenn die Site einen User-Login bietet (Shop, Buchung, Member-Bereich):

- **Passkeys / WebAuthn** als primäre Auth-Methode anbieten. Passwörter als Fallback. Passwort-Login MUST nicht von kognitiven Tests abhängen (WCAG 3.3.8).
- **Passwort-Anforderungen**: NIST 800-63B aktuelle Guidance — min. 8 Zeichen, keine erzwungene Komplexität, gegen bekannte Breach-Lists prüfen (haveibeenpwned k-Anonymity API), keine erzwungenen Rotationen außer bei Verdacht.
- **MFA** anbieten (TOTP, WebAuthn-Second-Factor). SMS-OTP als Fallback, nicht als Default.
- **Session-Cookies**: siehe 5.4. Idle-Timeout + absolute Lebensdauer setzen.
- **`/.well-known/change-password`** (WHATWG): redirected auf die Passwort-Ändern-Seite — Browser-Password-Manager nutzen den Pfad.
- **Rate-Limiting** auf Login-Endpoint (z.B. 5 Versuche pro IP / Account / 15 min), Account-Lockout mit Captcha-Eskalation, nicht Permanent-Lockout.

### 5.11 `.well-known/security.txt` (MUST)

`/.well-known/security.txt` (RFC 9116):

```
Contact: mailto:security@example.com
Expires: 2027-05-11T00:00:00Z
Preferred-Languages: de, en
Canonical: https://example.com/.well-known/security.txt
```

`Expires` MUST RFC 3339, max. 1 Jahr in der Zukunft.

**Prüfung Gesamtblock 5:** SSL Labs (Ziel A+), securityheaders.com (Ziel A+), Mozilla Observatory (Ziel A+), CSP Evaluator, Lighthouse Best Practices.

---

## 6. Privacy & DSGVO (DE/EU)

### 6.1 Consent Management (MUST)

- § 25 TDDDG: aktive Einwilligung (Opt-in) vor jeder Speicherung/Auslesung auf dem Endgerät, die nicht technisch zwingend nötig ist.
- "Alles ablehnen" gleichrangig auf erster Ebene, keine Pre-Checked Boxes.
- Granular pro Zweck (Marketing / Analyse / Funktional).
- Widerruf jederzeit möglich (z.B. permanenter Button im Footer).
- Consent-Logging (Datum, IP-Hash, Version des Banners, Auswahl).
- **MUST**: Keine nicht-notwendige Speicherung/Auslesung und keine personenbezogene Tracking-Verarbeitung vor Consent.
- **SHOULD**: Tags erst nach Consent laden. Bei Einsatz von **Google Consent Mode Advanced** laden Google-Tags technisch mit `denied`-Default — die Implementierung muss rechtlich geprüft und im Projekt-README dokumentiert sein.
- **Conditional MUST bei Google Ads / GA4 / Floodlight**: Google Consent Mode v2 mit den vier Signalen (`ad_storage`, `ad_user_data`, `ad_personalization`, `analytics_storage`). Seit März 2024 Voraussetzung für Conversion-/Personalisierungs-Messung in EU/EWR.
- **EinwV / § 26 TDDDG** (seit 01.04.2025 in Kraft): regelt anerkannte Einwilligungsverwaltungsdienste (PIMS). Praktische Pflicht für Standard-Sites entsteht erst, wenn ein anerkannter PIMS-Dienst technisch einzubinden ist — bis dahin reicht DSGVO/TDDDG-konformer Consent. Status beobachten.
- **TCF v2.2/v2.3** (IAB Europe): nur relevant bei Programmatic Ads / AdSense / Ad Manager / AdMob. Für reine Site-Analytics + Google Ads ohne Programmatic-Vendoren nicht erforderlich. Bei Google-Publisher-Produkten ist TCF v2.3 die aktuell geforderte Version.

### 6.2 Privacy by Design (MUST)

- Google Fonts ausschließlich lokal hosten (LG München 3 O 17493/20).
- reCAPTCHA nur mit Consent oder durch DSGVO-freundliche Alternative ersetzen.
- Embeds (YouTube, Vimeo, Maps, X) erst nach Klick-Consent laden (Two-Click-Lösung) oder Privacy-Mode (`youtube-nocookie.com`) + Consent.
- Analytics bevorzugt cookieless / first-party (Plausible self-hosted, Matomo, Pirsch).

### 6.3 Datenschutzerklärung (MUST)

Pflicht-Inhalte:

- Verantwortlicher, Datenschutzbeauftragter (falls Pflicht).
- Pro Tool: Zweck, Rechtsgrundlage, Speicherdauer, Empfänger, Drittlandtransfer.
- AVV bei Auftragsverarbeitern (US-Tools: DPF-Status prüfen).
- Betroffenenrechte, Widerspruchsrecht, Beschwerderecht bei Aufsichtsbehörde.

### 6.4 Impressum (MUST in DE)

Rechtsgrundlage: § 5 Digitale-Dienste-Gesetz (DDG, in Kraft seit 14.05.2024, hat § 5 TMG abgelöst — inhaltlich deckungsgleich). Norm muss nicht im Impressum zitiert werden. Anforderungen: leicht erkennbar, unmittelbar erreichbar (max. 2 Klicks von jeder Seite), ständig verfügbar.

Pflicht-Inhalte:

- **Voller Name** (juristische Personen + Vertretungsberechtigte).
- **Ladungsfähige Postadresse** (kein Postfach, c/o-Adressen nur sehr restriktiv).
- **E-Mail-Adresse** (Pflicht).
- **Telefonnummer** oder gleichwertig schneller zweiter Kommunikationsweg (z.B. Web-Formular mit garantierter 60-Min-Antwort). Nach EuGH C-298/07 + BGH I ZR 228/03: die "elektronische Kontaktaufnahme" allein reicht nicht — der zweite Kanal muss schnelle direkte Kommunikation ermöglichen.
- **Handels-/Vereinsregister** + Nummer + Registergericht.
- **USt-IdNr.** falls vorhanden (§ 27a UStG).
- **Wirtschafts-Identifikationsnummer** falls vergeben (§ 139c AO).
- Bei **reglementierten Berufen**: zuständige Kammer + gesetzliche Berufsbezeichnung + Verleihungsstaat + berufsrechtliche Regelungen mit Fundstelle.
- Bei journalistisch-redaktionellen Inhalten: **Verantwortlicher i.S.d. § 18 Abs. 2 MStV** mit Name + Anschrift.

Bußgelder bis 50 000 € möglich gem. § 5 Abs. 4 DDG.

### 6.5 Data Minimization (MUST)

- Keine PII in URLs (kein `?email=...`).
- Keine PII in Server-Logs ungeschützt (Maskierung von E-Mail, IP, Tokens).
- Keine vollständigen Bodies in Sentry.
- IP-Anonymisierung in Analytics.
- Log-Retention max. 30–90 Tage rolling.

**Prüfung Gesamtblock 6:** Netzwerk-Tab im Inkognito-Modus vor Consent (keine Third-Party-Hosts erlaubt), Cookiebot/Klaro-Scan, juristische Review von Impressum + Datenschutzerklärung.

---

## 7. Browser-Support, Responsive & i18n

### 7.1 Browser-Support-Baseline (MUST)

- **Web Platform Baseline "Widely available"** (web.dev/baseline) ist die technische Grenze.
- Browserslist-Default: `> 0.5%, last 2 versions, Firefox ESR, not dead`.
- Sicher nutzbar (Widely 2026): CSS Grid, Flexbox, Custom Properties, `:has()`, `:is()`, `:where()`, Container Queries, `aspect-ratio`, logical properties, `gap`, `clamp()`, `min/max()`, `svh/lvh/dvh`, `color-mix()`, `oklch()`, Subgrid.
- Newly available (Fallback empfohlen): `light-dark()` (full coverage 11/2026), View Transitions API (cross-document), Anchor Positioning, `@scope`, `field-sizing`.

### 7.2 Responsive (MUST)

- Mobile-first.
- **Container Queries als Default für komponenten-lokale Layouts**, Media Queries nur für viewport-globale Layout-Entscheidungen (komponenten-basiertes Denken vor Viewport-Denken).
- `<picture>` für Art Direction, `srcset`/`sizes` für Density.
- User-Preferences respektieren: `prefers-reduced-motion`, `prefers-color-scheme`, `prefers-contrast`, `prefers-reduced-transparency`, `prefers-reduced-data`.

### 7.3 Modern JS Baseline (MUST)

- ES Modules (`<script type="module">`).
- ES2022+: Top-Level Await, Optional Chaining, Nullish Coalescing, `structuredClone()`, `Array.prototype.at()`, `Object.hasOwn()`, `Error.cause`.
- `AbortController` für fetch-Cancellation.
- `Intl.*` für Datums-/Zahlen-/Währungs-Formatierung — **niemals** String-Concatenation.

### 7.4 Print Styles (MAY)

Nur relevant bei Sites, die tatsächlich gedruckt werden (Rechnungen, Tickets, Editorial). Minimum:

```css
@media print {
  nav, aside, footer, .no-print { display: none; }
  a[href]::after { content: " (" attr(href) ")"; }
  @page { margin: 2cm; }
}
```

---

## 8. PWA & Manifest

### 8.1 Web App Manifest (SHOULD)

MUST nur bei Sites, die installierbar sein sollen oder PWA-Features bieten. Für klassische Corporate-/Marketing-Sites SHOULD — schadet nicht und liefert Browser-UI-Hinweise (Splash-Color, App-Name beim Tab-Pinning), ist aber kein Launch-Blocker.

`/site.webmanifest`:

```json
{
  "name": "Brand",
  "short_name": "Brand",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0b0b0b",
  "lang": "de",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/icon-512-maskable.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ]
}
```

### 8.2 Service Worker (SHOULD)

Service Worker MAY genutzt werden für Offline-Fallback und Asset-Caching. Wenn eingesetzt:

- Workbox-basiert.
- `NetworkFirst` für HTML, `CacheFirst` für hashed Assets, `StaleWhileRevalidate` für API.
- Versions-Aware Cache-Invalidation.
- `offline.html` als Fallback.

### 8.3 Permissions (MUST)

- Push-Notification-Permission **niemals** beim Pageload abfragen — nur nach User-Geste mit klarem Kontext. Chrome blockiert sonst via Quiet UI.
- Geolocation, Camera, Microphone analog.

---

## 9. Motion & Animation

Motion kommuniziert State-Change, Hierarchie, Kontinuität — nicht Selbstzweck. Default: weniger ist mehr. Cross-Cuts: §2 (Performance), §3.8 (Accessibility), §7 (Browser-Support).

### 9.1 Duration-Tokens (MUST)

Vier verbindliche Stufen als CSS Custom Properties. Werte konsolidiert aus Material 3 / IBM Carbon / Apple HIG (Konsens-Range 100–500 ms).

```css
:root {
  --motion-duration-instant: 100ms; /* Hover, Press, Icon-Switch */
  --motion-duration-short:   200ms; /* Tooltip, Dropdown, Toast */
  --motion-duration-base:    300ms; /* Drawer, Modal, Tab-Switch */
  --motion-duration-long:    500ms; /* Page-Transition, Hero */
}
```

Alles >500 ms erfordert begründete Ausnahme im Design-Review. Auto-Loops ohne User-Trigger separat rechtfertigen (s. 9.5).

### 9.2 Easing-Tokens (MUST)

```css
:root {
  --motion-ease-standard:   cubic-bezier(0.2, 0, 0, 1);      /* Default UI */
  --motion-ease-out:        cubic-bezier(0, 0, 0.2, 1);      /* Entrance */
  --motion-ease-in:         cubic-bezier(0.4, 0, 1, 1);      /* Exit */
  --motion-ease-emphasized: cubic-bezier(0.05, 0.7, 0.1, 1); /* Hero/Brand */
}
```

Spring/Bounce via CSS `linear()` (Baseline seit Dez 2023, ~88 % Coverage). Fallback auf cubic-bezier-Approximation für ältere Browser.

### 9.3 Animierbare Properties (MUST)

Nur **`transform`**, **`opacity`**, **`filter`** in Animationen/Transitions. Diese laufen compositor-only ohne Layout/Paint und sind die einzigen Properties, die INP nicht degradieren.

Layout-triggernde Properties (`width`, `height`, `top`, `left`, `margin`, `padding`, `font-size`) in Animationen **verboten**. Substitute:

- Größenänderung → `transform: scale()` (mit `transform-origin`).
- Positionsänderung → `transform: translate()`.
- Höhen-Reveal → `interpolate-size: allow-keywords` + `height: auto` (Baseline-Status prüfen) oder Grid-Template-Rows-Trick.

### 9.4 GPU-Hints (MUST)

- `will-change` **nur via JS** kurz vor Trigger setzen und nach Abschluss entfernen (`el.style.willChange = ''`). Niemals statisch im CSS auf >5 Elementen — Memory-Overhead durch ungenutzte Compositor-Layer.
- `translate3d(0,0,0)`-Hack: obsolet, moderne Engines promoten automatisch.
- Ziel: 60 fps auf Mid-Range-Mobile (Lighthouse Mobile-Throttle als Referenz).

### 9.5 Reduced Motion (MUST)

Pflicht-Block in jedem Stylesheet mit Animationen. **Nicht** komplett aus — "essential motion" via Opacity bleibt erlaubt (Material 3 / Apple HIG Konsens). Bewegung wird ersetzt, nicht eliminiert.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 150ms !important; /* nur opacity */
    scroll-behavior: auto !important;
  }
}
```

Zusätzlich verbindlich:

- Parallax, Auto-Rotate, Auto-Carousel ≥5 s ohne Pause-Control bei `reduced-motion` deaktivieren.
- WCAG 2.2.2 (A): Auto-Animation >5 s muss pausierbar sein.
- WCAG 2.3.3 (AAA, empfohlen): interaktion-getriggerte Bewegung >5° Drehung oder >⅓ Viewport-Distanz braucht Disable-Option.
- Vestibular-Trigger (große Translates, Zoom-In auf Hero, schnelle Rotationen) bei `reduced-motion` durch Opacity-Crossfade ersetzen.

### 9.6 Scroll-driven Animations (SHOULD — Progressive Enhancement)

`animation-timeline: scroll() | view()` ist Mai 2026 **nicht Baseline** (~85 %, Firefox partial hinter Flag). Einsatz:

- Nur hinter `@supports (animation-timeline: scroll())`.
- Kein layout-kritischer Content darf davon abhängen.
- Für komplexe Choreografie oder präzises Scrubbing: GSAP ScrollTrigger (s. 9.8).

### 9.7 View Transitions (SHOULD)

- **Same-document** (SPA-State-Wechsel): Baseline. `document.startViewTransition()` nutzen.
- **Cross-document** (MPA-Navigation): Chrome 126+, Safari 18.5+, Firefox 146 partial. Interop-2026-Kandidat. Bei Astro / Next.js App Router via Framework-Bridge bis flächendeckender Support.
- `prefers-reduced-motion` respektieren (s. 9.5) — View Transitions sind technisch Animationen.

### 9.8 Framework-Stack (SHOULD)

Hierarchie nach Komplexität — immer das Leichteste das die Aufgabe löst.

| Stufe | Tool | Wann |
|---|---|---|
| 1 | **CSS-native** (Transitions, Keyframes, `linear()`, `@starting-style`, View Transitions) | Default — 80 %+ aller Cases. 0 KB Bundle. |
| 2 | **Motion** (`motion`, ehem. Framer Motion, MIT, ~4.6 KB mit `LazyMotion` + `m`) | React-UIs mit Layout-Animationen, `AnimatePresence`, Gestures. |
| 3 | **GSAP** (Standard-Lizenz seit Mai 2025 vollständig kostenlos, alle Plugins inkl.) | Komplexe Timelines, SVG-Animationen, Scroll-Scrubbing (ScrollTrigger), Text-Splits. |
| 4 | **Anime.js v4** (MIT) | Vanilla-JS-Alternative ohne React. |
| 5 | **AutoAnimate** (formkit, MIT, ~3 KB) | Drop-in für List-Reorder (React/Vue/Svelte). |

**Pflicht-Wrapper:**

- GSAP in React: `@gsap/react` mit `useGSAP()` für SSR-safes Cleanup.
- Motion in React: `LazyMotion` + `m`-Component statt `motion.div` für Tree-Shaking (sonst ~34 KB statt ~4.6 KB).

**Nicht mehr empfohlen:** VelocityJS (tot seit 2020), jQuery-Animationen, eigener `requestAnimationFrame`-Loop für Standard-Cases (Motion/GSAP haben besseren A11y- und Throttling-Support).

**Smooth-Scroll (Lenis o.ä.):** Nur als bewusste Designentscheidung. Scroll-Hijacking ist a11y-kritisch — auf Mobile-Touch und bei `prefers-reduced-motion` deaktivieren. Native `scroll-behavior: smooth` + `scroll-snap` reicht für 90 % der Cases.

### 9.9 Konsens-Quellen (Referenz)

Material Design 3 (Motion-Tokens), IBM Carbon (Productive/Expressive Modes), Apple HIG (Reduced-Motion-Kriterien), Adobe Spectrum (Easing-Set). Bei Konflikt M3 als Default.

**Prüfung Gesamtblock 9:** DevTools Performance (60 fps unter Mobile-Throttle), Lighthouse "Avoid non-composited animations", manueller `prefers-reduced-motion`-Test (macOS: System-Einstellungen → Bedienungshilfen → Anzeige → Bewegung reduzieren).

---

## 10. Pflicht-Dateien im Repo-Root

**MUST auf jeder Site:**

| Datei | Zweck | Verweis |
|---|---|---|
| `/robots.txt` | Crawler-Steuerung + Sitemap-Pointer | 4.5 |
| `/sitemap.xml` (oder Index) | URL-Discovery | 4.5 |
| `/favicon.ico`, `/favicon.svg`, `/apple-touch-icon.png` | Browser-Icons | 1.5 |
| `/.well-known/security.txt` | Vulnerability Disclosure | 5.11 |
| `/404.html` | Statisches 404 ohne JS-Abhängigkeit | – |
| `/500.html` | Inline-CSS, keine externen Assets | – |

**SHOULD (bei installierbaren PWAs MUST):**

| Datei | Zweck | Verweis |
|---|---|---|
| `/site.webmanifest` | PWA-Manifest | 8.1 |
| `/icon-192.png`, `/icon-512.png`, `/icon-512-maskable.png` | PWA-Icons | 8.1 |

**Conditional MUST (bei Login-Sites):**

| Datei | Zweck | Verweis |
|---|---|---|
| `/.well-known/change-password` | Password-Manager-Redirect | 5.10 |

**MAY:**

| Datei | Zweck |
|---|---|
| `/offline.html` | Service-Worker-Fallback |
| `/llms.txt` | LLM-Discovery (siehe 4.7) |
| `/humans.txt` | Credits |

---

## 11. Pre-Launch-Checkliste

Verbindliche, druckbare Pre-Launch-Liste: siehe **[`checklist.md`](./checklist.md)** im selben Repo. Single Source of Truth für die Abnahme — dieses Kapitel ist bewusst leer, um Drift zu vermeiden.

---

## 12. Audit bestehender Projekte

Vorgehen für die Migration einer Bestands-Site auf diese Standards. Die drei Phasen sind als Claude Code Skills im Repo unter `.claude/skills/` umgesetzt:

- **`everlast-web-setup`** — Pflicht-Artefakte und Foundation (§1, §5, §7, §8, §10)
- **`everlast-web-design`** — Brand-DNA, DESIGN.md, Anti-Slop, Visual-Diff-Loop, Motion-Tokens (§9.1/9.2)
- **`everlast-web-audit`** — Pre-/Post-Launch-Check (Lighthouse + Mozilla Observatory + PageSpeed Insights, JSON-Output gegen die Schwellen unten)

1. **Baseline-Snapshot:** `everlast-web-audit` Skill triggern (führt Lighthouse, Mozilla Observatory, PageSpeed Insights aus, mappt Findings auf MUSTs). Bei BFSG-relevanten Sites zusätzlich `@axe-core/cli` mit `--tags wcag22aa`.
2. **Quick-Wins (1–2 Tage):**
   - Security-Header-Baseline + HSTS einziehen.
   - `/.well-known/security.txt` anlegen.
   - Favicon-Set, Manifest, Theme-Color, color-scheme ergänzen.
   - Canonical, OG, hreflang Lücken schließen.
   - Image `width`/`height` Attribute nachziehen (CLS).
   - Motion-Tokens (§9.1/9.2) + `prefers-reduced-motion` Block (§9.5) ergänzen.
3. **Mid-Term (1–2 Wochen):**
   - CSP Level 3 mit Nonce einführen (zuerst Report-Only, dann enforce).
   - JSON-LD Organization + WebSite + BreadcrumbList.
   - Cookie-Consent prüfen, ggf. austauschen.
   - Google Fonts lokalisieren.
   - Accessibility-Sweep mit axe + manuellem Keyboard-Test.
4. **Long-Term (Roadmap):**
   - Image-Pipeline auf AVIF.
   - JS-Budget-Reduktion (Third-Party-Audit).
   - BFSG-Konformität bei B2C (falls noch nicht erfüllt).
   - PWA-Manifest + optional Service Worker.

---

## 13. Tools-Referenz

**Drei Tools sind agent-automatisiert** und werden vom `everlast-web-audit` Skill direkt per CLI/curl ausgeführt (JSON-Output):
- `lighthouse <url> --output=json` — Performance, SEO, A11y, Best Practices
- `curl observatory-api.mdn.mozilla.net/api/v2/scan?host=<host>` — Security-Header
- `curl googleapis.com/pagespeedonline/v5/runPagespeed?url=<url>` — CrUX-Felddaten + Lab

Die restlichen Tools laufen weiter manuell (UI / Browser / Spezialisten):

| Kategorie | Tool | Ziel |
|---|---|---|
| Performance | PageSpeed Insights, WebPageTest, Lighthouse | CWV grün, LH Mobile ≥ 90 |
| Performance | Chrome DevTools Performance | INP, Long Tasks |
| Accessibility | axe DevTools, WAVE, Lighthouse | 0 Violations |
| Accessibility | BIK BITV-Test | Manueller Test bei B2C |
| Accessibility | NVDA, VoiceOver | Screen-Reader-Walkthrough |
| SEO | Screaming Frog, Ahrefs Site Audit | Crawl-Sauberkeit |
| SEO | Google Search Console | Coverage, hreflang |
| SEO | Rich Results Test, Schema Markup Validator | JSON-LD korrekt |
| Social | opengraph.xyz, X Card Validator | OG / X-Card Preview |
| Security | SSL Labs | A+ |
| Security | securityheaders.com | A+ |
| Security | Mozilla Observatory | A+ |
| Security | CSP Evaluator (Google) | Keine roten Befunde |
| Privacy | Inkognito Netzwerk-Tab | Vor Consent keine Third-Party |
| Privacy | Cookiebot Scan / Klaro / Usercentrics | Vollständigkeit |

---

## Changelog

- **2026-05-11 · v1.5** · Neuer Abschnitt **§9 Motion & Animation** als eigene Top-Level-Section. Konsolidiert vorher verstreute Motion-Pflichten und ergänzt um Framework-Empfehlungen.
  - **§9.1 Duration-Tokens** (100/200/300/500 ms) + **§9.2 Easing-Tokens** (4 cubic-bezier-Werte) als verbindliche CSS Custom Properties. Konsens aus Material 3, IBM Carbon, Apple HIG, Adobe Spectrum.
  - **§9.3 Animierbare Properties**: nur `transform`, `opacity`, `filter`. Layout-Properties in Animationen verboten (INP-Schutz).
  - **§9.4 GPU-Hints**: `will-change` nur via JS, `translate3d(0,0,0)`-Hack als obsolet markiert.
  - **§9.5 Reduced Motion**: Pflicht-Block ausgeschrieben, "essential motion" via Opacity bleibt erlaubt (M3/HIG-Konsens). WCAG 2.2.2 + 2.3.3 referenziert.
  - **§9.6 Scroll-driven Animations** als Progressive Enhancement hinter `@supports`.
  - **§9.7 View Transitions** aus §2.9 hierher gezogen, Same- vs. Cross-Document getrennt.
  - **§9.8 Framework-Stack** mit 5-stufiger Hierarchie: CSS-native first → Motion → GSAP → Anime.js v4 → AutoAnimate. GSAP seit Mai 2025 vollständig kostenlos (Webflow-Übernahme) inkl. aller Plugins, Empfehlungs-Update entsprechend. VelocityJS als tot markiert.
  - **Renumbering:** alte §9–§12 → §10–§13. **§3.8 "Media & Motion"** → "Media" (Motion-Teil als Verweis auf §9). **§2.9** → "Speculation Rules" (View Transitions als Verweis auf §9.7).
  - **checklist.md** synchronisiert: neuer Motion-Block mit Tokens, Property-Whitelist, Framework-Disziplin.
- **2026-05-11 · v1.4** · Nachschliff nach drei externen Modell-Reviews (Gemini, Claude, ChatGPT — alle ~8.4–9.0/10, konvergent: "inhaltlich stark, leicht zu lang/strikt").
  - **Drei-Ebenen-Modell** explizit im Eingangs-Block: MUST / Conditional MUST / SHOULD / MAY. Härtegrade sauberer getrennt.
  - **CDN** MUST → Conditional MUST (bei internationaler Zielgruppe / Traffic-Risiko); sonst SHOULD.
  - **AVIF primary** MUST → SHOULD. Responsive Bild-Pipeline (`width`/`height`, `srcset`/`sizes`, Lazy, LCP-Image `fetchpriority`) bleibt MUST.
  - **Meta-Description-Länge** als SHOULD (Eindeutigkeit MUST).
  - **"Genau ein H1" / "keine Heading-Skips"** als Default/SHOULD (nicht mehr pauschaler MUST).
  - **Premium-Werte** (LCP < 2.0s, INP < 100ms, JS < 100 KB) entfernt — verwirrt bei Kundenverhandlungen, gehört ggf. ins Angebot, nicht in den Standard.
  - **Lighthouse vs CrUX**: explizite Trennung — Lab als Pre-Launch-Smoke-Test, CrUX als verbindliche Wahrheit nach ausreichend Traffic.
  - **JSON-LD-Wording**: "Default" statt "einzig empfohlen" (Google akzeptiert weiterhin Microdata/RDFa).
  - **AI-Citation-Aussagen** vorsichtiger formuliert ("können helfen" statt "stärkste Hebel" — keine belastbare Kausalität).
  - **`frame-ancestors 'none'`** mit Allowlist-Hinweis (bricht sonst Whitelabel-Previews / Kunden-Embeds).
  - **Consent-Wording**: "keine nicht-notwendige Speicherung/Auslesung/Verarbeitung vor Consent" statt absolutem "kein Tracking-Script darf vor Consent laden" (Consent Mode Advanced lädt technisch mit denied-Signalen).
  - **Code-Snippets gestrafft**: HTML-Boilerplate-Block, Body-Skeleton, `<picture>`-Beispiel, Form-Snippet, `:focus-visible`-Block, `prefers-reduced-motion`-Block — Anforderung in 1-2 Sätzen, Code raus (Agents generieren das fehlerfrei aus Prosa).
  - **Container Queries als Default** für komponenten-lokale Layouts (Gemini-Empfehlung).
  - **WCAG 2.2 AA als technische Baseline** klargestellt — rechtliche Zielnormen sind projektabhängig (EN 301 549 referenziert noch 2.1).
  - **Bußgeld 50 000 €** mit Quelle "DDG § 5 Abs. 4" referenziert.
  - **MLBF/BAS-Wording korrigiert**: BFIT/BAS bleibt als Beratungsstelle, nur Marktüberwachungskompetenz wandert zur MLBF AöR.
  - **Changelog v1.0–v1.3** in separate [`CHANGELOG.md`](./CHANGELOG.md) ausgelagert.

Frühere Versionen siehe [`CHANGELOG.md`](./CHANGELOG.md).
