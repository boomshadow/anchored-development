---
title: "Dark Mode: Persisted Light/Dark Slider over CSS Custom Property Overrides"
description: "Adopted a header sun/moon slider that overrides the palette via a data-theme attribute on the root element, defaulting to the operating system preference and remembering the visitor's choice in localStorage so it survives reloads and navigation. The dark palette lives in a single :root[data-theme=dark] block of CSS custom property overrides, set before first paint by a small inline script (saved choice first, OS preference otherwise) so there is no flash. A session-only no-persistence approach was rejected because the theme reset on every page navigation. A system-only no-toggle approach, a third-party toggle component, the light-dark() function, Tailwind, and a browser end-to-end test suite were also rejected; the persistence invariant is instead enforced by a static build check."
status: accepted
tags: [website, dark-mode, css, color-palette, accessibility, theme-toggle, data-theme, javascript, prefers-color-scheme, localstorage, testing]
---

# ADR-003: Dark Mode — Persisted Light/Dark Slider over CSS Custom Property Overrides

## Context

The site's visual design (SPEC-001) uses a warm pastel palette inspired by *The Grand Budapest Hotel*. All nine palette colors are defined as CSS custom properties in `:root`, and every color reference in the stylesheet uses these variables.

Visitors want to choose light or dark themselves rather than being locked to whatever their operating system reports. A reader on a dark-mode OS may prefer the warm cream page for long-form reading, and vice versa. The OS preference is the right *default*, but it should not be the only option — and once a visitor makes a choice, it should stick as they move between pages.

Three constraints shape the decision:

1. **Stay minimal.** A theme toggle must not pull in a CSS framework, a build step, or a heavyweight third-party component. The site values simplicity and readability in its tooling.
2. **Preserve the aesthetic.** The warm, literary identity must carry into dark mode — the same hotel with the lights dimmed, not a cold inversion.
3. **Reading never requires JavaScript.** The site renders fully as static HTML and CSS (SPEC-001, Rendering Rules). Theme *switching* is an enhancement; the content must remain readable without JS.

## Decision

### Light/dark slider via a `data-theme` attribute

A sun/moon pill slider sits in the site header. `site/src/js/theme.js` (a small hand-rolled vanilla-JS script, no dependencies) toggles a `data-theme` attribute on the root `<html>` element. The stylesheet overrides the palette custom properties under a single `:root[data-theme="dark"]` block. `color-scheme` is set per theme (`light` on `:root`, `dark` on the dark block) so native UI controls match.

### Default follows the OS; the slider sets a remembered choice

An inline `<script>` in the `<head>` sets `data-theme` before first paint — using the visitor's saved choice if present, otherwise `prefers-color-scheme` — so the page renders in the right theme with no flash of the wrong colors. Moving the slider sets the visitor's choice, which is persisted (see Persisted choice). A `matchMedia` change listener keeps the page following live OS changes *until* the visitor makes an explicit choice; after that, the saved choice governs.

A `<meta name="color-scheme" content="light dark">` tag is also declared in the `<head>`. It advertises that the page supports both schemes so the browser renders native UI (scrollbars, form controls, default background) in the OS scheme during the brief moment before the stylesheet's per-theme `color-scheme` rule applies — avoiding a flash of light chrome for dark-OS visitors. Once CSS resolves, the per-theme `color-scheme` (set by `data-theme`) governs.

### Persisted choice

The visitor's choice is saved in `localStorage` under the key `theme` (`"light"` or `"dark"`). The inline head script reads it before first paint, so the chosen theme survives reloads and navigation between the site's pages (which are full page loads on this static site) and applies on return visits. Storage access is wrapped in `try`/`catch`, so if `localStorage` is unavailable (e.g. private-browsing restrictions) the toggle degrades gracefully to a session-only override rather than breaking.

Until the visitor makes a choice, no value is stored and the page follows the OS preference (including live changes). There is intentionally no in-UI control to return to "follow the OS" after a choice has been made; the binary slider has no third state, and clearing site data resets to the default. This is an accepted simplification (see Consequences).

### A single dark palette block

Because the inline head script resolves the active theme into the `data-theme` attribute, a separate `@media (prefers-color-scheme: dark)` block is unnecessary — the dark values live in exactly one place (`:root[data-theme="dark"]`), which is easier to maintain than parallel light and dark blocks. Semantic variables (`--code-bg`, `--code-text`, `--syntax-*`) still decouple code-block styling from the page palette so both can be tuned independently.

## Rejected: Session-only override (no persistence)

The toggle initially did *not* persist the choice: every page load re-derived the theme from the OS preference, and the slider overrode it only for the current page view. This was abandoned because the site's pages are full page loads, so the theme reset to the OS default on every navigation between Home, Getting Started, and Colophon — a visitor who switched to dark lost it the moment they clicked a nav link. The reset was confirmed annoying in practice. Persisting the choice is the small, contained fix.

