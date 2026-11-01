---
title: "Git Tags and GitHub Releases Instead of a Changelog"
description: "Adopted annotated git tags and GitHub releases as the authority on Anchored Development's version history, with one release per SPEC-000 change and the site deploying from main. A CHANGELOG.md file was rejected because it drifts and makes contributors invent a release date they cannot know, leaving the maintainer to correct it. A spec-only changelog, separate website version tags, a release for every change, and rendering SPEC-000 from the latest tag were also rejected."
status: accepted
tags: [releases, versioning, changelog, git-tags, github-releases, deployment, website, spec-000]
---

# ADR-007: Git Tags and GitHub Releases Instead of a Changelog

## Context

Anchored Development is a versioned standard published from a single file, SPEC-000. The repository also holds the website that renders it, and receives routine dependency updates. Readers need to learn what changed between versions of the standard and how an upgrade affects them. Contributors propose changes to SPEC-000 without knowing when those changes will ship.

## Decision

Annotated git tags and GitHub releases are the authority on version history. Every change to SPEC-000 is a release and gets both; merging the change publishes it. The tag carries a one-line summary and the release carries the commentary. Website changes and dependency updates deploy from `main` and are not releases. See SPEC-002.

A release already ties together its version, date, tag, and notes, for people and for tooling alike.

### Rejected: a CHANGELOG.md file

A changelog restates what the tags, releases, and git history already hold, and that second record drifts. It also puts a burden on the contributor: an entry needs a release date, which a contributor does not know, and the maintainer is left correcting it. Keep a Changelog objects that GitHub releases are non-portable and less discoverable than a file in the repository. Portability costs little here, because adopters are not required to copy a changelog and the annotated tags keep a short history in git. The README links to the releases for discoverability.

### Rejected: a changelog for spec changes, with tags and releases for the site

This keeps the changelog's burden for the audience that matters most, and spends releases on the audience that matters least.

### Rejected: separate website version tags

Tags such as `website-1.4.5` version something nobody upgrades to. The numbers would carry no meaning for any reader.

### Rejected: a tag and release for every change

Color tweaks and dependency updates would bury the releases of the standard, which are the reason to read the release list.

### Rejected: rendering SPEC-000 from the latest tag

The site could deploy from `main` while rendering SPEC-000 from the most recent tag, so that no text appears before its release. Tag pushes would need a separate rebuild trigger, builds would need the tags fetched, and the site's tests would check a different copy of the spec from the one rendered. All of that closes a gap of minutes, on a site that shows no version number. Spec text that should not be public stays unmerged.

## Consequences

- A contributor changing SPEC-000 proposes a version number and writes no date.
- The tag does not control what is live. A SPEC-000 change is public from the moment it merges, shortly before its tag and release exist, and nothing forces the maintainer to publish them.
- Spec changes cannot be merged and then published together as a batch. Wanting that would be the reason to revisit tag-based rendering.
- Release notes live outside the repository, so they get no merge request review or drift detection, and they stay editable after publishing.
- Release notes depend on GitHub. If the project leaves GitHub, they have to be moved, and the annotated tags remain as a short history.

## Related Artifacts

- [SPEC-002](../specs/SPEC-002-releases.md) — how releases are published and how release notes are written
- [SPEC-001](../specs/SPEC-001-website.md) — deployment of the site from `main`
- [ADR-004](ADR-004-rule-level-anchors.md) — keeps presentational anchor changes out of SPEC-000, because any change to it is a release
