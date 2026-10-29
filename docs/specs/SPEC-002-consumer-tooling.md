---
title: "Consumer Tooling"
description: "Optional tooling that lets a repository following Anchored Development enforce SPEC-000 locally and in CI: a stdlib-only index generator with a freshness check, a pre-push drift check that runs the drift-detector agent through the Claude CLI with a read-only tool set, pre-commit hook definitions, and a GitHub Actions composite for the non-LLM checks. Covers inputs, exit codes, and what the tooling refuses to do."
status: accepted
tags: [tooling, pre-commit, pre-push, drift-detection, index-generation, github-actions, exit-codes, consumers]
---

# Consumer Tooling

Repositories that adopt [SPEC-000](SPEC-000-anchored-development.md) can use this tooling to enforce it. It is optional: SPEC-000 is tool-agnostic and any mechanism that detects drift satisfies it. The tooling is consumed through pre-commit hooks pinned by commit SHA, and a GitHub Actions composite.

## Behavior

### Index generation

- The generator produces `docs/specs/INDEX.md` and `docs/decisions/INDEX.md` from frontmatter, in the same format as the repository's own per-skill generators.
- It uses only the Python standard library, so a hook or CI job needs nothing installed. In exchange, frontmatter must stay simple: one `key: value` per line and tags as an inline list.
- It rejects what the framework rejects: missing required fields, `draft` status, non-lowercase tags, duplicate numbers, and ADRs missing Context, Decision or Consequences.
- A check mode writes nothing and fails when either index is stale.

### Drift check

- It compares the range from the merge base of `BASE` and `HEAD_REF` to `HEAD_REF`. `BASE` defaults to `origin/main`; `HEAD_REF` defaults to the ref being pushed.
- It runs the repository's drift-detector agent instructions through the Claude CLI. The CLI is given only Read, Glob and Grep, and anything else is denied without asking (ADR-006).
- The diff is passed in the prompt, delimited so its content cannot close the block, and labelled as data rather than instructions.
- Lock files are left out of the diff by default, because they carry no behavior or intent. The list is configurable and can be emptied.
- A diff over the size limit is refused, never truncated.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | No drift, or nothing relevant changed (the model is not called) |
| 1 | The detector reported at least one finding |
| 2 | The check could not reach a verdict: unresolvable refs, missing required files, missing runner, runner failure, oversized diff, or output with neither a finding nor the no-drift statement |

Findings win over a no-drift statement, so contradictory output never passes. Only exit code 1 means the artifacts and the code disagree.

### Skipping

`SKIP=drift-check git push` skips the hook once. No environment switch makes the check pass.

### CI

The GitHub Actions composite runs the non-LLM index freshness check only. The drift check runs where the project already runs its drift detection.

## Known gaps

- The verdict comes from a model and is not deterministic. The stub-runner tests prove the plumbing, not the judgment.
- The generator duplicates the per-skill generators' output format; the two must stay in step.

## Related Artifacts

- Code: `tools/drift-check`, `tools/gen-index`, `.pre-commit-hooks.yaml`, `.github/actions/check`.
- Tests: `test/drift-check.sh`, `test/gen-index.sh`, run by the `test:tools` CI job.
- Specs: SPEC-000 (requires drift detection and generated indexes).
- ADRs: ADR-006 (read-only tool set), ADR-007 (local tooling and refusal to guess).
