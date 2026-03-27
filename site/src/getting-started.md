---
layout: page.njk
title: Getting Started
description: How to adopt Anchored Development in your project.
---

Adopting Anchored Development requires the full framework structure — the spec, the indexes, drift detection, and entry files. What grows gradually is the content. Specs and ADRs are written as domains and decisions emerge, not all at once.

### New Projects

Add the [minimum required files](#what-your-repo-will-look-like) and you are practicing the framework from commit one. Write your first spec when a domain has behavioral expectations that code alone cannot express. Write your first ADR when you make a decision worth explaining to a future engineer — or a future AI agent.

### Existing Codebases

You still need the full structure, but you don't need to retroactively document every past decision. The risk is the documentation you already have — the `README.md` that describes last year's architecture, the design docs that nobody updated, the _Markdown monsters_. These are unverified artifacts. They will lie to you, and they will lie to every AI agent that reads them. Consider cordoning off existing documentation with an ADR that acknowledges the migration, then move forward as if it were a new project.

### Read the specification first

The spec's [Adopting Anchored Development](https://anchored-dev.org/#adopting-anchored-development) section is the authoritative source. It defines what is required, what is recommended, and how to map your existing documentation into the framework.

## The Example Repository

The [anchored-development-example](https://github.com/boomshadow/anchored-development-example) repository is a minimal, working starting point for your own project. It includes the framework spec, the required directory structure, auto-generated indexes, a drift detection setup, and entry files.

Clone it and start building. Fork it and adapt. Or just read through it to see what a project can look like on day one.

## What Your Repo Will Look Like

Here is the minimal structure for a project practicing Anchored Development:

```txt
your-project/
├── docs/
│   ├── specs/
│   │   ├── SPEC-000-anchored-development.md
│   │   └── INDEX.md
│   └── decisions/
│       └── INDEX.md
├── drift-detector.sh  ← wire into your CI pipeline
├── AGENTS.md  (or your AI entry file)
└── README.md
```

Everything else grows from here.
