---
title: "Rule-Level Anchors Added by the Rendering Pipeline"
description: "Adopted render-time anchors that give each numbered principle in SPEC-000 a stable number-keyed link target on anchored-dev.org, added by the site's markdown pipeline so the specification source is never modified. Promoting the eleven rules to headings inside SPEC-000 was rejected because it would make every anchor change a versioned release of the standard and would distort the document's heading hierarchy; hand-written inline anchor targets in the markdown were rejected as unenforceable hand-maintained state. The accepted tradeoff is that rule-level anchors exist on the website only, not in a repository host's rendering of the raw markdown."
status: accepted
tags: [website, anchored-dev-org, deep-linking, anchors, markdown, rendering, spec-000, versioning, navigation]
---

# ADR-004: Rule-Level Anchors Added by the Rendering Pipeline

## Context

SPEC-000 states eleven numbered principles. They are the most-cited content in the framework — in review comments, in issues, in conversation — and citing one usually means naming it in prose ("principle 7") because there is no way to link to it.

The website already deep-links every h2 through h6 heading (SPEC-001, Rendering Rules). The principles are excluded from that because of how they are written: each is a bold paragraph, not a heading. The anchor plugin only ever sees headings, so it never reaches them. The practical result is that a reader can link to the section that contains a rule but not to the rule itself.

Two constraints shape the fix:

1. **SPEC-000 is a versioned standard.** It carries a `version` field, and any change to it is a release requiring a version bump and a matching changelog entry, enforced in CI. This is a deliberately high bar, and it applies to the file regardless of how small the edit is.
2. **The specification is rendered in two contexts.** The repository file is the single source of truth, rendered both by the website and by the repository host's markdown viewer (SPEC-001, Content Sourcing). Anything that changes one context has to be evaluated for the other.

## Decision

### Anchors are added at render time, not written into the source

The site's markdown pipeline recognizes the numbered principles as they are rendered and gives each one a link target and a self-link, so a rule behaves like a heading anchor. SPEC-000 itself is untouched; the anchors are a property of how the specification is presented, not of the specification.

This keeps the two concerns on the right side of the line. Deep-linkability is a website behavior, and SPEC-001 is the artifact that governs website behavior. Making it a website concern means it is specified, tested, and changed in the place where the rest of the site's rendering rules live.

### Targets are keyed to the principle's number, not its text

An anchor derived from a rule's sentence would break every time the rule was reworded — and rewording a principle is a normal, expected edit to a living document. Keying the target to the number instead means a link survives any change to the wording, and only breaks if the principles are renumbered. Renumbering is already a breaking change to the standard under its own versioning rules, so the anchors fail in exactly the case where a stale citation *should* be re-examined.

### Rejected: promote the eleven rules to headings in SPEC-000

The obvious approach, and the one a capable engineer meeting this problem is most likely to propose: make each principle a heading, and the existing heading-anchor machinery covers them with no new code.

It was rejected on two counts.

First, it moves anchor maintenance inside the versioned standard. Every subsequent adjustment to how the rules are anchored — a slug scheme, a numbering change, a formatting fix — becomes a release of Anchored Development itself, with a version bump and a changelog entry, because it edits SPEC-000. The cost of a presentational tweak would be permanently out of proportion to its substance.

Second, it distorts the document. The principles are a flat enumerated list that reads as a unit; turning them into eleven headings inserts a layer into the heading hierarchy that exists only to carry anchors, and they would surface as eleven entries in any generated table of contents. That is a structural change to the specification made for a rendering convenience — precisely the inversion the framework warns against, where a navigation aid drives the artifact it is supposed to serve.

### Rejected: inline anchor targets written into the markdown

Embedding explicit anchor targets next to each rule in SPEC-000 would work in both rendering contexts. It was rejected because it is hand-maintained state with nothing enforcing it: a twelfth principle added later silently arrives with no anchor, and a renumbering silently leaves the targets wrong. It also still edits SPEC-000, so it carries the versioning cost of the previous alternative without solving the maintenance problem.

## Consequences

**Rule-level anchors exist on the website only.** A repository host rendering the raw markdown shows no anchors for the principles. This is the accepted cost of leaving the source untouched, and it is acceptable because anchored-dev.org is the canonical published form of the specification — the place a reader is pointed to and the place a citation is expected to lead.

**A reader citing a rule has a stable, publishable target**, and one that outlives the rule being reworded.

**Anchor behavior is governed by SPEC-001 and covered by the build smoke tests.** They compare the rendered anchors against the numbered rules counted in SPEC-000 itself, as a contiguous sequence rather than a total, and separately assert that each rule still carries its self-link. Both properties are load-bearing, and neither is implied by the other: a partially-anchored set looks fine on the page, a correct count can still hide one rule duplicated and another skipped, and the link can be lost while every target remains in place. Deriving the expected set from the source rather than fixing it at eleven means adding a principle does not fail the check, while failing to anchor one does.

**The recognition rule is coupled to how the principles are written.** It keys off their current form — a bold, numbered sentence standing alone. Restructuring that presentation in SPEC-000 would break the anchors, and the comparison against the source is what surfaces it. This coupling is the price of not editing the source, and it is confined to the site's build.

**The framework's own rule about navigation aids is preserved.** Anchors are a navigation aid over SPEC-000 and are strictly downstream of it: the specification is authored without regard to them, and they are derived from whatever it says.

## Related Artifacts

- [SPEC-001](../specs/SPEC-001-website.md) — Rendering Rules, which specify rule-level anchors and the pilcrow hover affordance
- [SPEC-000](../specs/SPEC-000-anchored-development.md) — the specification whose principles are anchored, and the versioning rules that shaped this decision
- [ADR-002](ADR-002-website-technology-stack.md) — the build tooling the anchors are implemented in
