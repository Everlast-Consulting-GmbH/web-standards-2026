---
name: everlast-web-design
description: Anti-Slop Design-Layer für Web-Projekte. Generiert einen interaktiven Style-Picker mit 3 Style-Direktionen (HTML mit Cards untereinander, im Browser zur Wahl), schreibt DESIGN.md auf Basis der Wahl, definiert Named Aesthetic References, blockt AI-Default-Patterns (Inter, Lila-Pink-Gradient, Shadcn-Default, Rounded-XL-Bento, generische Lucide-Hero-Icons). Etabliert Visual-Diff-Loop mit dem im Projekt verfügbaren Browser-Tool (agent-browser / Playwright MCP / Chrome MCP). Triggert bei "Design", "Look", "Brand", "DESIGN.md", "Anti-Slop", "nicht generisch", "sieht generisch aus", "Style Guide".
---

# Everlast Web Design Skill

Zweite Phase im Everlast-Web-Workflow: **Build-Layer Anti-Slop**. Adressiert das Hauptproblem 2026 — AI-generierte Sites sehen alle gleich aus.

## Wann triggern

- Brand-DNA / Design-Sprache für ein neues Projekt definieren
- DESIGN.md erstellen, aktualisieren oder reviewen
- Visual-Iteration-Loop einrichten (Tool-agnostisch — agent-browser / Playwright MCP / Chrome MCP, je nach Projekt-Setup)
- Output wirkt generisch: "sieht aus wie jede AI-Site", "zu Vercel-mäßig", "Lila-Gradient raus", "Default-Slop"
- Refactor visueller Layer eines bestehenden Projekts
- Component-Library-Anbindung (Design-System via MCP statt Prompt-Injection)

Nicht triggern bei: technischen Setup-Fragen (→ `everlast-web-setup`), Audit/Pre-Launch (→ `everlast-web-audit`), rein logischen Code-Fragen.

## Das Grundproblem

LLMs samplen aus dem statistischen Zentrum ihrer Trainingsdaten. Resultat: Inter, Lila-Pink-Gradient, Bento-Grid mit Rounded-XL, Lucide-Icons im Hero, blauer "Get Started"-Button. Der Term **"AI Slop Web Design"** ist seit Q1 2026 etablierter Designer-Terminus. Anti-Slop ist 2026 Pflicht für jede ernsthafte Brand.

## Wirkende Formel (Konsens 2026)

`DESIGN.md (versioniert im Projekt) + Named Aesthetic + Reference-Mix + Explicit Anti-Patterns + Visual-Diff-Loop`

Naive Prompt-Injection einzelner Tokens funktioniert nicht — LLMs ignorieren sie unter Decoding-Druck. Was funktioniert:

1. **DESIGN.md liegt im Projekt** (nicht im System-Prompt), strukturiert mit klaren Sektionen
2. **Skill lädt sie gezielt** vor jedem Design-Task
3. **Visual-Loop verifiziert Output** statt nur Gefühl

## Vorgehen

1. **Kontext abfragen — expliziter Trennschritt zum Setup:**

   Design-Input ist eine **eigene Entscheidung**, nicht aus Setup-Antworten ableitbar. Wenn der User in der Setup-Phase *"mach du"* / *"entscheide du"* gesagt hat, bezog sich das auf **technische Defaults** (Stack, npm, App-Router). Das ist **nicht** automatisch eine Design-Vollmacht — bevor Phase 2 startet, einmal aktiv beim User nachfragen.

   **Drei Eingabe-Pfade — der User wählt:**

   **Pfad A · Visuelle Referenzen (bevorzugt, beste Ergebnisse):**
   - **Bilder lokal hochladen** (Logo, Moodboard, Screenshot von Reference-Sites, Figma-Export als `.png/.jpg/.webp/.svg`). Lade jedes Bild mit `Read` (multimodal), beschreibe was du siehst (Typo-Charakter, Farb-Stimmung, Layout-Prinzip, Spacing-Gefühl), spiegle das Verständnis zurück bevor du weitergehst.
   - **URLs**: 2–3 Reference-Sites die der Kunde liebt. `WebFetch` mit klarem Prompt nach Typo / Farbe / Layout-Prinzipien. Pinterest-Boards, Dribbble-Shots, Awwwards-Profile ebenfalls zulässig.
   - **Figma-Datei**: via Figma MCP wenn verfügbar (`mcp__figma__*`), sonst Export-Bild als Bild-Upload behandeln.

   **Pfad B · User sagt explizit *"entscheide du das Design"*:** Heuristik aus Phase 2 läuft mit Branche/Tonalität als einzigem Input. Skill bestätigt einmal kurz *"Okay, ich schlage 3 Direktionen vor — keine Referenzen, nur Heuristik nach Branche."* bevor er die Style-Picker-HTML schreibt. Output ist tendenziell generischer, der User akzeptiert das.

   **Pfad C · Hybrid:** Eine grobe Richtung in Worten (*"sollte editorial wirken, nicht zu Tech-mäßig"*) + 1 Referenz. Reicht oft für brauchbaren Style-Picker.

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

   **HTML-Mockup schreiben** unter `.everlast/mockups/style-picker.html` — **eine** Datei, **3 Sections gestapelt untereinander**, jede ~700–900 px hoch. Self-contained (alle Styles im `<head>`, keine externen Dependencies, keine Build-Tools).

   Pro Section enthalten:
   - **Header**: `Variante A · [Named Aesthetic]`
   - **Mini-Hero** im Stil der Variante: Eyebrow + Headline mit `{{BRAND_NAME}}` + Tagline-Lede + Primary-CTA + Secondary-CTA
   - **Typography-Specimen**: Heading-Font + Body-Font namentlich genannt, `AaBbCc 123 — &?` Sample in beiden, 1 echter Body-Satz
   - **Color-Palette**: 5–6 Swatches mit Hex-Werten (Primary, Primary-Dark, Neutral-Skala, Semantic)
   - **Anti-Slop-DNA**: 3 Bullets *"Was diese Variante ausmacht"* — z.B. "Wide leading", "Asymmetric hero", "Mono-weight only"

   Brand-Name + Tagline aus `project.config.json` lesen, sonst Platzhalter.

   **Im Browser öffnen** — Tool-Detection-Reihenfolge:
   1. `agent-browser open .everlast/mockups/style-picker.html`
   2. `mcp__claude-in-chrome__tabs_create_mcp` mit `file://` URL
   3. Fallback: User-Hinweis mit absolutem Pfad zum manuellen Öffnen

   **`.everlast/` muss in `.gitignore`** stehen — falls fehlt, ergänzen.

