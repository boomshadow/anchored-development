---
title: "Website"
description: "Behavioral expectations for anchored-dev.org. Covers page structure (homepage rendering SPEC-000, getting-started guide, colophon), content sourcing without file duplication, visual design system (Grand Budapest Hotel aesthetic with warm pastels and aubergine tones, a header light/dark theme slider that defaults to the operating system preference and remembers the visitor's choice), typography (Playfair Display, Libre Baskerville, Jost), link treatment (green in both palettes, deepened for light mode to meet WCAG AA contrast, with no visited-link distinction), rendering rules (heading anchors, rule-level anchors making each numbered principle individually deep-linkable, a pilcrow hover affordance on anchors, syntax highlighting, dark mode and theme toggle, responsive layout), and deployment via Cloudflare Pages."
status: accepted
tags: [website, anchored-dev-org, design-system, visual-identity, deployment, typography, color-palette, dark-mode, theme-toggle, deep-linking, anchors, pilcrow, accessibility, contrast, wcag, links]
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

The palette is warm, literary, and muted — aubergine ink, dusty rose accents, green links, lavender and pink gradients, all set against a warm cream background that feels like paper rather than a screen. The tones are drawn from the site's anchor icon, which uses lavender, dusty rose, and sage green with dark aubergine outlines in an ornamental art-deco frame.

The site has both a light and a dark palette. By default the active palette follows the visitor's operating system light/dark preference; a header theme slider lets the visitor override it, and the choice is remembered (see Theme Toggle). In dark mode, the palette shifts to deep warm aubergine-black backgrounds with lightened text and accents — the same hotel with the lights dimmed, not a cold inversion. A few colors hold the same value in both palettes rather than being overridden — dusty rose and sage green among them.

Holding a value across both palettes is not the same as being legible in both. Text-carrying colors are expected to meet the WCAG AA contrast ratio for body-size text against whichever background is active. Sage green clears that bar comfortably against the dark background and falls well short of it against warm cream, so light mode draws links in a deepened sage of the same hue instead — the link reads as one color across themes while staying legible in each. Colors that carry meaning without carrying text — the outline that shows a keyboard visitor which control they are on, and anything else that communicates interface state — are expected to meet the lower WCAG ratio that applies to non-text elements. Purely decorative colors, such as the dusty rose used for ornament and list markers, carry no such obligation: nothing is lost if they go unnoticed.

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

**Links** are green in both palettes — deep sage in light mode, sage green in dark — and underline on hover. They are not distinguished by whether they have been visited (see [ADR-005](../decisions/ADR-005-link-color-and-state.md)). Anchor self-links are the exception to the color, not the underline: a heading or rule that links to itself keeps the color of the text around it, so a run of principles does not read as a run of links. It still underlines on hover, which is the affordance that does not depend on seeing the pilcrow.

**The anchor pilcrow** is dusty rose, which holds the same value in both palettes. It sits just outside the text it anchors, scaled to that text's size and aligned with it, so it reads as a companion mark at every heading level rather than a fixed-size interface glyph, and it is drawn in the body face at every level rather than taking on the surrounding heading's letterform. It is ornament: faint by design, and never the only thing marking an anchor. See Rendering Rules for when it appears.

**Horizontal rules** are thin centered lines, styled as subtle dividers rather than bold separators.

**Lists** use custom markers in dusty rose.

### Theme Toggle

The site header contains a sun/moon slider control that switches the page between the light and dark palettes. Its behavior:

- **Default follows the operating system.** Until the visitor makes a choice, the active theme is set from their `prefers-color-scheme` setting, before first paint, so there is no flash of the wrong theme. While no choice has been made, the page also follows live changes to the OS preference.
- **The slider switches the theme.** Moving the slider switches the page to light or dark.
- **The choice is remembered.** Once the visitor picks a theme it is saved and persists across reloads, navigation between pages, and return visits. After a choice is made, the saved theme governs rather than the OS preference. There is no in-UI control to return to following the OS (clearing site data resets to the default).
- The slider reflects the active theme: the sun side is highlighted in light mode, the moon side in dark mode.

See [ADR-003](../decisions/ADR-003-dark-mode-approach.md) for the rationale, rejected alternatives (including a session-only approach and a third-party component), and the verification strategy for these behaviors. The persistence guarantee is enforced by an automated check; the interactive behaviors are verified by manual verification and drift detection rather than a browser test suite.

## Rendering Rules

