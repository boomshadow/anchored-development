---
title: "Link Color per Palette, and No Visited-Link Distinction"
description: "Adopted a per-theme link color for anchored-dev.org — a deepened sage in light mode, sage green in dark — resolved through a semantic token, because sage green reaches 6.9:1 against the dark background but only 2.1:1 against warm cream, far under the WCAG AA ratio for body-size text. Keeping one color across both themes was rejected because no single value in the palette is legible on both backgrounds, and darkening sage green globally was rejected because it would have degraded the dark palette and the syntax highlighting that shares the color. Visited-link styling is rejected rather than kept, because of the four contexts where links appear it reaches the prose by intent and the anchor self-links by accident while the navigation and footer suppress it, making the signal too erratic to read, and because a green-to-purple shift is carried by color alone along the axis red-green color vision deficiency loses first."
status: accepted
tags: [website, anchored-dev-org, accessibility, contrast, wcag, color-palette, links, visited-links, dark-mode, design-system]
---

# ADR-005: Link Color per Palette, and No Visited-Link Distinction

## Context

The site's palette is defined once and overridden as a block for dark mode (ADR-003). Most colors are simply given a second value there. Two were deliberately held constant on the grounds that they already worked against both backgrounds — dusty rose and sage green, the latter being the link color.

That premise turned out not to survive measurement. Against the warm cream background, sage green reaches a contrast ratio of roughly 2.1:1. WCAG AA asks for 4.5:1 for body-size text and 3:1 for large text and non-text interface elements, so link text in light mode cleared none of the applicable bars — it was the least legible text on the page, and the failure was worst for exactly the content the site exists to publish. Against the dark background the same color reaches roughly 6.9:1 and is entirely comfortable. Sage green was, in effect, chosen for a dark background and inherited by a light one.

A second question surfaced alongside it. A rule on `a:visited` recolored followed links to regal purple, and links appear on the site in four contexts: the specification prose, the navigation, the footer, and the self-links that wrap anchored headings and rules.

Its reach across those four was neither uniform nor deliberate. The navigation and the footer each carried a rule suppressing it, though the footer's was redundant — a plain class selector on the footer's links already outweighs a pseudo-class on the bare element. The self-links carried no such rule and lost the same comparison, so following an anchor recolored the heading text it wrapped: a defect rather than a design, invisible where a heading was already close to purple and obvious on a body-weight rule standing among prose. The distinction therefore reached the prose links it was meant for, plus a set of headings where it was simply a bug.

## Decision

### Link color resolves per palette through a semantic token

Links are drawn in a deepened sage in light mode and in sage green in dark mode, selected by a semantic token that the palette overrides alongside every other per-theme value. The light-mode color keeps the hue of sage green exactly and is carried down in lightness, so links read as the same color across themes rather than as two unrelated accents. Both values clear the WCAG AA ratio for body-size text against the background they appear on.

Sage green keeps its other roles untouched. Syntax highlighting uses it for strings and selectors inside code blocks, and code blocks hold a dark background in both themes by design (SPEC-001, Element Styling) — so in that context it is already on the background it suits.

### Legibility is a stated expectation, not an incidental property

SPEC-001 states the requirement rather than a verdict on it: text-carrying colors meet the AA ratio against whichever background is active, and colors that carry only ornament are held to the lower bar that ornament warrants.

Recording instead that a particular color *has* sufficient contrast on both backgrounds is rejected. A conclusion written into a spec is not re-derived by anyone who reads it, so an unmeasured one survives indefinitely: it is precisely such a conclusion that holds sage green across both palettes while it sits at 2.1:1 on cream. A stated requirement is checkable, and puts the burden on the next palette change to prove itself.

### Visited links are not distinguished

Links carry no visited state. Neither the `a:visited` rule nor the rules written to cancel it are retained.

The distinction is not required for accessibility — no WCAG success criterion asks for it. It is a usability convention, and a situational one: its value comes from orientation across link-dense, exploratory reading, where "have I already been down this path?" is a real question. This is a three-page site whose specification body carries a handful of external references. There is no maze to get lost in.

Three further considerations point the same way. The signal is unreliable by construction: of the four contexts where links appear it reaches one by intent and one by accident, and an indicator that fires in some places and not others teaches readers to disregard it everywhere. It was carried by color alone, shifting green to purple, which is the axis the most common form of color vision deficiency loses first, so for those readers it was largely absent regardless. And browsers deliberately restrict what `:visited` may change and report false values for it, so the mechanism is a degraded one to build on.

### Rejected: one link color for both themes

The simplest option, and the status quo. Rejected because no single value in the palette is legible against both backgrounds: anything dark enough for warm cream is close to invisible on aubergine-black, and the reverse. Per-theme resolution is what the palette architecture already does for every other color that needs it.

### Rejected: darkening sage green itself

Changing the palette value rather than adding a second one would have avoided a new color. Rejected because sage green is not only the link color — it carries strings and selectors in the syntax highlighting, and it is the dark-mode link color, both of which are correct as they stand. Darkening it globally would have fixed one context by degrading two.

### Rejected: keeping visited styling and recoloring it

A visited color with adequate contrast in both themes could have been chosen instead of removing the feature. Rejected because it addresses only the contrast objection and leaves the others standing — the signal would still appear in one context out of four, and would still be carried by color alone.

## Consequences

**Links are legible at body size in both themes.** In light mode that legibility depends on the deepened value; sage green alone does not reach the ratio there.

**The palette gains a light-mode-only color.** It has no dark counterpart, which is a deliberate asymmetry rather than an omission: dark mode hands links back to sage green. The colophon records this so the gap in the dark palette table does not read as an oversight.

**A reader cannot tell which links they have already followed.** This is the accepted cost. It is small at the site's current size and would grow if the site ever rendered the specifications and ADRs as a densely cross-linked corpus — that change in link density, not a change in taste, is what should reopen this decision.

**Hover carries the whole of per-link state**, being the only such state the site expresses. The hover underline is retained deliberately for that reason: it depends on neither color perception nor noticing a small ornament, which the pilcrow affordance (ADR-004) does.

**Introducing visited styling is not the one-line change it appears to be.** A bare `a:visited` rule outweighs the plain class selectors that style the navigation and the anchor self-links, so it reaches both along with the prose, and each needs a rule of its own to hold it off. Only the footer escapes, and by cascade order rather than by intent — a protection that lasts exactly as long as nobody moves the rule. Anyone proposing this should expect to write three rules rather than one, and should read this decision first.

## Related Artifacts

- [SPEC-001](../specs/SPEC-001-website.md) — Color Palette and Element Styling, which state the contrast expectation and the link treatment
- [ADR-003](ADR-003-dark-mode-approach.md) — the per-theme custom property override architecture this decision uses
- [ADR-004](ADR-004-rule-level-anchors.md) — the anchor self-links and the pilcrow affordance the hover underline backs up
- The site colophon — the authoritative record of the palette values, including the light-mode-only entry
