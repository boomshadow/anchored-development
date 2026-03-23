---
name: spec
description: 'Executable tooling for Specifications: validate frontmatter, generate docs/specs/INDEX.md, and guide spec lifecycle (create, update, delete). Use after any spec creation, edit, rename, or deletion. Writing rules and philosophy live in docs/specs/SPEC-000-anchored-development.md ("Writing Specs" section).'
---

# Spec Skill

## Writing Rules

Read the **Writing Specs** section of `docs/specs/SPEC-000-anchored-development.md` for all spec formatting, frontmatter, granularity, and lifecycle rules. Do not duplicate them here.

## Lifecycle Operations

### Create

1. Scan `docs/specs/` for existing `SPEC-*.md` files.
2. Find the highest `NNN` number. Use `NNN + 1` for the new spec, zero-padded to three digits. SPEC-000 is reserved for the framework specification.
3. Name the file `SPEC-NNN-short-descriptive-slug.md` (lowercase, hyphens).
4. Include required frontmatter: `title`, `description`, `status`, `tags`.
5. No required body sections. Structure the body to serve the domain — lifecycle phases, scenarios, subsystems, or whatever makes the behavior clearest. Include a Related Artifacts section when relevant cross-references exist.
6. Set `status: accepted` unless the spec is a handoff for a future session (use `draft`). Draft is a local/branch-only state — the validator and CI will block merging until all drafts are resolved to `accepted`.
7. Run the validator.

### Update

Edit the spec in place. Never create a "superseded" replacement — this project follows the living-document approach. Git preserves history.

After editing, run the validator.

### Delete

Delete the file. Do not archive or mark superseded. Gaps in numbering are intentional and expected — numbers are never reused.

After deleting, run the validator.

## Validator

### When to Run

After any spec creation, edit, rename, or deletion.

### How to Run

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace python:alpine sh -c "pip install -q pyyaml && python3 .claude/skills/spec/scripts/generate_index.py"
```

### What It Does

1. **Validates** all `SPEC-*.md` files in `docs/specs/` — checks filename format, YAML frontmatter presence, required fields (`title`, `description`, `status`, `tags`), and status values.
2. **Generates** `docs/specs/INDEX.md` — but only if validation passes with zero errors.

### On Failure

If the script exits non-zero, fix the reported errors before proceeding.

**Draft status errors are never pre-existing conditions to ignore.** If the validator reports `status is 'draft' (signals incomplete work)`, the current session must resolve it. Verify the spec reflects current codebase reality, set `status: accepted`, and re-run the validator.
