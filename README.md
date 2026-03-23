# Anchored Development

> Documentation that has no consumer and no enforcement mechanism is documentation that will lie to you.

Anchored Development is a framework for living documentation in AI-assisted software development. It defines four interconnected artifact types — code, tests, specs, and ADRs — and the practices that prevent them from drifting apart.

**This is the authoritative home of the framework.** The official specification is [`SPEC-000-anchored-development.md`](docs/specs/SPEC-000-anchored-development.md).

## Documentation — Anchored Development

- **Specs**: [`docs/specs/`](docs/specs/) — behavioral expectations by domain
- **ADRs**: [`docs/decisions/`](docs/decisions/) — architectural reasoning and rejected alternatives
- **Drift detection**: [`.claude/agents/drift-detector.md`](.claude/agents/drift-detector.md) — agent and [CI job](.gitlab-ci.yml) that enforces artifact consistency

## Licensing

Spec text and website content are [CC BY-SA 4.0](LICENSES/CC-BY-SA-4.0.txt).
Code is [MPL 2.0](LICENSE).
See [ADR-001](docs/decisions/ADR-001-licensing.md) for the reasoning.
