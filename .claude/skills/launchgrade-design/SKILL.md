---
name: launchgrade-design
description: Anti-slop design layer for web projects. Captures style direction (3 variants → user picks), writes DESIGN.md as brand constitution, optionally a COPY.md template, gates handoff to audit on explicit user approval. The user develops the design themselves — the skill only intervenes at three checkpoints (pick direction, lock DESIGN.md, audit gate). Defines named aesthetic references, blocks AI default patterns (Inter, purple-pink gradients, default shadcn, rounded-XL bento, generic Lucide hero icons). Triggers on "design", "look", "brand", "DESIGN.md", "COPY.md", "copy", "anti-slop", "not generic", "looks generic", "style guide", "Design", "Anti-Slop", "sieht generisch aus", "Style Guide", "Webseiten-Text".
---

# Launchgrade Web Design Skill

Zweite Phase im Launchgrade-Workflow: **Build-Layer Anti-Slop**. Adressiert das Hauptproblem 2026 — AI-generierte Sites sehen alle gleich aus.

## Grundsatz

**Der User entwickelt das Design selbst.** Der Skill ist Brand-Constitution, nicht Pre-Build-Pipeline. Er greift nur an **drei Punkten** ein:

1. **Style-Direction wählen** — 3 Varianten zeigen, User picked eine
2. **DESIGN.md festschreiben** — Brand-System als versioniertes Artefakt
3. **Hard Gate vor Audit** — kein stilles Weitergehen nach Build

Sektionen bauen, Komponenten, Spacing-Feinschliff, Copy schreiben, Animationen — macht der User selbst. Sage ihm das explizit nach DESIGN.md-Übergabe.

## Wann triggern

- Brand-DNA / Design-Sprache für ein neues Projekt definieren
- DESIGN.md erstellen, aktualisieren oder reviewen
- Output wirkt generisch: "sieht aus wie jede AI-Site", "zu Vercel-mäßig", "Lila-Gradient raus", "Default-Slop"
- Refactor visueller Layer eines bestehenden Projekts

Nicht triggern bei: technischen Setup-Fragen (→ `launchgrade-setup`), Audit/Pre-Launch (→ `launchgrade-audit`), rein logischen Code-Fragen, Component-Implementierungen während des Builds.

## Das Grundproblem

LLMs samplen aus dem statistischen Zentrum ihrer Trainingsdaten. Resultat: Inter, Lila-Pink-Gradient, Bento-Grid mit Rounded-XL, Lucide-Icons im Hero, blauer "Get Started"-Button. Der Term **"AI Slop Web Design"** ist seit Q1 2026 etablierter Designer-Terminus. Anti-Slop ist 2026 Pflicht für jede ernsthafte Brand.

## Wirkende Formel (Konsens 2026)

`DESIGN.md (versioniert im Projekt) + Named Aesthetic + Reference-Mix + Explicit Anti-Patterns + User-Approval-Gate vor Audit`

LLMs ignorieren naive Prompt-Injection unter Decoding-Druck. Was funktioniert:

1. **DESIGN.md liegt im Projekt**, nicht im System-Prompt
2. **User entwickelt das Design selbst** auf dieser Basis
3. **Vor Release: Approval-Gate**, nicht stille Übergabe

## Vorgehen

1. **Kontext einmalig sammeln — kein Loop:**

   Design-Input ist eine eigene Entscheidung, nicht aus Setup-Antworten ableitbar. Wenn der User in der Setup-Phase *"mach du"* gesagt hat, bezog sich das auf technische Defaults — nicht auf Design.

   **Pfad-Wahl per `AskUserQuestion`**, PFLICHT:
   - Question: *"Wie möchtest du den Design-Input geben?"*
   - Options: *Pfad A · Visuelle Referenzen* / *Pfad B · entscheide du* / *Pfad C · Hybrid*

   **Pfad A · Visuelle Referenzen (bevorzugt):** User liefert URLs (`WebFetch`) und/oder Screenshots/Logo/Brand-Assets (`Read` multimodal). Eine Runde reicht — User gibt was er hat, Skill spiegelt in **2–3 Sätzen** zurück (Typo-Charakter, Farb-Stimmung, Layout-Gefühl), dann weiter. Nicht nach jedem Bild *"noch was?"* fragen.

   **Pfad B · Entscheide du:** Heuristik nach Branche/Tonalität. Skill bestätigt kurz *"Okay, 3 Direktionen nach Branche — keine Refs."*

   **Pfad C · Hybrid:** Grobe Worte (*"editorial, nicht Tech-mäßig"*) + 1–2 Refs. Auch hier eine Runde.

   **Zusätzlich einmal erfassen** (knapp, in einer Nachricht abfragen oder aus `project.config.json` lesen):
   - Brand-Name + USP in einem Satz
   - Branche / Tonalität (Edel-Luxus, B2B-Pragmatisch, Tech-Spielerisch, Editorial, Brutalist, Soft-Friendly)
   - Brand-Assets (Logo, Farb-Hex, Schriftnamen) sofern vorhanden
   - **Motion-Charakter — 1–2 Adjektive** (*"calm + slow"* vs. *"kinetic + snappy"* vs. *"minimal + functional"*). Informiert Layout (Section-Höhen, Whitespace), keine konkreten Animations-Tokens.

   **Gate zu Step 2:** Ohne visuelle Refs nur weitergehen, wenn User explizit **Pfad B** gewählt hat.

