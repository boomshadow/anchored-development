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

- The generator produces `docs/specs/INDEX.md` and `docs/decisions/INDEX.md` from frontmatter, with the same table format as the per-skill generators. An empty directory yields a header-only index, so a repository can start with no specs or ADRs.
- It uses only the Python standard library, so a hook or CI job needs nothing installed. In exchange, frontmatter must stay simple: one `key: value` per line and tags as an inline list. Constructs it cannot read exactly (trailing comments, escaped single quotes, other escapes, bare booleans or numbers) are rejected rather than guessed.
- It rejects what the framework rejects: missing required fields, `draft` status, non-lowercase tags, duplicate numbers, and ADRs missing Context, Decision or Consequences.
- The generated-by header comment is not compared and not rewritten when it differs, so indexes written by either tool pass the check and are left alone. A check mode writes nothing and fails when either index is stale.

### Drift check

- It compares the range from the merge base of `BASE` and `HEAD_REF` to `HEAD_REF`. `BASE` defaults to the remote's default branch. `HEAD_REF` defaults to the ref pre-commit reports as pushed, else `HEAD`.
- It runs drift-detector agent instructions through the Claude CLI: by default the copy shipped with the tooling, or a file the caller names. The CLI is given only the Read, Glob and Grep tools, anything else is denied without asking (ADR-006), and settings, hooks and MCP servers are ignored, because the commit under review controls them.
- The agent reads the files of the change's tip from a temporary export, so the diff and the artifacts it is compared with describe the same commit. The export does not touch the caller's index or run repository hooks.
- The diff is passed between markers carrying a per-run random token and labelled as data. It does not depend on the developer's git configuration.
- Lock files, at any depth, are left out of the diff by default, because they carry no behavior or intent. Entries name a file or a directory, and the list can be emptied.
- A diff over the size limit is refused, never truncated.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | No drift, or nothing relevant changed (the model is not called) |
| 1 | The detector reported at least one finding |
| 2 | The check could not reach a verdict: not in a repository, unresolvable refs, a failing git command, missing required files at the change's tip, missing instructions or runner, runner failure, oversized diff, or output with neither a finding nor the no-drift statement |

Findings win over a no-drift statement, so contradictory output never passes. Only exit code 1 means the artifacts and the code disagree.

### Skipping

`SKIP=drift-check git push` skips the hook once. A client-side hook is advisory: the baseline, runner and instructions are caller-controlled, so it detects honest drift and does not enforce policy.

### CI

The GitHub Actions composite runs the non-LLM index freshness check only. The drift check runs where the project already runs its drift detection.

## Known gaps

- The verdict comes from a model and is not deterministic. The stub-runner tests prove the plumbing, not the judgment.
- Findings are recognised in the model's prose, while the CI detector uses structured output. The two verdict formats are maintained separately.
- Submodule content is absent from the export, so the agent cannot read it.
- Only the first pushed ref is checked when a push carries several.
- There is no timeout around the model call.
- Provider configuration must come from the environment, because user settings are ignored.

## Related Artifacts

- Code: `tools/drift-check`, `tools/gen-index`, `.pre-commit-hooks.yaml`, `.github/actions/check`.
- Tests: `test/drift-check.sh`, `test/gen-index.sh`, run by the `test:tools` CI job. The hook manifest and composite action have no test.
- Specs: SPEC-000 (requires drift detection and generated indexes).
- ADRs: ADR-006 (read-only tool set), ADR-007 (local tooling and refusal to guess).
