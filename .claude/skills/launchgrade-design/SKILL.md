---
name: launchgrade-design
description: Anti-slop design layer for web projects. Captures style direction (3 variants → user picks), writes DESIGN.md as brand constitution, optionally a COPY.md template, then produces a first static draft (layout, copy, color, typo) after DESIGN.md is locked, then hands off to the user for refinement (Phase 2 Micro + Phase 3 Motion + Copy-Tweaks). Gates handoff to audit on explicit user approval. Defines named aesthetic references, blocks AI default patterns (Inter, purple-pink gradients, default shadcn, rounded-XL bento, generic Lucide hero icons). Triggers on "design", "look", "brand", "DESIGN.md", "COPY.md", "copy", "anti-slop", "not generic", "looks generic", "style guide", "first draft", "static draft", "erster Entwurf", "Design", "Anti-Slop", "sieht generisch aus", "Style Guide", "Webseiten-Text".
---

# Launchgrade Web Design Skill

Zweite Phase im Launchgrade-Workflow: **Build-Layer Anti-Slop**.

## Grundsatz

**Der Skill produziert einen ersten Static-Draft (Phase 1) — Verfeinerung, Micro-Interactions und Motion-Layer macht der User selbst.** Der Skill ist Brand-Constitution + First-Draft-Generator, keine Full-Build-Pipeline. Er greift an **vier Punkten** ein:

1. **Style-Direction wählen** — 3 Varianten zeigen, User picked eine
2. **DESIGN.md festschreiben** — Brand-System als versioniertes Artefakt
3. **First-Draft Build (Phase 1 Static)** — Components + Tokens + Copy-Erstentwurf nach DESIGN.md
4. **Hard Gate vor Audit** — kein stilles Weitergehen nach User-Refinement

Phase 2 Micro-Interactions, Phase 3 Motion-Layer, Copy-Verfeinerung, eigene Fotos, Sektionen umsortieren — macht der User selbst nach dem Static-Draft. Sage ihm das explizit beim Hand-off.

## Vorgehen

1. **Kontext einmalig sammeln — kein Loop:**

   **Pfad-Wahl per `AskUserQuestion`**, PFLICHT:
   - Question: *"Wie möchtest du den Design-Input geben?"*
   - Options: *Pfad A · Visuelle Referenzen* / *Pfad B · entscheide du* / *Pfad C · Hybrid*

   - **Pfad A**: User liefert URLs (`WebFetch`) + Screenshots/Logo (`Read` multimodal). **Eine Runde** — Skill spiegelt in 2–3 Sätzen zurück (Typo, Farbe, Layout), dann weiter. Nicht *"noch was?"* schleifen.
   - **Pfad B**: Heuristik nach Branche/Tonalität, keine Refs.
   - **Pfad C**: Grobe Worte + 1–2 Refs, gleicher Spiegel-Schritt wie A.

   **Zusätzlich einmal erfassen** (knapp, oder aus `project.config.json` lesen):
   - Brand-Name + USP in einem Satz
   - Branche / Tonalität (Edel-Luxus, B2B-Pragmatisch, Tech-Spielerisch, Editorial, Brutalist, Soft-Friendly)
   - Brand-Assets (Logo, Farb-Hex, Schriftnamen) sofern vorhanden
   - **Motion-Charakter — 1–2 Adjektive** (*"calm + slow"* / *"kinetic + snappy"* / *"minimal + functional"*). Informiert Layout, keine Animations-Tokens.

   **Gate zu Step 2:** Ohne visuelle Refs nur weitergehen, wenn User explizit **Pfad B** gewählt hat.

