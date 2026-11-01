---
title: "Releases"
description: "Behavioral expectations for releases of Anchored Development. A release is a change to SPEC-000, published as an annotated git tag and a GitHub release, which together are the authority on version history. Covers when a release happens, what the tag carries, how release notes are written (what changed, why, and how it affects someone upgrading), and why site and dependency changes are not releases."
status: accepted
tags: [releases, versioning, semver, git-tags, github-releases, release-notes, spec-000]
---

# Releases

Anchored Development is a versioned standard, and the standard is SPEC-000. Git tags and GitHub releases are the authority on its version history. See ADR-007 for why there is no changelog file.

## What Is a Release

Every change to SPEC-000 is a release, however small. Merging the change publishes it: the site renders SPEC-000 from `main`, so spec text that is not ready to publish stays unmerged.

Nothing else is a release. Website changes and dependency updates deploy on merge to `main` and carry no version, tag, or release.

## Publishing a Release

Every release MUST have both an annotated git tag and a GitHub release:

1. The merge request changing SPEC-000 bumps the `version` field in its frontmatter. The contributor proposes the number and the maintainer settles it in review. CI fails a merge request that changes SPEC-000 without bumping the version.
2. After the merge, the maintainer tags the merge commit with the bare version number (`2.1.0`, no `v` prefix). The annotation is a one-line summary, so git itself keeps a short history of releases.
3. Once the tag has reached GitHub, the maintainer publishes a GitHub release for it. The release date is the date it is published.

GitHub is the only home of release notes. No other host carries releases.

## Release Notes

Release notes are for someone deciding whether to upgrade. They are plain and easily digestible, and they answer: *if I upgrade to this, how does it affect me?* Anyone wanting more detail can read the git history and the merge requests.

Every release note covers three things:

- **What changed.** Because the standard is a single file, a note quotes the wording that changed when that makes the change clear.
- **Why.** A sentence or so of reasoning, not the full argument.
- **How it affects someone upgrading.** What they have to do, or that they have nothing to do.

A release note reads like this:

> ADRs no longer have to name a rejected alternative.
>
> Was: "The description MUST contain the decision made AND at least one rejected alternative."
> Now: "…AND the major rejected alternative, when the decision has one."
>
> We changed this because agents documenting older decisions were inventing alternatives nobody had considered. If you upgrade, your existing ADRs stay valid and you have nothing to change.

## Related Artifacts

- [SPEC-000](SPEC-000-anchored-development.md) — the standard being released
- [SPEC-001](SPEC-001-website.md) — deployment of the site from `main`
- [ADR-007](../decisions/ADR-007-releases-over-changelog.md) — why releases replace a changelog file, and why the site is not versioned
- `.gitlab-ci.yml` — the CI check that a change to SPEC-000 bumps its version
