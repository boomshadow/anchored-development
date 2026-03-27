---
name: adr
description: 'Executable tooling for Architecture Decision Records: validate frontmatter/body, generate docs/decisions/INDEX.md, and guide ADR lifecycle (create, update, delete). Use after any ADR creation, edit, rename, or deletion. Writing rules and philosophy live in docs/specs/SPEC-000-anchored-development.md ("Writing ADRs" section).'
---

# ADR Skill

## Writing Rules

Read the **Writing ADRs** section of `docs/specs/SPEC-000-anchored-development.md` for all ADR formatting, frontmatter, body structure, and lifecycle rules. Do not duplicate them here.

### Project Writing Conventions

ADR Decision sections document specific technical choices — naming the tool, the pattern, the tradeoff. That specificity is the point.

Consequences sections should describe what changes for the team, not restate implementation details. Avoid claims about the current state of other files (e.g., "`.gitlab-ci.yml` is unchanged") — those go stale. Instead, describe the structural outcome (e.g., "No deployment stage was added to CI").

## Lifecycle Operations

### Create

1. Scan `docs/decisions/` for existing `ADR-*.md` files.
2. Find the highest `NNN` number. Use `NNN + 1` for the new ADR, zero-padded to three digits.
3. Name the file `ADR-NNN-short-descriptive-slug.md` (lowercase, hyphens).
4. Include required frontmatter: `title`, `description`, `status`, `tags`.
5. Include required body sections: **Context**, **Decision**, **Consequences**.
6. Set `status: accepted` unless the ADR is a handoff for a future session (use `draft`). Draft is a local/branch-only state — the validator and CI will block merging until all drafts are resolved to `accepted`.
7. Run the validator.

### Update

Edit the ADR in place. Never create a "superseded" replacement — this project follows the living-document approach. Git preserves history.

After editing, run the validator.

### Delete

Delete the file. Do not archive or mark superseded. Gaps in numbering are intentional and expected — numbers are never reused.

After deleting, run the validator.

## Validator

### When to Run

After any ADR creation, edit, rename, or deletion.

### How to Run

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace python:alpine sh -c "pip install -q pyyaml && python3 .claude/skills/adr/scripts/generate_index.py"
```

### What It Does

1. **Validates** all `ADR-*.md` files in `docs/decisions/` — checks filename format, YAML frontmatter presence, required fields (`title`, `description`, `status`, `tags`), status values, and required body sections (`Context`, `Decision`, `Consequences`).
2. **Generates** `docs/decisions/INDEX.md` — but only if validation passes with zero errors.

### On Failure

If the script exits non-zero, fix the reported errors before proceeding.

**Draft status errors are never pre-existing conditions to ignore.** If the validator reports `status is 'draft' (signals incomplete work)`, the current session must resolve it. Verify the ADR reflects current codebase reality, set `status: accepted`, and re-run the validator.