2. **Style-Picker generieren — interaktive Wahl bevor DESIGN.md entsteht:**

   3 distinkte Style-Direktionen — klar polar, nicht 3× Variationen derselben Idee. Jede mit konkreter Named Aesthetic, nie "modern/clean/minimalistisch".

   **Direktions-Heuristik nach Branche/Tonalität** (Inspiration, nicht starr):
   - B2C-Lifestyle / Wellness / Therapie → Editorial Serif · Warm Monochrome · Soft Hand-Drawn
   - B2B-Tech / SaaS → Industrial Mono · Pragmatic Clean · Tech-Playful Geometric
   - E-Commerce / Fashion → Editorial Wide-Serif · Industrial Brutalist · Soft Neutral Premium
   - Banking / Finance → Editorial Conservative · Pragmatic Trust · Modern Neutral
   - Agentur / Portfolio → Editorial Bold · Industrial Brutalist · Maximalist Color

   **HTML-Mockup** unter `.launchgrade/mockups/style-picker.html` — eine Datei, 3 Sections gestapelt, jede ~700–900 px. Self-contained.

   Pro Section: Header `Variante A · [Named Aesthetic]` + Mini-Hero (Eyebrow, Headline mit `{{BRAND_NAME}}`, Sub, Primary + Secondary CTA) + Typography-Specimen (Heading + Body namentlich, `AaBbCc 123 — &?`) + Color-Palette (5–6 Swatches mit Hex) + Anti-Slop-DNA (3 Bullets *"Was diese Variante ausmacht"*).

   Brand-Name + Tagline aus `project.config.json` lesen, sonst Platzhalter.

   **Im Browser öffnen** — Tool-Detection-Reihenfolge:
   1. `agent-browser open .launchgrade/mockups/style-picker.html`
   2. `mcp__claude-in-chrome__tabs_create_mcp` mit `file://` URL
   3. Fallback: absoluter Pfad zum manuellen Öffnen

   **`.launchgrade/` muss in `.gitignore`** — falls fehlt, ergänzen.

3. **Auswahl per `AskUserQuestion`** — PFLICHT, keine nummerierte Chat-Liste:
   - Question: *"Welche Style-Direktion soll DESIGN.md festschreiben?"*
   - Options: *Variante A* · *Variante B* · *Variante C* · *Kombi (ich beschreibe selbst)*
   - Bei "Kombi" Nachfass: *"Was kombinieren?"* (z.B. "Typo aus B, Palette aus C, Hero-Layout aus A")

4. **DESIGN.md schreiben** auf Basis der gewählten Variante, mit Pflicht-Sektionen:
   - **Brand-DNA**: 3–5 Adjektive die die Brand IST + 3–5 die sie NICHT ist
   - **Named Aesthetic Reference**: konkret mit Aspekten — z.B. *"Linear's perspective grid + Stripe's docs typography + Mr Porter's editorial spacing"*. Niemals "modern, clean, minimalistisch".
   - **Typography**: konkrete Schriften (NIEMALS Inter als Default), Type-Scale mit echten Werten, Pairings
   - **Color**: kalibrierte Palette in OKLCH (nicht Tailwind-Slate). Primary, Secondary, 5-Step-Neutral, Semantic, explizite Kontrast-Paare
   - **Spacing & Layout**: Grid-System, asymmetrische Defaults, Container-Queries
   - **Motion — in 3 Phasen klar getrennt:**
     - **Phase 1 · Static** — Layout, Color, Typo, Spacing final ohne JS-Motion. Hier wird zuerst gebaut.
     - **Phase 2 · Micro-Interactions** — Hover, Focus, Button-Press, Form-States. UX- und A11y-Pflicht. Kommt nach Static.
     - **Phase 3 · Motion-Layer** — Scroll-Triggers, Hero-Reveals, Spring-Animations. Erst wenn Phase 1+2 stehen. `prefers-reduced-motion`-Fallback Pflicht.
   - **Component-Prinzipien**: was darf Shadcn-Default sein, was wird gebrandet, was ist custom
   - **Forbidden Defaults**: was diese Brand NIE macht (Inter, Lila-Gradient, Default-Lucide-Hero-Icons, "Get Started", Glass-Morphism ohne Grund, Tailwind-Slate-Palette ohne Override)
   - **Reference-Mix**: 3–5 Sites mit konkreten Aspekten pro Site

5. **Optional: leere COPY.md-Vorlage anlegen** — nur wenn der User es will:
   - Question: *"COPY.md-Vorlage anlegen? (zentraler Ort für Webseiten-Texte)"*
   - Options: *Ja, leere Vorlage* · *Nein, ich schreibe Copy inline beim Bauen*

   Bei *Ja*: COPY.md mit Sektionen-Skelett (Meta, Hero, Sections, Social Proof, FAQ, Footer, Microcopy, Voice & Tone) und `{{TODO}}`-Platzhaltern. Der Skill füllt nicht aus, schreibt keine Vorschläge, prüft keine Voice-Konsistenz. Der User schreibt selbst.

6. **A11y-Constraints aus AGENTS.md §3 lesen** — Anti-Slop darf nie Kontrast / Focus-Indicator / Reduced-Motion / Target-Size brechen. Brand-Eigenwille hört bei WCAG-Bruch auf. In DESIGN.md als Hard-Constraint dokumentieren.