2. **Style-Picker generieren — interaktive Wahl bevor DESIGN.md entsteht:**

   3 distinkte Style-Direktionen auf Basis des Kontexts — klar polar, nicht 3× Variationen derselben Idee. Jede mit konkreter Named Aesthetic, nie "modern/clean/minimalistisch".

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

7. **Hand-off Brief an den User — knapp, vor Build-Phase:**

   Skill gibt explizit aus (kein `AskUserQuestion`, normaler Text):

   > *"DESIGN.md steht. Bau jetzt selbst durch — in 3 Phasen:*
   > *1. Static — Layout + Copy + Color + Typo. Sieht final aus, ohne Bewegung.*
   > *2. Micro-Interactions — Hover, Focus, Button-Press. A11y-Pflicht.*
   > *3. Motion-Layer — Scroll-Reveals, Animations. Letzter Pass.*
   > *Komm zurück zum Skill für den Audit-Gate, wenn du fertig bist."*

   Dieser Brief macht dem User klar: ab hier User-Driven, Skill ist Reference.

8. **Hard Gate vor Audit-Übergabe — `AskUserQuestion`, PFLICHT:**

   Letzter Skill-Step, kein automatischer Übergang. Vorher prüfen: DESIGN.md existiert und ist nicht leer. Wenn COPY.md vorhanden: `{{TODO}}`-Tokens listen und User darauf hinweisen.

   Question: *"Design + Build final freigegeben — Übergabe an /launchgrade-audit?"*
   Options:
   - *Ja, Audit starten*
   - *Nein, eine Sektion in DESIGN.md anpassen*
   - *Komplett neue Direktion* (zurück in Step 1)

   Bei *Ja* keinen Audit selbst auslösen — User triggert `/launchgrade-audit <URL>` manuell, sobald die Seite erreichbar ist.

Standards-Lookup: `./web-standards/AGENTS.md` im Repo.

## Verhalten

- **Der User entwickelt das Design selbst** — der Skill ist Brand-Constitution, nicht Pre-Build-Tooling.
- DESIGN.md liegt **im Projekt**, nicht zentral — pro Brand individuell, versioniert.
- COPY.md ist optional. Wenn ja: leere Vorlage, User füllt.
- Motion strikt in 3 Phasen: Static → Micro-Interactions → Motion-Layer. Niemals umgekehrt — Animationen vor Static-Approval ist polishing turd.
- Named References mit konkreten Aspekten — nie "modern und clean".
- Bei Konflikt Brand vs. A11y: A11y gewinnt (AGENTS.md §3).
- Pfad-Wahl, Style-Auswahl, Hard Gate: alle drei via `AskUserQuestion`, nie nummerierte Chat-Liste.
- Niemals stillschweigend zu `launchgrade-audit` weitergehen — Hard Gate ist Pflicht.
- Auf Deutsch antworten, Tokens/Properties/Vokabular auf Englisch.
- Em-dashes in user-facing Copy sparsam — maximal einer pro längerem Absatz.

## Anti-Patterns

- ❌ Aus Setup-*"mach du"* lautlos eine Design-Vollmacht ableiten. Pfad B ist erlaubt — aber nur wenn der User ihn **für Design** explizit wählt.
- ❌ Aus Setup-Daten (Primary-Color für Manifest, Brand-Name) eine Brand-Palette extrapolieren — Design-Entscheidung gehört in diesen Skill mit User-Bestätigung.
- ❌ Akkumulations-Loop (*"noch was? noch was? noch was?"*) — eine Runde reicht.
- ❌ Copy "vorschlagen", Voice & Tone-Konsistenz prüfen, Headlines generieren — Copy ist User-Job. Skill schreibt nur leere Vorlage.
- ❌ Live-Preview-HTML als zweites Mockup nach Style-Picker — der Style-Picker IST die Preview. Echte Preview ist die gebaute Seite.
- ❌ Animationen vor statischem Layout — DESIGN.md Phase 1 muss zuerst stehen.
- ❌ "Modern, clean, minimalistisch" als Brand-DNA — bedeutungsleer.
- ❌ Inter als Default-Font ohne Begründung.
- ❌ Tailwind-Slate-Palette ohne Brand-Override.
- ❌ Lucide-Icons im Hero ohne Brand-Argument.
- ❌ Shadcn-Components ohne Token-Override.
- ❌ DESIGN.md weglassen *"weil das eh im Prompt steht"* — funktioniert nachweislich nicht.
- ❌ Stillschweigend zu Audit weitergehen — Hard Gate ist Pflicht.
- ❌ Brand-Eigenwille über WCAG-Kontrast stellen.

## Übergabe

- Phase abgeschlossen erst nach **Hard Gate (Step 8)** mit explizitem User-*Pass*.
- DESIGN.md liegt im Projekt-Root, versioniert. COPY.md optional, falls angelegt ebenfalls Root.
- Style-Picker unter `.launchgrade/mockups/style-picker.html` bleibt liegen — nützlich als visuelle Ground-Truth.
- Vor Release: **`launchgrade-audit`** für technischen Check (Lighthouse + Observatory + PSI). Der Skill löst den Audit nicht selbst aus — User triggert manuell sobald die Seite erreichbar ist.
- Design-Qualität bleibt manueller Check via DESIGN.md vs. Output — kein Tool ersetzt Designer-Auge.

## Aktualität

Anti-Slop-Patterns ändern sich mit dem Slop. Wenn 2026 Inter zum Klischee wurde, kann 2027 etwas anderes folgen. DESIGN.md ist living document — bei jedem neuen Projekt prüfen, ob die Defaults noch frisch sind.
