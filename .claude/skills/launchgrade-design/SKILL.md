---
name: launchgrade-design
description: Anti-slop design layer for web projects. Loops with the user to collect references (URLs, screenshots, logo, brand assets) until they say done. Generates an interactive style picker (3 directions, HTML cards stacked, browser-selectable), writes DESIGN.md and COPY.md based on the choice, renders a live HTML preview of the final design, gates handoff to audit on explicit user approval. Defines named aesthetic references, blocks AI default patterns (Inter, purple-pink gradients, default shadcn, rounded-XL bento, generic Lucide hero icons). Sets up a visual-diff loop with the project's browser tool (agent-browser / Playwright MCP / Chrome MCP). Triggers on "design", "look", "brand", "DESIGN.md", "COPY.md", "copy", "anti-slop", "not generic", "looks generic", "style guide", "Design", "Anti-Slop", "sieht generisch aus", "Style Guide", "Webseiten-Text".
---

# Launchgrade Web Design Skill

Zweite Phase im Launchgrade-Workflow: **Build-Layer Anti-Slop**. Adressiert das Hauptproblem 2026 — AI-generierte Sites sehen alle gleich aus.

## Wann triggern

- Brand-DNA / Design-Sprache für ein neues Projekt definieren
- DESIGN.md erstellen, aktualisieren oder reviewen
- Visual-Iteration-Loop einrichten (Tool-agnostisch — agent-browser / Playwright MCP / Chrome MCP, je nach Projekt-Setup)
- Output wirkt generisch: "sieht aus wie jede AI-Site", "zu Vercel-mäßig", "Lila-Gradient raus", "Default-Slop"
- Refactor visueller Layer eines bestehenden Projekts
- Component-Library-Anbindung (Design-System via MCP statt Prompt-Injection)

Nicht triggern bei: technischen Setup-Fragen (→ `launchgrade-setup`), Audit/Pre-Launch (→ `launchgrade-audit`), rein logischen Code-Fragen.

## Das Grundproblem

LLMs samplen aus dem statistischen Zentrum ihrer Trainingsdaten. Resultat: Inter, Lila-Pink-Gradient, Bento-Grid mit Rounded-XL, Lucide-Icons im Hero, blauer "Get Started"-Button. Der Term **"AI Slop Web Design"** ist seit Q1 2026 etablierter Designer-Terminus. Anti-Slop ist 2026 Pflicht für jede ernsthafte Brand.

## Wirkende Formel (Konsens 2026)

`DESIGN.md + COPY.md (beide versioniert im Projekt) + Named Aesthetic + Reference-Mix + Explicit Anti-Patterns + Live-Preview + User-Approval-Gate + Visual-Diff-Loop`

Naive Prompt-Injection einzelner Tokens funktioniert nicht — LLMs ignorieren sie unter Decoding-Druck. Was funktioniert:

1. **DESIGN.md + COPY.md liegen im Projekt** (nicht im System-Prompt), strukturiert mit klaren Sektionen — Design und Copy gehören zusammen, sonst rutscht Lorem-Ipsum-Slop wieder rein
2. **Skill lädt sie gezielt** vor jedem Design-Task
3. **Live-Preview im Browser** zeigt dem User das Resultat bevor weitergegangen wird
4. **Visual-Loop verifiziert Output** statt nur Gefühl

## Vorgehen