The persistence is deliberately bounded: the saved choice wins over the OS preference once set, but the OS preference remains the default for first-time and storage-cleared visitors.

## Rejected: System-only, no toggle

Following `prefers-color-scheme` alone with no toggle — handled entirely in CSS with zero JavaScript — was the site's original approach. It was rejected because a visitor whose OS theme differs from what they want for reading had no recourse. The toggle costs a small hand-rolled script and a small CSS block, which is cheap enough to justify giving users control.

## Rejected: Third-party toggle component

A drop-in web component such as GoogleChromeLabs `<dark-mode-toggle>` does exactly this job. It was rejected because it adds a CDN dependency that — under this project's supply-chain policy — must be version-pinned, Subresource-Integrity-verified, and soak-window vetted, all for behavior that is a few dozen lines we can own outright. It also gives less direct control over styling the control to match the Grand Budapest aesthetic.

## Rejected: CSS `light-dark()` function

The `light-dark()` function allows defining both light and dark values inline: `--warm-cream: light-dark(#FAF3EB, #2A1F2D)`. It was rejected because:

- It requires rewriting every color property definition inline rather than keeping a clean override block. The `data-theme` approach leaves the `:root` palette untouched and groups all dark values in one place.
- It only accepts `<color>` values. The rgba tints used for blockquote and table backgrounds need the same override mechanism but aren't pure color values.
- It resolves against the *system* preference, so it cannot express a manual, persisted override without additional machinery — defeating the point of the slider.

## Rejected: Tailwind CSS `dark:` variants

Tailwind provides a `dark:` variant prefix. It was rejected because the site uses vanilla CSS with no build tooling for styles. Adding Tailwind would introduce a CSS framework, a build step, and a fundamentally different styling methodology to solve a problem a small custom-property block handles natively.

## Rejected: Separate dark stylesheet

A second stylesheet would keep dark styles in their own file but duplicates every non-color rule (layout, typography, spacing) or requires careful `@import` sharing. The custom-property override changes only values, not rules — the entire dark mode is a single `:root[data-theme="dark"]` block.

## Rejected: Browser end-to-end (E2E) test suite for the toggle

SPEC-001's Theme Toggle section describes runtime behaviors — the slider flips the theme, the page tracks live OS changes until the user chooses, the choice persists across navigation, and the slider icons reflect the active theme. Fully verifying these as behaviors (rather than as present mechanisms) would require a browser-automation suite such as Playwright that clicks the control and inspects the resulting DOM and storage state.

This was rejected as disproportionate. Adding a browser-automation framework — its dependency tree, downloaded browser binaries, CI wiring, and the supply-chain surface that all of that brings — is a large, ongoing cost to verify a small toggle on a three-page static site. It would also contradict the minimalism that motivated hand-rolling the toggle in the first place. The verification strategy below is the proportionate alternative.

## Consequences

- Visitors can flip between light and dark from the header slider; the default tracks the operating system until a choice is made, and the choice is then remembered.
- **The choice persists.** It is saved in `localStorage` and survives reloads, navigation between pages, and return visits. Once a choice is saved, the site stops following OS changes — the explicit choice wins. There is no in-UI way to return to "follow the OS" after choosing (the binary slider has no third state); clearing site data resets to the OS default. This is an accepted simplification; a three-state control could be added later if needed.
- **Dark mode requires JavaScript.** A visitor with JavaScript disabled gets the light theme regardless of their OS setting (previously the CSS media query gave them OS dark mode). This is an accepted trade-off: reading the site never required JavaScript and still does not — only theme selection does.
- **No flash of the wrong theme.** Because the inline head script resolves the saved choice (or OS preference) into `data-theme` before first paint, persistence does not reintroduce a flash. Storage access is guarded so a thrown `localStorage` does not break theming.
- **Verification strategy.** The toggle's behaviors are enforced proportionately rather than with browser automation:
  - *Persistence* is verified by an automated static check — the build smoke test asserts the theme code uses `localStorage`. This guards the load-bearing invariant (the choice is saved) against regression.
  - *Build-output presence* of the slider, the `[data-theme="dark"]` block, and the inline head script is verified by the smoke test.
  - *Interactive behaviors* (the slider flipping the theme, live OS tracking before a choice, persistence across navigation, and the icon reflecting the active state) are verified by manual verification and by drift detection on every change, which flags code that contradicts the documented behavior. A browser E2E suite was deliberately rejected (above) as disproportionate for this site.
- The dark palette is maintained in a single `:root[data-theme="dark"]` block. Code block and syntax highlighting colors remain decoupled via semantic variables.
- The slider is built as a styled checkbox with inline SVG icons — no icon font, no third-party JavaScript, no CDN.
- The colophon documents both palettes and the toggle so the design system remains self-describing.

## Related Artifacts

- [SPEC-001](../specs/SPEC-001-website.md) -- visual design system, the theme toggle, and rendering rules
- [ADR-002](ADR-002-website-technology-stack.md) -- technology stack (Eleventy, Cloudflare Pages)
