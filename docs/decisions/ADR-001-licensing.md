---
title: "Licensing: MPL 2.0 for Code, CC BY-SA 4.0 for Specification"
description: "Dual licensing for the Anchored Development repos. Code in both the spec repo and example repo is licensed under MPL 2.0 (file-level copyleft). The specification text and published website are licensed under CC BY-SA 4.0. GPL v3 was rejected because enterprise legal teams routinely reject GPL dependencies and the perception of viral licensing kills adoption — even when the legal reality is more nuanced. Apache 2.0 and MIT were rejected as too permissive — they allow proprietary forks of the framework tooling with no obligation to keep modifications open."
status: accepted
tags: [licensing, mpl-2.0, cc-by-sa-4.0, gpl, apache, open-source, adoption, copyleft]
---

# ADR-001: Licensing — MPL 2.0 for Code, CC BY-SA 4.0 for Specification

## Context

Anchored Development is published as two repositories:

1. **Spec repo** — The authoritative home of SPEC-000, issues/PRs, and a published website. Contains both the specification text (prose) and code (CI/CD pipelines, build tooling, static site assets). The spec repo dogfoods the framework with its own bespoke tooling (skills, drift detection, index generators).
2. **Example repo** — Generic, distributable versions of the framework tooling for adoption. Contains skills, drift detection tooling, index generators, CI templates, and git hooks. This is what teams copy from when adopting.

Both repos need a license. Without one, copyright law defaults to "all rights reserved" — nobody can legally copy, modify, or redistribute the work. That's the opposite of the goal.

The licensing choice is constrained by two competing forces:

**Adoption requires low friction.** The example repo's entire purpose is to be copied into other projects — including proprietary enterprise codebases. Files like drift detection scripts, CI templates, and skills get dropped into repos alongside closed-source code. A license that creates legal anxiety around this use case kills adoption.

**The work must stay open.** The framework and its tooling should not be forkable into a closed-source "Anchored Development Enterprise Edition." If someone improves the drift detection script or the ADR writing skill, those improvements should remain available to the community.

Additionally, the spec repo contains two distinct types of content — prose (the specification) and code (build tooling) — which are best served by different license families.

## Decision

### Code: MPL 2.0 (Mozilla Public License 2.0)

All code in both repositories is licensed under MPL 2.0. This includes skills, scripts, CI templates, git hooks, index generators, build tooling, and any other executable or configuration files.

MPL 2.0 is a **file-level copyleft** license:

- If someone modifies an MPL-licensed file, the modified version must be distributed under MPL 2.0. They cannot close-source improvements to the framework's tooling.
- Including MPL-licensed files alongside proprietary code in the same project is explicitly permitted. The copyleft obligation does not spread beyond the individual file boundary.

This file-level scoping is critical because the example repo's adoption model is "copy these files into your project." Teams must be able to drop a drift detection CI template into a proprietary codebase without any licensing concern about the rest of their code.

### Specification text and website: CC BY-SA 4.0

The specification document (SPEC-000) and the published website content are licensed under Creative Commons Attribution-ShareAlike 4.0 International. This is a prose license, not a software license — it covers the written framework, not the code.

CC BY-SA 4.0 requires attribution and ensures that derivative versions of the spec (translations, adaptations, forks) must be released under the same or a compatible license.

### Rejected: GPL v3

GPL v3 provides the copyleft protection we want, but its scope is too broad for the adoption model. GPL's copyleft applies at the program level, not the file level. While the legal reality of including a GPL-licensed script in a larger proprietary project is more nuanced than most people believe, **perception is what matters for adoption.**

Enterprise legal teams routinely reject GPL dependencies. The mere presence of a GPL-licensed file in a codebase triggers review processes, legal escalation, and often outright rejection — regardless of whether the specific use case would actually trigger the copyleft obligation. MPL 2.0 eliminates this friction entirely. Its file-level boundary is explicit, well-documented in the MPL FAQ, and understood by legal teams as safe for inclusion in proprietary projects.

Choosing GPL would mean optimizing for copyleft purity at the cost of the framework reaching the teams that need it most.

### Rejected: Apache 2.0

Apache 2.0 is a permissive license with good patent protections but no copyleft. Someone could fork the example repo, add premium features, close-source the result, and distribute it as a proprietary product. They would only need to preserve the copyright notice and the LICENSE file.

This directly conflicts with the goal of keeping the framework's tooling open. Apache 2.0 is appropriate when adoption at any cost is the priority and you don't care about proprietary forks. We do care.

### Rejected: MIT

MIT is the most permissive common license. It offers even less protection than Apache 2.0 — no patent grant, no copyleft. The same proprietary fork concern applies, with the additional risk of patent-related complications. MIT was never seriously considered.

### License file layout

Both licenses live in a `LICENSES/` directory using SPDX identifier filenames:

```
LICENSES/
├── MPL-2.0.txt
└── CC-BY-SA-4.0.txt
```

The MPL 2.0 text is additionally duplicated as `LICENSE` in the repo root. This duplication exists because GitHub, GitLab, and license scanning tools (FOSSA, Snyk, etc.) look for a top-level `LICENSE` file to detect and display the project's license. Without it, these tools report "no license detected." The `LICENSES/` directory is the canonical location; the root `LICENSE` is a pragmatic duplicate for tooling compatibility.

This layout is inspired by — but does not fully follow — the [REUSE specification](https://reuse.software/spec-3.3/). REUSE requires per-file license headers (SPDX comments at the top of every source file). We adopt only the parts that solve our problem: a `LICENSES/` directory with SPDX-named files for clean multi-license organization, and a root `LICENSE` for tooling detection. We do not add per-file headers or pursue full REUSE compliance. This is a deliberate scope choice — the organizational convention is valuable, the per-file ceremony is not worth the overhead for this project.

## Consequences

- Both repos carry a root `LICENSE` file with the full MPL 2.0 text for tooling detection.
- The spec repo carries a `LICENSES/` directory containing `MPL-2.0.txt` and (in the spec repo) `CC-BY-SA-4.0.txt`, using SPDX identifiers as filenames.
- The spec repo README must clearly explain the dual licensing: code under MPL 2.0, spec text and website under CC BY-SA 4.0.
- Adopters can freely copy files from the example repo into proprietary codebases. If they modify those files and distribute them, the modifications must remain under MPL 2.0.
- Future contributions to either repo are accepted under the same license terms. The CONTRIBUTING.md should note this.

## Related Artifacts

- [SPEC-000](../specs/SPEC-000-anchored-development.md) — the specification text this license governs (CC BY-SA 4.0)