1. **Kontext abfragen — expliziter Trennschritt zum Setup:**

   Design-Input ist eine **eigene Entscheidung**, nicht aus Setup-Antworten ableitbar. Wenn der User in der Setup-Phase *"mach du"* / *"entscheide du"* gesagt hat, bezog sich das auf **technische Defaults** (Stack, npm, App-Router). Das ist **nicht** automatisch eine Design-Vollmacht — bevor Phase 2 startet, einmal aktiv beim User nachfragen.

   **Drei Eingabe-Pfade — Wahl per `AskUserQuestion` einholen. PFLICHT, nicht als Chat-Text aufzählen und auf Antwort warten. Question: *"Wie möchtest du den Design-Input geben?"*, Options: *Pfad A · Visuelle Referenzen* / *Pfad B · entscheide du* / *Pfad C · Hybrid*.**

   **Pfad A · Visuelle Referenzen (bevorzugt, beste Ergebnisse):** Der User liefert eine Mischung aus:
   - **2–3 Reference-Website-URLs**, die der Kunde liebt. `WebFetch` mit klarem Prompt nach Typo / Farbe / Layout-Prinzipien. Pinterest-Boards, Dribbble-Shots, Awwwards-Profile ebenfalls zulässig.
   - **Bilder oder Screenshots von Reference-Sites** lokal hochgeladen (zusätzlich Logo, Moodboard als `.png/.jpg/.webp/.svg`). Lade jedes Bild mit `Read` (multimodal), beschreibe was du siehst (Typo-Charakter, Farb-Stimmung, Layout-Prinzip, Spacing-Gefühl), spiegle das Verständnis zurück bevor du weitergehst.

   **Akkumulations-Loop — PFLICHT, nicht einmalig fragen:**

   Pfad A und Pfad C nutzen den gleichen Sammel-Loop. Nach jeder User-Antwort:
   1. Input verarbeiten (`WebFetch` für URLs, `Read` für Bilder) und in 2–3 Sätzen zurückspiegeln *was du verstanden hast* — Typo-Charakter, Farb-Stimmung, Layout-Gefühl
   2. Nachfragen: *"Noch weitere Refs? URLs, Screenshots, Logo, Farb-Hex, Schriftnamen, Moodboard, Brand-PDF?"*
   3. Loop bricht erst, wenn User explizit *"fertig"* / *"das wars"* / *"keine mehr"* sagt

   Auch wenn der User in einer Nachricht mehrere Refs nennt: trotzdem nach Verarbeitung **einmal** explizit fragen *"Noch was?"*. Kein stilles Weitergehen.

   **Pfad B · User sagt explizit *"entscheide du das Design"*:** Heuristik aus Phase 2 läuft mit Branche/Tonalität als einzigem Input. Skill bestätigt einmal kurz *"Okay, ich schlage 3 Direktionen vor — keine Referenzen, nur Heuristik nach Branche."* bevor er die Style-Picker-HTML schreibt. Output ist tendenziell generischer, der User akzeptiert das.

   **Pfad C · Hybrid:** Eine grobe Richtung in Worten (*"sollte editorial wirken, nicht zu Tech-mäßig"*) + Referenzen (URLs, Screenshots, eigene Assets). Gleicher Akkumulations-Loop wie Pfad A — User hat oft mehr Material als er initial nennt.

   **Immer abgefragt — unabhängig vom Pfad:**
   - **Brand-Name + USP in einem Satz** (sofern nicht aus `project.config.json` bekannt).
   - **Branche / Tonalität** (Edel-Luxus, B2B-Pragmatisch, Tech-Spielerisch, Editorial, Brutalist, Soft-Friendly) — Filter für die Direktions-Heuristik.
   - **Existierende Brand-Assets** (Logo-Datei, Brand-Guidelines-PDF, Farbe als Hex / OKLCH, Schriften namentlich). Wenn Logo da: per `Read` multimodal laden, dominante Farbe + Charakter ableiten und bestätigen.
   - **Stack für Token-Format** — aus `project.config.json` lesen.

   **Gate zu Phase 2:** Es darf nur dann ohne visuelle Refs weitergehen, wenn der User **explizit Pfad B gewählt** hat. Stille Annahme aus früheren *"mach du"*-Aussagen ist verboten.

