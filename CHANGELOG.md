# Changelog

All notable changes to the Anchored Development framework ([SPEC-000](docs/specs/SPEC-000-anchored-development.md)) are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-07-11

### Added

- **Principle 7 — "Prose stays above the implementation."** Specs and ADRs describe behavior and reasoning at altitude; they do not name the line numbers, functions, methods, or internal mechanics the code owns. Reference an artifact by its stable name, never by a line or an internal symbol.

### Changed

- **BREAKING: principles renumbered.** Inserting Principle 7 shifted the former principles 7–10 to 8–11 (Domain-level → 8, Enforcement → 9, Spec is the shared language → 10, Transient artifacts → 11). Any reference to a principle by number must be updated.
- **"Living Documents" is now a top-level section** governing all living documents (specs and ADRs), rather than a subsection under *Writing ADRs*. It adds a present-tense rule bounded to point-in-time language — "reverted," "recently," "previously," "earlier," "now," "as of" — the language that goes stale over time. The plain past tense of a settled decision ("was chosen," "was rejected") is explicitly fine. When a decision reverses, the abandoned approach moves into the Decision's rejected-alternatives with its evidence retained, rather than being narrated as a rollback.

## [1.0.0] - 2026-03-27

### Added

- Initial release of the Anchored Development framework: four interconnected artifact types (code, tests, specs, ADRs), three enforcement modes (self-enforcing, verified, unverified), drift detection as the enforcement mechanism, and the practices that keep documentation anchored to reality.
