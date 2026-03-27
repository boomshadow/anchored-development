---
title: "Website Technology Stack: Eleventy on Cloudflare Pages"
description: "Adopted Eleventy (Build Awesome) v3 as the static site generator for anchored-dev.org, deployed via Cloudflare Pages native GitLab integration. Hugo was rejected despite its theme ecosystem because Go templating is less flexible for custom shortcode work and symlinks are silently ignored. Jekyll was rejected for Ruby dependency friction. Pandoc was rejected as a converter, not a site generator. Astro was rejected as overkill for a small site. Explicit CI deploy jobs were rejected in favor of Cloudflare's native integration."
status: accepted
tags: [website, static-site-generator, eleventy, cloudflare-pages, deployment, hosting]
---

# ADR-002: Website Technology Stack — Eleventy on Cloudflare Pages

## Context

Anchored Development needs a website at anchored-dev.org to publish the framework specification as a readable, navigable web page. The site has two requirements that constrain the technology choice:

**The spec must render from source.** SPEC-000 is a 580-line markdown file at `docs/specs/SPEC-000-anchored-development.md`. It is the authoritative artifact. The website must render this file directly at build time — not a copy, not a duplicate, not a synced mirror. One source of truth, rendered in two contexts (repository and website).

**The site must be simple and low-maintenance.** The initial scope is a small handful of pages: the spec rendered as the homepage, a companion getting-started guide, and a colophon. The framework is the product, not the website. Technology choices that optimize for scale, speed, or feature richness at the cost of simplicity are wrong for this use case.

The repository is private on GitLab.com. The domain's DNS is managed by Cloudflare (free tier). The site content is static — no server-side logic, no database, no authentication.

## Decision

### Static site generator: Eleventy (Build Awesome) v3

All site source lives in `site/src/`. The build configuration (`eleventy.config.js`) and dependencies (`package.json`) live at the repository root. Build output goes to `site/_site/`.

Eleventy was chosen for four reasons:

**Custom shortcodes solve the rendering problem cleanly.** A custom async shortcode (`renderSpec`) reads the spec file from `docs/specs/`, strips its YAML frontmatter, and renders the markdown body through the same markdown-it pipeline used by the rest of the site. This is straightforward Node.js — `fs.readFile`, a regex to strip frontmatter, and the configured markdown-it instance. No file duplication, no symlinks, no build-time copy steps.

**The data cascade handles frontmatter overlay.** The spec file has its own frontmatter (`title`, `description`, `status`, `version`, `tags`, `license`) that serves the repository context. The website needs different metadata (`layout`, page-specific data). Eleventy's data cascade lets directory data files inject site-building metadata without touching the spec file's frontmatter.

**Nunjucks templating and layout chaining.** Layouts chain cleanly: `base.njk` (HTML shell, fonts, CSS) → `spec.njk` (hero section, ornamental frame) for the homepage, and `base.njk` → `page.njk` (simpler header) for explainer pages. Adding a new page type means adding one layout file.

**Minimal abstraction, minimal dependencies.** Eleventy v3 is ESM-native, Node.js only, and ships its own dev server with hot reload. The dependency footprint is small: `@11ty/eleventy`, `@11ty/eleventy-plugin-syntaxhighlight`, and a few markdown plugins. No Ruby, no Go, no framework runtime.

### Hosting: Cloudflare Pages with native GitLab integration

Cloudflare Pages connects to the GitLab.com repository via OAuth and builds automatically on every push. Production deployments trigger on pushes to `main`. Feature branches get preview deployments at unique URLs.

Build configuration (set in Cloudflare dashboard):
- Framework preset: Eleventy
- Build command: `npm run build`
- Build output directory: `site/_site`
- Environment variable: `NODE_VERSION=20`
- Custom domain: anchored-dev.org

Deployment is not a CI job — Cloudflare Pages handles builds and deploys independently via its native GitLab integration. This separation keeps CI focused on validation and testing, while Cloudflare owns the deploy pipeline.

### Configuration: repo root

`package.json` and `eleventy.config.js` live at the repository root rather than inside `site/`. This is a deliberate choice — the custom shortcode needs to read `docs/specs/SPEC-000-anchored-development.md`, and paths in Eleventy resolve relative to the project root. Placing the configuration at the repo root means the spec file path works naturally without path gymnastics.