2. **Style-Picker generieren — interaktive Wahl bevor DESIGN.md entsteht:**

   Auf Basis des Kontexts **3 distinkte Style-Direktionen** vorschlagen — klar polar, nicht 3× Variationen derselben Idee. Direktionen müssen jeweils eine konkrete Named Aesthetic tragen, nie "modern/clean/minimalistisch".

   **Direktions-Heuristik nach Branche/Tonalität** (Inspiration, nicht starr):
   - B2C-Lifestyle / Wellness / Therapie → Editorial Serif · Warm Monochrome · Soft Hand-Drawn
   - B2B-Tech / SaaS → Industrial Mono · Pragmatic Clean · Tech-Playful Geometric
   - E-Commerce / Fashion → Editorial Wide-Serif · Industrial Brutalist · Soft Neutral Premium
   - Banking / Finance → Editorial Conservative · Pragmatic Trust · Modern Neutral
   - Agentur / Portfolio → Editorial Bold · Industrial Brutalist · Maximalist Color

   **HTML-Mockup schreiben** unter `.launchgrade/mockups/style-picker.html` — **eine** Datei, **3 Sections gestapelt untereinander**, jede ~700–900 px hoch. Self-contained (alle Styles im `<head>`, keine externen Dependencies, keine Build-Tools).

   Pro Section enthalten:
   - **Header**: `Variante A · [Named Aesthetic]`
   - **Mini-Hero** im Stil der Variante: Eyebrow + Headline mit `{{BRAND_NAME}}` + Tagline-Lede + Primary-CTA + Secondary-CTA
   - **Typography-Specimen**: Heading-Font + Body-Font namentlich genannt, `AaBbCc 123 — &?` Sample in beiden, 1 echter Body-Satz
   - **Color-Palette**: 5–6 Swatches mit Hex-Werten (Primary, Primary-Dark, Neutral-Skala, Semantic)
   - **Anti-Slop-DNA**: 3 Bullets *"Was diese Variante ausmacht"* — z.B. "Wide leading", "Asymmetric hero", "Mono-weight only"

   Brand-Name + Tagline aus `project.config.json` lesen, sonst Platzhalter.

   **Im Browser öffnen** — Tool-Detection-Reihenfolge:
   1. `agent-browser open .launchgrade/mockups/style-picker.html`
   2. `mcp__claude-in-chrome__tabs_create_mcp` mit `file://` URL
   3. Fallback: User-Hinweis mit absolutem Pfad zum manuellen Öffnen

   **`.launchgrade/` muss in `.gitignore`** stehen — falls fehlt, ergänzen.

3. **Auswahl per `AskUserQuestion` einholen — PFLICHT, niemals als Chat-Text ausgeben und auf Antwort warten:**
   - Question: *"Welche Style-Direktion soll DESIGN.md festschreiben?"*
   - Options: *Variante A* · *Variante B* · *Variante C* · *Kombi (ich beschreibe selbst)*
   - Bei "Kombi" Nachfass-Question: *"Was kombinieren?"* (User antwortet z.B. "Typo aus B, Palette aus C, Hero-Layout aus A")
   - Wenn der UI-Picker im verwendeten Agenten (z.B. älterer Claude-Code-Build) nicht als Buttons rendert, ist das ein Client-Issue. Der Skill verwendet trotzdem `AskUserQuestion` — kein Fallback zu nummerierter Chat-Liste.

4. **DESIGN.md generieren** auf Basis der gewählten Variante (oder Kombi) — mit Pflicht-Sektionen:
   - **Brand-DNA**: 3–5 Adjektive die die Brand IST + 3–5 die sie NICHT ist
   - **Named Aesthetic Reference**: konkret, mit Aspekten — z.B. "Linear's perspective grid + Stripe's docs typography + Mr Porter's editorial spacing". Niemals "modern, clean, minimalistisch".
   - **Typography**: konkrete Schriften (NIEMALS Inter als Default), Type-Scale mit echten Werten, Pairings
   - **Color**: kalibrierte Palette in OKLCH, **nicht** Tailwind-Default-Slate. Primary, Secondary, 5-Step-Neutral, Semantic (success/warning/danger), explizite Kontrast-Paare gegen WCAG-Brüche
   - **Spacing & Layout**: Grid-System, asymmetrische Defaults statt 3-Col-Bento, Container-Queries als Default für komponenten-lokale Layouts
   - **Motion**: Micro-Interaction-Library (Fade, Slide, Spring-Easing-Werte), `prefers-reduced-motion`-Block dokumentiert
   - **Component-Prinzipien**: was darf Shadcn-Default sein, was wird gebrandet, was ist custom
   - **Anti-Patterns**: was diese Brand NIE macht — konkret, nicht abstrakt
   - **Reference-Mix**: 3–5 Sites mit konkreten Aspekten pro Site

