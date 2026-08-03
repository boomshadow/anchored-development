---
layout: page.njk
title: Colophon
description: Design choices, tools, and credits behind the Anchored Development website.
---

## Regarding This Publication

This website publishes the [Anchored Development](/), a framework for living documentation in AI-assisted software development. The specification lives in the project repository as a markdown file; the site renders it directly at build time.

## On the Matter of Aesthetics

The visual identity is inspired by Wes Anderson's *The Grand Budapest Hotel* — warm pastels, centered symmetry, ornamental borders, and literary typography. The goal is a site that feels like a carefully composed storybook rather than a developer tool.

### Color Palette

| Color | Hex | Role |
| ----- | --- | ---- |
| Warm Cream | `#FAF3EB` | Page background |
| Dark Aubergine | `#4A2E4A` | Body text, borders |
| Medium Aubergine | `#5C3A5C` | Headings |
| Dusty Rose | `#D4909A` | Accents, list markers, blockquote borders, anchor pilcrow |
| Lavender | `#B8B0D2` | Hero gradient, secondary backgrounds |
| Sage Green | `#8BB5A2` | Code block strings and selectors |
| Deep Sage | `#416D59` | Links, focus outline |
| Pale Mauve | `#E8D0D9` | Dividers, table alternating rows |
| Mendl's Pink | `#F6C4D2` | Hero gradient endpoint |
| Regal Purple | `#75638B` | Subheadings |

### Dark Palette

The site defaults to the visitor's operating system light/dark preference, and a sun/moon slider in the header lets you switch themes by hand. Your choice is remembered as you move around the site and on return visits; until you pick one, the page follows your system setting. The dark palette is the same hotel with the lights dimmed: deep warm aubergine-black, not cold blue-black.

| Color | Hex | Role |
| ----- | --- | ---- |
| Warm Cream | `#2A1F2D` | Page background (deep aubergine-black) |
| Dark Aubergine | `#E8D5E0` | Body text (warm pink-cream) |
| Medium Aubergine | `#D4B8D4` | Headings (light mauve) |
| Dusty Rose | `#D4909A` | Accents, anchor pilcrow (unchanged) |
| Lavender | `#4A3F5C` | Hero gradient, secondary backgrounds (deep muted purple) |
| Sage Green | `#8BB5A2` | Links, code block strings and selectors, focus outline (same hex as light) |
| Pale Mauve | `#3D2F3D` | Dividers, table alternating rows (dark mauve) |
| Mendl's Pink | `#5C3A4A` | Hero gradient endpoint (deep muted rose) |
| Regal Purple | `#B8A8D0` | Subheadings (lightened purple) |

Deep sage has no dark counterpart, and neither links nor the focus outline need one here. It exists because sage green is a dark-background color — lovely against aubergine-black, far too pale against warm cream to read comfortably at body size. Dark mode hands links back to sage green, which is the background it was chosen for.

Code blocks maintain a dark background in both modes, using separate tokens that are tuned independently from the page palette:

| Token | Light | Dark | Role |
| ----- | ----- | ---- | ---- |
| Code background | `#4A2E4A` | `#1A1220` | Code block background |
| Code text | `#FAF3EB` | `#E8D5E0` | Code block text |
| Comments | `#B8B0D2` | `#9990B8` | Syntax: comments, prolog |
| Punctuation | `#E8D0D9` | `#B8A0B0` | Syntax: punctuation |
| Operators | `#F6C4D2` | `#E8A0B8` | Syntax: operators, URLs |
| Functions | `#E8C87A` | `#E8C87A` | Syntax: functions, class names (unchanged) |

### Typography

**Playfair Display** for headings — a high-contrast transitional serif that evokes engraved hotel signage.

**Libre Baskerville** for body text — optimized for web reading, literary and refined.

**Jost** for navigation and labels — a geometric sans-serif in the spirit of Futura, Wes Anderson's signature film font.

All fonts served via Google Fonts.

## Instruments and Accomplices

**Eleventy (Build Awesome) v3** generates the site from markdown and Nunjucks templates. A custom shortcode reads the framework specification from its canonical location in the repository, strips the YAML frontmatter, and renders it through the same markdown-it pipeline as the rest of the site. The spec file is never duplicated. The site uses one small piece of hand-written client-side JavaScript — about a dozen lines that drive the theme slider; everything else is static HTML and CSS, and the content reads fine with JavaScript disabled. Themes are handled through CSS custom properties, overridden via a `data-theme` attribute on the page.

**Cloudflare Pages** hosts the site and deploys automatically on every push to `main`. Preview deployments are created for feature branches.

The anchor icon was designed using AI image generation tools and refined by hand.

The specification, the site, and the framework's tooling were written in collaboration with **Claude**, Anthropic's AI assistant — the author's accomplice in this endeavor.