3. **Auswahl via AskUserQuestion einholen:**
   - Variante A · Variante B · Variante C
   - Plus Option: *"Kombi — ich beschreibe selbst"* (User nennt dann z.B. "Typo aus B, Palette aus C, Hero-Layout aus A")

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

5. **Visual-Diff-Loop einrichten:**
   - **Browser-Tool wählen** (Präferenz-Reihenfolge, erstes verfügbares Tool gewinnt — nicht hardcoden, andere Nutzer haben andere Setups):
     1. `agent-browser` CLI — `command -v agent-browser`
     2. Playwright MCP — wenn `mcp__playwright__*` Tools verfügbar
     3. Chrome MCP / `claude-in-chrome` — wenn `mcp__claude-in-chrome__*` Tools verfügbar
     4. Lokales Playwright via `npx playwright` — Fallback
   - Loop dokumentieren: AI generiert → Screenshot via gewähltem Tool → Vision-Diff gegen Reference/Figma → Code-Update → Wiederholen bis Diff unter Threshold
   - Optional: Figma MCP wenn Design im Figma liegt → Live-Token-Sync (Figma Variables ↔ CSS Variables)

6. **Defaults aktiv blocken** (im DESIGN.md → "Forbidden Defaults"):
   - Niemals Inter (außer explizit gewählt)
   - Niemals `gradient-to-br from-purple-500 to-pink-500` o.ä.
   - Niemals Shadcn-Components ohne Token-Override
   - Niemals Lucide-Icons im Hero ohne Begründung
   - Niemals 3-Col-Features-Grid mit Icon+Headline+2-Zeilen-Subline als Default-Hero-Sektion
   - Niemals Glass-Morphism ohne klares Design-Argument
   - Niemals "Get Started" als CTA-Default

7. **A11y-Constraints aus AGENTS.md §3 lesen** — Anti-Slop darf nie Kontrast / Focus-Indicator / Reduced-Motion / Target-Size brechen. Brand-Eigenwille hört bei WCAG-Bruch auf.

Standards-Lookup: `./web-standards/AGENTS.md` im Repo.

## Verhalten

- DESIGN.md liegt **im Projekt**, nicht zentral — pro Brand individuell, versioniert.
- Named References mit konkreten Aspekten — nie "modern und clean".
- Bei jedem Visual-Output: gegen DESIGN.md prüfen, nicht gegen Gefühl.
- Bei Konflikt Brand vs. A11y: A11y gewinnt (AGENTS.md §3).
- Auf Deutsch antworten, Tokens/Properties/Vokabular auf Englisch.
- Em-dashes in user-facing Copy sparsam — maximal einer pro längerem Absatz.

## Anti-Patterns

- ❌ Aus Setup-*"mach du"* lautlos eine Design-Vollmacht ableiten. Pfad B ist erlaubt — aber nur wenn der User ihn **für Design** explizit wählt.
- ❌ Aus Setup-Daten (Primary-Color für Manifest, Brand-Name) eine Brand-Palette oder Typography extrapolieren — das ist eine Design-Entscheidung, gehört in Phase 1+2 des Design-Skills mit User-Bestätigung.
- ❌ "Modern, clean, minimalistisch" als Brand-DNA — bedeutungsleer.
- ❌ Inter als Default-Font ohne Begründung.
- ❌ Tailwind-Slate-Palette ohne Brand-Override.
- ❌ Lucide-Icons im Hero ohne Brand-Argument.
- ❌ Linear-Perspective-Grid 1:1 kopieren statt inspirieren.
- ❌ Shadcn-Components ohne Token-Override.
- ❌ DESIGN.md weglassen "weil das eh im Prompt steht" — funktioniert nachweislich nicht.
- ❌ Vision-Diff per "sieht okay aus" — verfügbares Browser-Tool (agent-browser / Playwright MCP / Chrome MCP) nutzen.
- ❌ Brand-Eigenwille über WCAG-Kontrast stellen.

## Übergabe

- Wenn DESIGN.md steht und Visual-Loop läuft: Design-Phase abgeschlossen.
- Vor Release: **`everlast-web-audit`** für technischen Check (Lighthouse + Observatory + PSI).
- Design-Qualität bleibt manueller Check via DESIGN.md vs. Output — kein Tool ersetzt Designer-Auge.

## Aktualität

Anti-Slop-Patterns ändern sich mit dem Slop. Wenn 2026 Inter zum Klischee wurde, kann 2027 etwas anderes folgen. DESIGN.md ist living document — bei jedem neuen Projekt prüfen, ob die Defaults noch frisch sind.
