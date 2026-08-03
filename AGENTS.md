# AI instructions

This repository is the authoritative home of the Anchored Development
framework. The official specification is
[SPEC-000](docs/specs/SPEC-000-anchored-development.md).

This project follows its own framework. The specs, ADRs, and skills in this
repo are not examples — they are the real artifacts governing this project.

## Documentation — Anchored Development

This project follows [Anchored Development](docs/specs/SPEC-000-anchored-development.md).

- **Specs**: `docs/specs/` — behavioral expectations by domain
- **ADRs**: `docs/decisions/` — architectural reasoning and rejected alternatives
- **Skills**: `.claude/skills/` — spec and adr
- **Agents**: `.claude/agents/` — drift-detector
- **Drift detection**: `.claude/agents/drift-detector.md` — runs in CI on every push; invoke locally to verify artifact consistency before pushing

## Versioning & releases

Anchored Development is a versioned standard ([SemVer](https://semver.org)). Any change to [SPEC-000](docs/specs/SPEC-000-anchored-development.md) is a release and MUST:

1. **Bump** the `version` field in SPEC-000 frontmatter — major for a breaking change (e.g. renumbered principles, a new or removed MUST), minor for additive changes, patch for clarifications and fixes.
2. **Record** a matching entry in [`CHANGELOG.md`](CHANGELOG.md) ([Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format) describing what changed.
3. **Tag** the release (`git tag X.Y.Z` — no `v` prefix) once merged to `main`.

CI enforces step 2: a merge request that changes SPEC-000 fails unless `CHANGELOG.md` is updated in the same MR. `CHANGELOG.md` is a navigation aid — downstream of SPEC-000, never a driver of it (see SPEC-000 § Navigation Aids).

## Website

`site/` contains source files for the static site at anchored-dev.org.
Built with Eleventy v3 (Build Awesome), deployed via Cloudflare Pages.
See [SPEC-001](docs/specs/SPEC-001-website.md) for behavioral expectations,
[ADR-002](docs/decisions/ADR-002-website-technology-stack.md) for technology decisions,
[ADR-003](docs/decisions/ADR-003-dark-mode-approach.md) for the dark mode approach,
[ADR-004](docs/decisions/ADR-004-rule-level-anchors.md) for rule-level anchors,
and [ADR-005](docs/decisions/ADR-005-link-color-and-state.md) for link color and state.
Build config: `eleventy.config.js` at repo root. Source: `site/src/`. Output: `site/_site/`.
