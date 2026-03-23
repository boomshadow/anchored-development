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

## Website

`site/` contains deployment files for the static site at anchored-dev.org.
Not yet built.