7. **First-Draft Build (Phase 1 · Static)** — Skill produziert lauffähigen Erstentwurf basierend auf DESIGN.md + COPY.md.

   **Stack-Detection:** `project.config.json` → `stack`-Feld lesen. Astro / Next / SvelteKit / Nuxt / Plain HTML. Fallback: Repo-Files (`astro.config.*`, `next.config.*`, `svelte.config.*`, `nuxt.config.*`).

   **Component-Pattern je Stack:**
   - **Astro:** `src/components/<Section>.astro` + `src/layouts/Base.astro` (HTML-Skeleton, `<html lang>`, Skip-Link, Header/Main/Footer-Landmarks) + `src/pages/index.astro` (komponiert Sektionen)
   - **Next (App Router):** `app/components/<Section>.tsx` + `app/layout.tsx` + `app/page.tsx`
   - **SvelteKit:** `src/lib/components/<Section>.svelte` + `src/routes/+layout.svelte` + `src/routes/+page.svelte`
   - **Nuxt:** `components/<Section>.vue` + `layouts/default.vue` + `pages/index.vue`
   - **Plain HTML:** `index.html` mit semantischen Sections inline

   **Tokens:** `src/styles/tokens.css` (oder stack-Pendant) als CSS Custom Properties — Werte direkt aus DESIGN.md §Color (OKLCH), §Typography (font-family, type-scale), §Spacing (Grid, Container). Keine Tailwind-Slate-Defaults, keine Inter, keine Lila-Gradients.

   **Sections aus COPY.md ableiten:** Jede Top-Level-Sektion in COPY.md (Hero, Spec-Strip, About, Services, FAQ, Footer …) = ein Component. Reihenfolge wie in COPY.md.

   **Copy-First-Draft:** `{{TODO}}`-Slots in COPY.md mit ersten plausiblen Texten füllen. Voice/Tone aus DESIGN.md §Brand-DNA + §Reference-Mix. Fakten aus `project.config.json` und ggf. `CURRENT_SITE_ANALYSIS.md`. **Daten die nirgends stehen (Telefon, Spezial-Adressen, konkrete Termine) NICHT erfinden — als `{{TODO: <Beschreibung>}}` Inline-Marker stehen lassen.**

   **Phase-1-Disziplin — strikt Static:**
   - KEIN `IntersectionObserver`, keine Scroll-Reveals
   - KEINE View-Transitions, keine Spring-/Tween-Animations
   - KEIN JS-getriebenes Motion-Layer
   - CSS-only `:hover` / `:focus-visible` Styles erlaubt (gehören zu Phase 2 Micro, sind aber harmlos in Phase 1 mit drin)
   - `prefers-reduced-motion` respektieren (auch ohne Animationen schon defensiv stylen)

   **A11y-Pflicht im Draft:**
   - Skip-Link `<a href="#main">Zum Inhalt springen</a>` als erstes Body-Element
   - `<html lang="de">` (oder Projekt-Sprache aus `project.config.json`)
   - Semantische Landmarks: `<header>`, `<nav>`, `<main id="main">`, `<footer>`
   - Single `<h1>` pro Seite
   - `:focus-visible`-Indicator für alle interaktiven Elemente, target-size ≥ 24×24 px
   - Kontrast-Paare aus DESIGN.md verwenden — keine eigenen Mischungen

   **Smoke-Check:** Dev-Server background starten (`npm run dev` o.ä.), `curl -sI localhost:<port>/` auf HTTP 200 prüfen, dann Prozess killen. Bei Plain HTML: `python3 -m http.server` o.ä.

8. **Hand-off Brief an den User** (normaler Text, kein `AskUserQuestion`):

   > *"Erste Draft steht — Phase 1 Static (Layout + Copy + Color + Typo) ist im Repo. Verfeinere jetzt selbst:*
   > *- Copy-Tweaks, `{{TODO}}`-Marker auflösen (eigene Telefon, Adresse, Termine einsetzen)*
   > *- Sektionen umsortieren, eigene Fotos einbauen*
   > *- Phase 2 Micro-Interactions drüberlegen (Hover, Focus, Button-Press, Form-States — A11y-Pflicht)*
   > *- Phase 3 Motion-Layer als letzter Pass (Scroll-Reveals, Spring-Animations — `prefers-reduced-motion`-Fallback Pflicht)*
   > *Komm zurück zum Skill für den Audit-Gate, wenn du bereit bist."*