5. **COPY.md generieren — Website-Texte strukturiert festhalten:**

   Design ohne Copy bleibt Lorem-Ipsum. COPY.md liegt parallel zu DESIGN.md im Projekt-Root und ist die **Single Source of Truth** für alle user-facing Texte. Beim Bauen jeder Page wird sie referenziert.

   **Pflicht-Sektionen in COPY.md:**
   - **Meta** — `<title>` (≤ 60 Zeichen), `<meta name="description">` (≤ 155 Zeichen), OG-Title, OG-Description
   - **Hero** — Eyebrow (optional), Headline (≤ 8 Wörter), Sub-Headline (1 Satz), Primary-CTA, Secondary-CTA
   - **Sections** — pro geplanter Section: Section-Headline, Lede, Bullets/Body, CTA falls vorhanden
   - **Social Proof** — Kunden-Logos, Testimonial-Quote(s) mit Autor+Rolle, Zahlen/Metriken
   - **FAQ** — 4–8 Q/A-Paare
   - **Footer** — Tagline, Adresse, Impressum-Link, Datenschutz-Link, Social-Handles
   - **Microcopy** — Form-Labels, Placeholder, Error-States, Success-States, Cookie-Banner-Text
   - **Voice & Tone** — 3 Bullets *"Wie schreibt diese Brand?"* (z.B. *"per Du, direkt, keine Buzzwords, kein 'Get Started'"*)

   **Input-Pfad — `AskUserQuestion` einholen, PFLICHT:**
   - Question: *"Wie kommen die Webseiten-Texte rein?"*
   - Options:
     - *User liefert Copy* — User pasted Texte oder verweist auf Dokument (`.docx`, `.pdf`, `.md`). Skill liest via `Read`, strukturiert in COPY.md.
     - *Skill schlägt vor* — Skill generiert Copy aus Brand-DNA + Tonalität + Branche. User reviewed sektionsweise.
     - *Platzhalter* — User will später schreiben, Skill setzt `{{HERO_HEADLINE}}` etc. als TODO-Tokens. Vor Audit-Gate werden ungefüllte Tokens gelistet und blockieren den Übergang.

   **Voice & Tone aus DESIGN.md ableiten** — wenn Brand-DNA "warm, persönlich" sagt, darf Copy nicht "Boost Your Workflow with AI-Powered Synergy" werden. Skill prüft Konsistenz.

6. **Live-Preview HTML rendern — User sieht das Resultat, nicht nur Markdown:**

   Nach DESIGN.md + COPY.md (oder zumindest DESIGN.md + Platzhalter-Copy) eine vollständige Demo-Page bauen unter `.launchgrade/mockups/design-preview.html`. Self-contained, alle Styles inline, keine Build-Tools.

   **Inhalt der Demo-Page:**
   - Hero (Headline + Sub + 2 CTAs) im finalen Stil mit echter Typo, echten Farben, echtem Spacing
   - 2–3 reale Sections (Features / Social Proof / FAQ je nach COPY.md)
   - Footer-Bar mit Brand-Name + Tagline

   Werte aus DESIGN.md (Tokens, Schriften, Farben) und COPY.md (Texte) ziehen — nicht improvisieren. Wenn DESIGN.md `font-family: "Söhne", system-ui` festlegt und Söhne nicht via CDN da ist, dokumentierter Fallback wird genutzt + ein Kommentar im HTML.

   **Im Browser öffnen** — Tool-Detection-Reihenfolge:
   1. `agent-browser open .launchgrade/mockups/design-preview.html`
   2. `mcp__claude-in-chrome__tabs_create_mcp` mit `file://` URL
   3. Fallback: absoluter Pfad zum manuellen Öffnen

