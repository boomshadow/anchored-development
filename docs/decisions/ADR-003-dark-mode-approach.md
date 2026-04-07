---
title: "Dark Mode: CSS Custom Property Overrides via prefers-color-scheme"
description: "Adopted @media (prefers-color-scheme: dark) with CSS custom property overrides for automatic dark mode that follows the user's operating system setting. No JavaScript is required. The light-dark() CSS function was rejected because it requires rewriting every color declaration inline and provides less clear separation of light and dark definitions. Tailwind CSS was rejected as overkill for a vanilla CSS project. A JavaScript toggle was rejected to preserve the site's zero-JS architecture. A separate dark stylesheet was rejected to avoid duplicating non-color rules."
status: accepted
tags: [website, dark-mode, css, color-palette, accessibility, prefers-color-scheme]
---

# ADR-003: Dark Mode — CSS Custom Property Overrides via prefers-color-scheme

## Context

The site's visual design (SPEC-001) uses a warm pastel palette inspired by *The Grand Budapest Hotel*. All nine palette colors are defined as CSS custom properties in `:root`, and every color reference in the stylesheet uses these variables. The site has no client-side JavaScript — everything is static HTML and CSS.

Users on dark-mode operating systems see a bright cream page regardless of their system preference. Modern browsers expose the user's preference through the `prefers-color-scheme` media query, which can be handled entirely in CSS.

Two constraints shape the decision:

1. **No JavaScript.** The site's zero-JS architecture (SPEC-001, Rendering Rules) is a deliberate design choice, not an accident. Dark mode must not introduce a JavaScript dependency.
2. **Preserve the aesthetic.** The warm, literary identity must carry into dark mode. The dark palette should feel like the same hotel with the lights dimmed — not a cold, clinical inversion.

## Decision

### System-preference dark mode via CSS custom property overrides

A `@media (prefers-color-scheme: dark)` block overrides the palette custom properties in `:root` with dark-mode values. The browser detects the user's OS-level light/dark preference and applies the appropriate palette automatically.

Additionally, `color-scheme: light dark` is declared on `:root` in CSS and as a `<meta name="color-scheme">` tag in the HTML `<head>`. This tells the browser to adapt native UI controls (scrollbars, form inputs, selection highlights) to match the active color scheme. The `<meta>` tag applies before the stylesheet loads, preventing a flash of light-mode chrome.

### Semantic variables for code blocks and syntax highlighting

Code blocks use a dark background in both light and dark mode. When the palette inverts (cream becomes dark, aubergine becomes light), code blocks would incorrectly become light-on-dark-page. Semantic variables (`--code-bg`, `--code-text`, `--syntax-function`, `--syntax-comment`, `--syntax-punctuation`, `--syntax-operator`) decouple code block styling from the page palette so both can be tuned independently.

### No toggle

The site follows the operating system setting. There is no manual toggle. For a documentation site with no user accounts or session state, this is the right tradeoff — it works correctly for the vast majority of users and avoids introducing JavaScript, `localStorage`, or UI chrome for a toggle button.

## Rejected: CSS light-dark() function

The `light-dark()` function (baseline since May 2024) allows defining both light and dark values inline: `--warm-cream: light-dark(#FAF3EB, #2A1F2D)`. This is elegant for simple cases.

It was rejected because:

- It requires rewriting every color property definition inline rather than keeping a clean override block. The media query approach leaves the existing `:root` palette untouched and groups all dark values in one place.
- It only accepts `<color>` values. The rgba tints used for blockquote and table backgrounds need the same override mechanism but aren't pure color values in the semantic sense.
- The media query approach is more established and familiar, which matters for a project that values simplicity and readability in its tooling.

## Rejected: Tailwind CSS dark: variants

Tailwind provides a `dark:` variant prefix that applies styles when `prefers-color-scheme: dark` is active. This is powerful for large applications with utility-class-driven styling.

It was rejected because the site uses vanilla CSS with no build tooling for styles. Adding Tailwind would introduce a CSS framework, a build step, and a fundamentally different styling methodology — all to solve a problem that a 25-line media query handles natively.

## Rejected: JavaScript toggle with localStorage

A toggle button that sets a `data-theme` attribute on `<html>` and persists the choice in `localStorage` is the standard approach for sites that want both system-preference detection and manual override.

It was rejected because the site has no JavaScript. Introducing JS solely for a theme toggle contradicts the architectural identity described in SPEC-001. The benefit (manual override for users whose site preference differs from their OS preference) does not justify the cost for a documentation site.

## Rejected: Separate dark stylesheet

A second stylesheet loaded via `<link media="(prefers-color-scheme: dark)" href="/css/dark.css">` would keep dark styles in their own file. However, this duplicates every non-color rule (layout, typography, spacing) or requires careful use of `@import` to share them. The custom property override approach changes only the values, not the rules — the entire dark mode is a single `:root` block inside a media query.

## Consequences

- Dark mode is automatic, zero-maintenance, and requires no user interaction. The site renders correctly for both light-mode and dark-mode users without any configuration.
- Users who want light mode on a dark-mode OS (or vice versa) cannot override the site's behavior. This is an acceptable tradeoff for a documentation site with no toggle.
- The dark palette must be maintained alongside the light palette. Both are defined in the same CSS file, grouped at the top, making them easy to find and update together.
- The colophon documents both palettes so the design system remains self-describing.
- Code block and syntax highlighting colors are decoupled from the page palette via semantic variables, adding modest complexity to the custom property layer.

## Related Artifacts

- [SPEC-001](../specs/SPEC-001-website.md) -- visual design system and rendering rules
- [ADR-002](ADR-002-website-technology-stack.md) -- technology stack (Eleventy, no JS requirement)