The tradeoff is two additional files at the repo root. This is acceptable because the repository already acknowledges mixed concerns (specs, ADRs, skills, CI configuration, and site source all coexist).

### Rejected: Hugo

Hugo has the strongest theme ecosystem of any static site generator — hundreds of polished documentation themes that work out of the box. For a project that wants to pick a theme and ship fast, Hugo is the best choice.

That is not this project. The site has a specific visual identity (see SPEC-001) that requires custom CSS, not a pre-built theme. In that context, Hugo's advantages become neutral while its friction points remain:

- Go template syntax (`{{ range .Pages }}`, `{{ with .Params.title }}`) is less intuitive than Nunjucks for someone who will be iterating on layout and design.
- Symlinks are silently ignored in Hugo (open issue [#3241](https://github.com/gohugoio/hugo/issues/3241) since 2017). The alternative — module mounts — works but adds Go module initialization ceremony.
- Cloudflare Pages defaults to Hugo v0.54 (from 2019) unless you explicitly set the `HUGO_VERSION` environment variable. This is a known gotcha that causes silent build failures.

### Rejected: Jekyll

Jekyll is the most established static site generator and powers semver.org. However:

- Ruby dependency management (rbenv/asdf, Bundler, native gem compilation) adds friction that Node.js does not. Jekyll broke on Ruby 3.4 until a patch release.
- The `{% include_relative %}` tag cannot traverse upward (`../`), making it the weakest option for rendering an external markdown file from a different directory.
- Development pace is glacial compared to Eleventy or Hugo. Jekyll is in maintenance mode, not active development.

### Rejected: Pandoc

Pandoc can convert SPEC-000 to a styled HTML file with a single command. For a one-page site with no navigation, no templating, and no asset pipeline, this is the fastest path to a result.

The limitation is everything after that first page. Adding a second page, shared navigation, consistent layouts, or any site-level structure requires building those capabilities by hand. Pandoc is a document converter, not a site generator. The effort to add the "Why Anchored Development?" page and shared chrome would exceed the effort of using a proper static site generator from the start.

### Rejected: Astro with Starlight

Astro was acquired by Cloudflare in 2025, making it the best-supported framework on Cloudflare Pages. Starlight, Astro's documentation theme, provides search, dark mode, sidebar navigation, and internationalization out of the box.

This is overkill for a small site. Astro's `node_modules` footprint is large, the Starlight template has many moving parts, and the sidebar-centric navigation design is awkward for a handful of pages. If anchored-dev.org grows into a multi-section documentation site, Astro becomes the right choice. For now, it is premature complexity.

### Rejected: Explicit CI deploy jobs

An alternative to Cloudflare's native GitLab integration is adding a `pages` stage to `.gitlab-ci.yml` that runs `npx wrangler pages deploy site/_site`. This gives full control over the deploy pipeline from CI.

The tradeoff is operational overhead with no current benefit: storing `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` as CI variables, maintaining the deploy job, and paying for CI minutes that Cloudflare would otherwise handle for free. The native integration is simpler and sufficient.

Note: `wrangler.toml` is present in the repository as configuration for Cloudflare's native build integration, which uses wrangler under the hood. The rejection here is of explicit deploy *jobs* in CI, not the wrangler configuration file itself.

If the native integration ever proves insufficient (e.g., need for build-time secrets, conditional deployment logic, or integration testing before deploy), a CI-driven deploy job is a known escape hatch.

## Consequences

- Build configuration lives at the repository root. Build artifacts and dependencies are excluded from version control.
- Site source lives at `site/src/`. Build output goes to `site/_site/`.
- Cloudflare Pages must be configured in the dashboard (one-time manual setup after the code is merged to `main`).
- No deployment stage was added to CI — deployment is decoupled from validation and drift detection.
- Adding new pages means creating a markdown or Nunjucks file in `site/src/` with the appropriate layout in its frontmatter.
- The `renderSpec` custom shortcode creates a coupling between the build and the spec file's location. If SPEC-000 moves, the shortcode path must be updated. This is acceptable — the spec's location is defined by the framework itself and is unlikely to change.

## Related Artifacts

- [SPEC-001](../specs/SPEC-001-website.md) — behavioral expectations for the website
- [SPEC-000](../specs/SPEC-000-anchored-development.md) — the specification rendered as the homepage
- [ADR-001](ADR-001-licensing.md) — the site content is licensed under CC BY-SA 4.0