7. **User-Approval-Loop — `AskUserQuestion`, PFLICHT:**

   Question: *"Passt das Design + die Copy?"*
   Options:
   - *Pass — weiter*
   - *Design anpassen* (Nachfass: welche Sektion? Typo, Color, Spacing, Motion, Component, …)
   - *Copy anpassen* (Nachfass: welche Sektion? Hero, Sections, FAQ, Microcopy, …)
   - *Beides anpassen*

   Bei Nicht-Pass: Änderung umsetzen (DESIGN.md und/oder COPY.md updaten, Preview neu rendern), Browser refreshen, **erneut fragen**. Loop bricht nur bei explizitem *Pass*.

   Maximal 5 Iterationen ohne User-Pause — danach selbst nachfassen *"Wir sind in Iteration 6 — sollen wir komplett umdenken oder hängt es an einem Detail?"*. Verhindert endlose Tweak-Schleifen.

8. **Visual-Diff-Loop einrichten:**
   - **Browser-Tool wählen** (Präferenz-Reihenfolge, erstes verfügbares Tool gewinnt — nicht hardcoden, andere Nutzer haben andere Setups):
     1. `agent-browser` CLI — `command -v agent-browser`
     2. Playwright MCP — wenn `mcp__playwright__*` Tools verfügbar
     3. Chrome MCP / `claude-in-chrome` — wenn `mcp__claude-in-chrome__*` Tools verfügbar
     4. Lokales Playwright via `npx playwright` — Fallback
   - Loop dokumentieren: AI generiert → Screenshot via gewähltem Tool → Vision-Diff gegen Reference/Figma → Code-Update → Wiederholen bis Diff unter Threshold
   - Optional: Figma MCP wenn Design im Figma liegt → Live-Token-Sync (Figma Variables ↔ CSS Variables)

9. **Defaults aktiv blocken** (im DESIGN.md → "Forbidden Defaults"):
   - Niemals Inter (außer explizit gewählt)
   - Niemals `gradient-to-br from-purple-500 to-pink-500` o.ä.
   - Niemals Shadcn-Components ohne Token-Override
   - Niemals Lucide-Icons im Hero ohne Begründung
   - Niemals 3-Col-Features-Grid mit Icon+Headline+2-Zeilen-Subline als Default-Hero-Sektion
   - Niemals Glass-Morphism ohne klares Design-Argument
   - Niemals "Get Started" als CTA-Default

10. **A11y-Constraints aus AGENTS.md §3 lesen** — Anti-Slop darf nie Kontrast / Focus-Indicator / Reduced-Motion / Target-Size brechen. Brand-Eigenwille hört bei WCAG-Bruch auf.

11. **Hard Gate vor Audit-Übergabe — `AskUserQuestion`, PFLICHT:**

    Letzter Skill-Step, kein automatischer Übergang zu `launchgrade-audit`. Vorher prüfen:
    - DESIGN.md existiert und ist nicht leer
    - COPY.md existiert; wenn Platzhalter-Tokens (`{{...}}`) noch drin sind, listen und User darauf hinweisen
    - Live-Preview wurde mindestens einmal vom User gesehen und mit *Pass* bestätigt

    Dann Question: *"Design + Copy final freigegeben — Übergabe an /launchgrade-audit?"*
    Options:
    - *Ja, Audit starten*
    - *Nein, eine Sektion nochmal* (zurück in Approval-Loop von Step 7)
    - *Komplett neue Direktion* (zurück in Step 1, Style-Picker neu)

    Bei *Ja* keinen Audit selbst auslösen — User triggert `/launchgrade-audit <URL>` manuell, sobald die Seite live oder im Staging erreichbar ist.

Standards-Lookup: `./web-standards/AGENTS.md` im Repo.

## Verhalten