**Heading anchor links.** All h2 through h6 headings have anchor links for deep-linking. Visitors can link directly to any section of the specification.

**Rule-level anchor links.** Each numbered principle in SPEC-000 is individually deep-linkable, so a visitor can cite a single rule rather than the section containing it. The anchors are keyed to the principle's number, not its wording, so they survive a rule being reworded. These anchors are added by the site's rendering pipeline; the specification source is not modified to create them, which means they exist on the website only and not in a repository host's rendering of the raw markdown. See [ADR-004](../decisions/ADR-004-rule-level-anchors.md) for the rationale and rejected alternatives.

**Anchor hover affordance.** Anchor links — both heading and rule-level — underline on hover and reveal a pilcrow marker beside the text, so a visitor can discover that the text is a deep link. The underline is the affordance that carries the meaning and the pilcrow accompanies it, not the reverse. Keyboard focus reveals the marker on any device; hovering reveals it wherever the device actually supports hovering, so a tap cannot leave it stuck on. It never displaces the text it accompanies, and on touch devices the anchor text itself remains tappable, so no capability is lost. The build check verifies that both triggers exist; that the keyboard one is not itself conditioned on pointer support is confirmed by manual verification and drift detection rather than by the build.

**Syntax highlighting.** Code blocks are syntax-highlighted at build time. No client-side JavaScript is required for code highlighting.

**Links.** Markdown links are rendered as clickable HTML links. Bare URL auto-detection is intentionally disabled to prevent false positives (e.g., `.md` file references being misinterpreted as URLs).

**Responsive design.** The site is a single centered column on all viewport sizes. On mobile, navigation stacks vertically and font sizes adjust for readability. On desktop, the content column is constrained to approximately 720px.

**Dark mode.** The active palette defaults to the user's operating system color scheme and can be overridden with the header theme slider (see Theme Toggle). The theme is applied by setting a `data-theme` attribute on the root element; the dark palette is a single block of CSS custom property overrides. A small inline script sets the initial theme from `prefers-color-scheme` before first paint. See [ADR-003](../decisions/ADR-003-dark-mode-approach.md) for the design decision.

**Reading does not require client-side JavaScript.** The site's content renders fully as static HTML and CSS; the specification is completely readable with JavaScript disabled. The theme toggle is a JavaScript enhancement — with JavaScript disabled, the site displays in the light palette regardless of the OS preference.

## Deployment

The site is deployed to Cloudflare Pages via native GitLab integration. Cloudflare connects to the GitLab.com repository and builds automatically. The repository is push-mirrored to GitHub for public visibility; the website footer links to the GitHub mirror.

- **Production:** Deployed on every push to `main`.
- **Preview:** Feature branches receive preview deployments at unique Cloudflare-assigned URLs.
- **Custom domain:** anchored-dev.org.
- **Build tool:** Eleventy v3 (see ADR-002 for the technology decision).
- **Build output:** `site/_site/`.

## Related Artifacts

- [ADR-002](../decisions/ADR-002-website-technology-stack.md) — technology stack decision (Eleventy, Cloudflare Pages)
- [ADR-003](../decisions/ADR-003-dark-mode-approach.md) — dark mode approach (persisted light/dark slider over CSS custom property overrides, defaulting to the OS preference and remembering the choice)
- [ADR-004](../decisions/ADR-004-rule-level-anchors.md) — rule-level anchors added by the rendering pipeline rather than by promoting the principles to headings in SPEC-000
- [ADR-005](../decisions/ADR-005-link-color-and-state.md) — per-palette link color for contrast, and the removal of visited-link styling
- [SPEC-000](SPEC-000-anchored-development.md) — the specification rendered as the homepage content
- [ADR-001](../decisions/ADR-001-licensing.md) — site content is licensed under CC BY-SA 4.0
- Build smoke tests in `test/` verify the built site: all three pages, the stylesheet, and the theme script are produced (Page Structure, Deployment), and heading anchor links, rule-level principle anchors (the full set, compared as a contiguous sequence against the numbered rules counted in SPEC-000 itself, together with their self-links, so neither a skipped rule nor a lost link can pass unnoticed), the anchor pilcrow hover affordance and its pointer-device gate, the link and focus treatment (both color tokens resolving per theme, and the absence of visited styling), build-time syntax highlighting, disabled linkify, dark-mode support, the header theme slider, no-flash theming before first paint, and the persistence contract (the theme choice is saved to web storage) are present (Rendering Rules, Theme Toggle)
