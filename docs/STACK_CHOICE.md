# Stack-Entscheidung

Welcher Stack passt zu welchem Projekt-Typ? Default-Empfehlungen für Everlast.

## Entscheidungsmatrix

| Projekt-Typ                        | Default              | Alternativen                      | Begründung                                               |
| ---------------------------------- | -------------------- | --------------------------------- | -------------------------------------------------------- |
| **Marketing-Site / Landing Page**  | **Astro**            | Next.js, plain HTML               | Schnell, statisch, gute SEO, minimaler JS-Footprint      |
| **Blog / Magazin**                 | **Astro**            | Hugo, WordPress, Ghost            | Content-Collections, MDX, Build-Time-RSS                 |
| **Online-Shop (klein/mittel)**     | **Shopify**          | Medusa (custom), WooCommerce      | Out-of-Box BFSG-Hürde leichter, geringer Wartungsaufwand |
| **Online-Shop (custom, headless)** | **Next.js + Medusa** | Astro + Snipcart, Remix + Shopify | Wenn Logik-Custom oder Brand-Custom-Heavy                |
| **Buchungssystem**                 | **Next.js**          | Nuxt, SvelteKit                   | App-Charakter, viel State, Auth, BFSG-relevant           |
| **SaaS-Marketing-Frontend**        | **Next.js**          | Astro mit React-Islands           | Branding + Konversion + manchmal Demo-Login              |
| **Corporate Site (vielsprachig)**  | **Astro mit i18n**   | Next.js App Router, SvelteKit     | Statisch + hreflang + niedrige Latenz                    |
| **Dokumentation**                  | **Astro Starlight**  | Mintlify, Docusaurus              | OSS-Standard 2026, eigene Domain-Kontrolle               |

## Faustregeln

- **Statisch wo möglich** — Astro, plain HTML, oder Next.js mit `output: 'export'`
- **App nur wo nötig** — Auth, dynamische Daten, Personalization
- **WordPress nur wenn**: Kunde besteht darauf oder Redaktion arbeitet schon damit
- **Bei BFSG-Relevanz** (Shops, Banking, Buchung): zusätzlich `@axe-core/cli` im CI, manueller Screen-Reader-Test, BITV-Test bei größeren Vorhaben

## Was IMMER gleich bleibt (stack-agnostisch)

Egal welcher Stack — diese Pflicht-Artefakte gibt es:

- `/robots.txt` mit AI-Crawler-Defaults
- `/sitemap.xml`
- `/llms.txt`
- `/.well-known/security.txt`
- `/site.webmanifest`
- Favicon-Set
- `/404.html`, `/500.html`
- CSP Level 3 mit Nonce
- HSTS, X-Frame-Options, Referrer-Policy, Permissions-Policy
- JSON-LD Organization + WebSite

Generiert durch `everlast-web-setup` Skill nach dem Init.

## Hosting-Defaults

| Stack     | Default-Hosting                             |
| --------- | ------------------------------------------- |
| Astro     | Cloudflare Pages, Vercel, Netlify           |
| Next.js   | Vercel (oder selfhosted, Hetzner + Coolify) |
| WordPress | Cloudways, Raidboxes                        |
| Shopify   | Shopify (Hosted)                            |

Vercel-Default: liefert TLS, HTTP/3, edge-cached Headers — Observatory A+ ist mit wenig Config erreichbar.