- DESIGN.md und COPY.md liegen **im Projekt**, nicht zentral — pro Brand individuell, versioniert.
- Named References mit konkreten Aspekten — nie "modern und clean".
- Bei jedem Visual-Output: gegen DESIGN.md + COPY.md prüfen, nicht gegen Gefühl.
- Akkumulations-Loop, Approval-Loop, Hard Gate: alle drei nutzen `AskUserQuestion`, nie nummerierte Chat-Listen.
- Niemals stillschweigend zu `launchgrade-audit` weitergehen — Hard Gate ist Pflicht.
- Bei Konflikt Brand vs. A11y: A11y gewinnt (AGENTS.md §3).
- Auf Deutsch antworten, Tokens/Properties/Vokabular auf Englisch.
- Em-dashes in user-facing Copy sparsam — maximal einer pro längerem Absatz.

## Anti-Patterns

- ❌ Aus Setup-*"mach du"* lautlos eine Design-Vollmacht ableiten. Pfad B ist erlaubt — aber nur wenn der User ihn **für Design** explizit wählt.
- ❌ Aus Setup-Daten (Primary-Color für Manifest, Brand-Name) eine Brand-Palette oder Typography extrapolieren — das ist eine Design-Entscheidung, gehört in Phase 1+2 des Design-Skills mit User-Bestätigung.
- ❌ Refs in einer Runde abfragen und weitergehen — Akkumulations-Loop ist Pflicht (Pfad A und C). Genau dieser Schritt sammelt das Material, an dem der User später hängt.
- ❌ DESIGN.md generieren ohne COPY.md — Texte sind nicht "kommt später", sie prägen Layout-Entscheidungen (Headline-Länge, FAQ-Anzahl, CTA-Wording).
- ❌ Live-Preview überspringen *"weil DESIGN.md ja steht"* — User muss vor Audit visuell verifizieren, nicht nur Markdown lesen.
- ❌ Approval-Loop einsparen und stillschweigend zu Audit weitergehen — Hard Gate ist Pflicht.
- ❌ "Modern, clean, minimalistisch" als Brand-DNA — bedeutungsleer.
- ❌ Inter als Default-Font ohne Begründung.
- ❌ Tailwind-Slate-Palette ohne Brand-Override.
- ❌ Lucide-Icons im Hero ohne Brand-Argument.
- ❌ Linear-Perspective-Grid 1:1 kopieren statt inspirieren.
- ❌ Shadcn-Components ohne Token-Override.
- ❌ DESIGN.md weglassen "weil das eh im Prompt steht" — funktioniert nachweislich nicht.
- ❌ Copy als "Get Started" / "Boost Your Workflow" / "Unleash" — Voice & Tone aus DESIGN.md prüfen.
- ❌ Vision-Diff per "sieht okay aus" — verfügbares Browser-Tool (agent-browser / Playwright MCP / Chrome MCP) nutzen.
- ❌ Brand-Eigenwille über WCAG-Kontrast stellen.

## Übergabe

- Phase abgeschlossen erst nach **Hard Gate (Step 11)** mit explizitem User-*Pass*.
- DESIGN.md + COPY.md liegen im Projekt-Root, versioniert.
- Live-Preview unter `.launchgrade/mockups/design-preview.html` bleibt liegen — nützlich als visuelle Ground-Truth für spätere Component-Builds.
- Vor Release: **`launchgrade-audit`** für technischen Check (Lighthouse + Observatory + PSI). Der Skill löst den Audit nicht selbst aus — User triggert manuell sobald die Seite erreichbar ist.
- Design-Qualität bleibt manueller Check via DESIGN.md + COPY.md vs. Output — kein Tool ersetzt Designer-Auge.

## Aktualität

Anti-Slop-Patterns ändern sich mit dem Slop. Wenn 2026 Inter zum Klischee wurde, kann 2027 etwas anderes folgen. DESIGN.md ist living document — bei jedem neuen Projekt prüfen, ob die Defaults noch frisch sind.
