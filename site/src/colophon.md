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
| Dusty Rose | `#D4909A` | Accents, list markers, blockquote borders |
| Lavender | `#B8B0D2` | Hero gradient, secondary backgrounds |
| Sage Green | `#8BB5A2` | Links |
| Pale Mauve | `#E8D0D9` | Dividers, table alternating rows |
| Mendl's Pink | `#F6C4D2` | Hero gradient endpoint |
| Regal Purple | `#75638B` | Subheadings, visited links |

### Dark Palette

The site adapts to the visitor's operating system light/dark preference using the `prefers-color-scheme` media query — no JavaScript, no toggle. The dark palette is the same hotel with the lights dimmed: deep warm aubergine-black, not cold blue-black.

| Color | Hex | Role |
| ----- | --- | ---- |
| Warm Cream | `#2A1F2D` | Page background (deep aubergine-black) |
| Dark Aubergine | `#E8D5E0` | Body text (warm pink-cream) |
| Medium Aubergine | `#D4B8D4` | Headings (light mauve) |
| Dusty Rose | `#D4909A` | Accents (unchanged) |
| Lavender | `#4A3F5C` | Hero gradient, secondary backgrounds (deep muted purple) |
| Sage Green | `#8BB5A2` | Links (unchanged) |
| Pale Mauve | `#3D2F3D` | Dividers, table alternating rows (dark mauve) |
| Mendl's Pink | `#5C3A4A` | Hero gradient endpoint (deep muted rose) |
| Regal Purple | `#B8A8D0` | Subheadings, visited links (lightened purple) |

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

**Eleventy (Build Awesome) v3** generates the site from markdown and Nunjucks templates. A custom shortcode reads the framework specification from its canonical location in the repository, strips the YAML frontmatter, and renders it through the same markdown-it pipeline as the rest of the site. The spec file is never duplicated. The site uses no client-side JavaScript — everything is static HTML and CSS. Dark mode is handled entirely through CSS custom properties and the `prefers-color-scheme` media query.

**Cloudflare Pages** hosts the site and deploys automatically on every push to `main`. Preview deployments are created for feature branches.

The anchor icon was designed using AI image generation tools and refined by hand.

The specification, the site, and the framework's tooling were written in collaboration with **Claude**, Anthropic's AI assistant — the author's accomplice in this endeavor.
