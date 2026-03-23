# Contributing to Anchored Development

Contributions are welcome. This repository is the authoritative source for the Anchored Development framework, so changes here have broad impact.

## How to Contribute

- **Spec changes**: Open an issue first to discuss before submitting a PR.
- **Website, tooling, or typo fixes**: PRs are welcome directly.

## Workflow

The source of truth for this repository lives on GitLab and mirrors to GitHub. PRs are accepted on GitHub, but merging involves syncing back to GitLab, so expect slightly longer merge times than a typical GitHub project.

### Branch protection

Direct pushes to `main` are blocked at the GitLab project level. All changes reach `main` through merge requests, where the drift detection CI job runs automatically. This ensures every change is checked for artifact consistency before it lands.

## Licensing

By contributing, you agree that your contributions are licensed under the project's existing terms — MPL 2.0 for code, CC BY-SA 4.0 for spec text and website files.
See [ADR-001](docs/decisions/ADR-001-licensing.md) for details.
