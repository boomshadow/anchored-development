---
title: "Local Pre-Push Drift Check and a Standalone Index Generator"
description: "Consumer repositories get a pre-push drift check that reuses the drift-detector agent instructions with the read-only tool set of ADR-006, and a stdlib-only index generator with a freshness check. The check refuses oversized diffs and unparseable output instead of truncating or guessing. Rejected: a second hand-written detector prompt, a CI-only check, allow-listing tools without restricting the tool set, truncating large diffs, and reusing the per-skill generators that need PyYAML."
status: accepted
tags: [drift-detection, pre-push, tooling, pre-commit, least-privilege, index-generation, fail-explicitly]
---

# ADR-007: Local Pre-Push Drift Check and a Standalone Index Generator

## Context

SPEC-000 requires drift detection on every change, and allows a git hook as the mechanism. The repository's CI detector covers merge requests on its own platform. Teams on other platforms, and anyone who wants feedback before a push, need the same check locally. Pre-commit hooks and CI jobs on other platforms also need index freshness checks without installing a YAML library.

## Decision

- Provide a local drift check for pre-push use. It reuses the repository's drift-detector agent instructions as the single source of the detection criteria, and the read-only tool set of ADR-006.
- Treat repository text as data, delimit the diff, and map output to exit codes 0, 1 and 2, where 2 means no verdict was reached.
- Refuse a diff over the size limit and output that is neither a finding nor the no-drift statement. A check that cannot see the whole change or understand the answer does not pass.
- Provide a stdlib-only index generator with a check mode, producing the same format as the per-skill generators.
- Publish both as pre-commit hooks, plus a GitHub Actions composite for the non-LLM check.

### Rejected alternatives

**A second, hand-written detector prompt.** It diverges from the agent instructions within weeks, so local and CI verdicts disagree.

**A CI-only check.** Feedback arrives after the push, and platforms other than the one hosting CI get nothing.

**Allow-listing tools without restricting the tool set.** Rejected for the reasons in ADR-006: it leaves file writes and network access available to an agent that reads untrusted text.

**Truncating large diffs.** A verdict on part of a change reads as a verdict on all of it. Refusing is honest and lets the author raise the limit or split the push.

**Reusing the per-skill generators.** They require PyYAML, which a hook or minimal CI image must then install. Accepted cost: a second generator whose output format must be kept in step.

## Consequences

- A push can be blocked by infrastructure trouble (exit 2) as well as by drift (exit 1); the exit code tells them apart.
- The local check costs one model call per push that changes a relevant file.
- Changes to the index format or the agent's output format must update the tooling and its tests together.
