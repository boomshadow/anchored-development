---
title: "Website"
description: "Behavioral expectations for anchored-dev.org. Covers page structure (homepage rendering SPEC-000, getting-started guide, colophon), content sourcing without file duplication, visual design system (Grand Budapest Hotel aesthetic with warm pastels and aubergine tones, system-preference dark mode), typography (Playfair Display, Libre Baskerville, Jost), rendering rules (heading anchors, syntax highlighting, dark mode, responsive layout), and deployment via Cloudflare Pages."
status: accepted
tags: [website, anchored-dev-org, design-system, visual-identity, deployment, typography, color-palette, dark-mode]
---

# Website

anchored-dev.org is the public face of the Anchored Development framework. It renders the specification as a beautifully styled web page and provides companion content that explains the framework's purpose and value.

## Page Structure

The site has three pages:

**Homepage (`/`)** — Renders SPEC-000 as the primary content. The page opens with a hero section containing the site icon, the framework title, and a tagline. Below the hero, the full specification is rendered as styled prose. This is the page a visitor sees when they navigate to anchored-dev.org.

**Getting Started (`/getting-started/`)** — Adoption mechanics and structural guidance. Covers how to set up the framework in new projects and existing codebases, links to the example repository, and shows the minimal directory structure. This page exists for readers who are ready to adopt and want practical next steps.

**Colophon (`/colophon/`)** — A self-documenting artifact listing the site's design choices, color palette values, and tooling. Exists for transparency and fun.

All pages share a base layout with a consistent header, navigation, and footer.

## Content Sourcing

The homepage content is sourced from `docs/specs/SPEC-000-anchored-development.md` at build time. The file is read, its YAML frontmatter is stripped, and the markdown body is rendered to HTML. The spec file is never duplicated — the repository file is the single source of truth, rendered in two contexts (the repository and the website).

The Getting Started and Colophon pages are original content authored directly in the site source directory.

## Visual Design System

The site's visual identity is inspired by the aesthetic of Wes Anderson's *The Grand Budapest Hotel* — warm pastels, centered symmetry, ornamental borders, and literary typography. The design evokes a carefully composed storybook rather than a developer tool.

### Color Palette

The palette is warm, literary, and muted — aubergine ink, dusty rose accents, sage green links, lavender and pink gradients, all set against a warm cream background that feels like paper rather than a screen. The tones are drawn from the site's anchor icon, which uses lavender, dusty rose, and sage green with dark aubergine outlines in an ornamental art-deco frame.

The palette adapts to the user's operating system light/dark preference via `prefers-color-scheme`. In dark mode, the palette shifts to deep warm aubergine-black backgrounds with lightened text and accents — the same hotel with the lights dimmed, not a cold inversion. Colors that already have sufficient contrast against both backgrounds (dusty rose, sage green) remain unchanged.

Exact color values for both light and dark palettes are documented in the site's colophon, which serves as the authoritative reference for the technical palette.

### Typography

Three font families, each with a distinct role:

| Font | Role | Character |
|------|------|-----------|
| Playfair Display | Headings (h1–h6) | High-contrast transitional serif. Evokes engraved hotel signage. Centered, with letter-spacing. |
| Libre Baskerville | Body text | Optimized for web reading at 16px. Literary, refined, highly readable at long-form lengths. |
| Jost | Navigation, labels, meta text | Geometric sans-serif in the spirit of Futura — Wes Anderson's signature film font. Used for UI elements, small caps, and secondary text. |

### Layout Principles

**Centered symmetry.** All content is composed in a narrow reading column (maximum width approximately 720px). The overall impression is centered and deliberate — headings, the hero, and the column itself are visually centered on the page.

**Generous whitespace.** Large padding between sections, comfortable line-height, and wide margins. The content breathes.

**Ornamental double borders.** The hero section uses a double-line border treatment — an outer line, a gap, an inner line — echoing the art-deco frame in the site icon. This treatment may extend to other featured elements as the site evolves.

**Warm backgrounds.** The page background is warm cream, not white. White feels clinical; cream feels like hotel stationery. In dark mode, the background is warm aubergine-black, not cold blue-black — the same principle applied to the opposite end of the lightness scale.

### Hero Section

The homepage hero section uses a gradient background transitioning from lavender to Mendl's pink. It contains:

- The site icon (the anchor illustration)
- The framework title "Anchored Development" in uppercase Playfair Display with generous letter-spacing
- A tagline describing the framework

The hero content sits inside an ornamental double-border frame.

### Element Styling

**Tables** use alternating row backgrounds and subtle borders drawn from the palette. Header rows are visually distinct.

**Code blocks** use dark aubergine background with warm-tinted text. Syntax highlighting token colors harmonize with the palette: strings in sage green, keywords in dusty rose, comments in lavender. Code blocks maintain a dark background in both light and dark mode, using semantic variables that decouple their colors from the page palette.

**Blockquotes** have a left border in dusty rose, italic text, and indentation.

**Links** are sage green with underline on hover. Visited links use regal purple.

**Horizontal rules** are thin centered lines, styled as subtle dividers rather than bold separators.

**Lists** use custom markers in dusty rose.

## Rendering Rules

**Heading anchor links.** All h2 through h6 headings have anchor links for deep-linking. Visitors can link directly to any section of the specification.

**Syntax highlighting.** Code blocks are syntax-highlighted at build time. No client-side JavaScript is required for code highlighting.

**Links.** Markdown links are rendered as clickable HTML links. Bare URL auto-detection is intentionally disabled to prevent false positives (e.g., `.md` file references being misinterpreted as URLs).

**Responsive design.** The site is a single centered column on all viewport sizes. On mobile, navigation stacks vertically and font sizes adjust for readability. On desktop, the content column is constrained to approximately 720px.

**Dark mode.** The site adapts to the user's operating system color scheme preference via the `prefers-color-scheme` CSS media query. No JavaScript toggle is provided — the site follows the operating system setting. See [ADR-003](../decisions/ADR-003-dark-mode-approach.md) for the design decision.

**No client-side JavaScript required.** The site functions fully as static HTML and CSS. Any JavaScript is optional enhancement, not required for reading the specification. Dark mode is handled entirely in CSS.

## Deployment

The site is deployed to Cloudflare Pages via native GitLab integration. Cloudflare connects to the GitLab.com repository and builds automatically. The repository is push-mirrored to GitHub for public visibility; the website footer links to the GitHub mirror.

- **Production:** Deployed on every push to `main`.
- **Preview:** Feature branches receive preview deployments at unique Cloudflare-assigned URLs.
- **Custom domain:** anchored-dev.org.
- **Build tool:** Eleventy v3 (see ADR-002 for the technology decision).
- **Build output:** `site/_site/`.

## Related Artifacts

- [ADR-002](../decisions/ADR-002-website-technology-stack.md) — technology stack decision (Eleventy, Cloudflare Pages)
- [ADR-003](../decisions/ADR-003-dark-mode-approach.md) — dark mode approach (CSS custom property overrides via prefers-color-scheme)
- [SPEC-000](SPEC-000-anchored-development.md) — the specification rendered as the homepage content
- [ADR-001](../decisions/ADR-001-licensing.md) — site content is licensed under CC BY-SA 4.0
- Build smoke tests in `test/` verify that all three pages and the stylesheet are produced by the build (Page Structure, Deployment) and verify heading anchor links, build-time syntax highlighting, linkify being disabled, and dark mode support (Rendering Rules)