9. **Hard Gate vor Audit-Übergabe — `AskUserQuestion`, PFLICHT:**

   Letzter Skill-Step, kein automatischer Übergang. Vorher prüfen: DESIGN.md existiert und ist nicht leer, First-Draft-Components existieren. Wenn COPY.md vorhanden: verbleibende `{{TODO}}`-Tokens listen und User darauf hinweisen.

   Question: *"Design + Build final freigegeben — Übergabe an /launchgrade-audit?"*
   Options:
   - *Ja, Audit starten*
   - *Nein, eine Sektion in DESIGN.md anpassen*
   - *Komplett neue Direktion* (zurück in Step 1)

   Bei *Ja* keinen Audit selbst auslösen — User triggert `/launchgrade-audit <URL>` manuell, sobald die Seite erreichbar ist.

Standards-Lookup: `./web-standards/AGENTS.md` im Repo.

## Verhalten

- Motion strikt in 3 Phasen: Static → Micro-Interactions → Motion-Layer. Niemals umgekehrt — Animationen vor Static-Approval ist polishing turd.
- **Phase 1 Static (inkl. erstem Copy-Draft) macht der Skill. Phase 2 Micro-Interactions, Phase 3 Motion-Layer und Copy-Verfeinerung macht der User.**
- Named References mit konkreten Aspekten — nie "modern und clean".
- Bei Konflikt Brand vs. A11y: A11y gewinnt (AGENTS.md §3).
- Pfad-Wahl, Style-Auswahl, Hard Gate: alle drei via `AskUserQuestion`, nie nummerierte Chat-Liste.
- Niemals stillschweigend zu `launchgrade-audit` weitergehen — Hard Gate ist Pflicht.
- Daten die nicht in `project.config.json` oder `CURRENT_SITE_ANALYSIS.md` stehen, NICHT erfinden — als `{{TODO: …}}` markieren.

## Anti-Patterns

- ❌ Aus Setup-*"mach du"* lautlos eine Design-Vollmacht ableiten. Pfad B ist erlaubt — aber nur wenn der User ihn **für Design** explizit wählt.
- ❌ Brand-Palette aus dünner Luft / Setup-Defaults extrapolieren — Palette kommt explizit aus DESIGN.md, festgeschrieben in Step 4.
- ❌ Animationen vor statischem Layout — DESIGN.md Phase 1 muss zuerst stehen. Der First-Draft IST Phase 1.
- ❌ Phase 2 Micro / Phase 3 Motion ungefragt mitbauen — der Skill liefert nur Static, das andere ist User-Job.
- ❌ Erfinden von Daten die nicht in `project.config.json` oder `CURRENT_SITE_ANALYSIS.md` stehen (Telefon, Adresse, spezielle Termine) — markiere mit `{{TODO: …}}`.
- ❌ "Modern, clean, minimalistisch" als Brand-DNA — bedeutungsleer.
- ❌ Inter als Default-Font ohne Begründung.
- ❌ Tailwind-Slate-Palette ohne Brand-Override.
- ❌ Lucide-Icons im Hero ohne Brand-Argument.
- ❌ Shadcn-Components ohne Token-Override.
- ❌ DESIGN.md weglassen *"weil das eh im Prompt steht"* — funktioniert nachweislich nicht.
- ❌ Stillschweigend zu Audit weitergehen — Hard Gate ist Pflicht.
- ❌ Brand-Eigenwille über WCAG-Kontrast stellen.

## Übergabe

- DESIGN.md liegt im Projekt-Root, versioniert. COPY.md optional, falls angelegt ebenfalls Root — `{{TODO}}`-Slots durch First-Draft-Texte ersetzt, verbliebene `{{TODO: …}}`-Marker explizit gelistet.
- Lauffähiger Static-Draft im Repo: stack-spezifische Components (`src/components/*` o.ä.), Tokens in `src/styles/tokens.css`, gefüllter Entry-Page (`src/pages/index.astro` o.ä.) — Phase 1 only, keine JS-Motion.
- Style-Picker unter `.launchgrade/mockups/style-picker.html` bleibt liegen — nützlich als visuelle Ground-Truth.
- Design-Qualität bleibt manueller Check via DESIGN.md vs. Output — kein Tool ersetzt Designer-Auge.
