import fs from "node:fs/promises";
import path from "node:path";
import markdownIt from "markdown-it";
import syntaxHighlight from "@11ty/eleventy-plugin-syntaxhighlight";
import markdownItAnchor from "markdown-it-anchor";

// Shared markdown-it instance used by both 11ty's pipeline and renderSpec
const slugify = (s) =>
  s
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-")
    .trim();

// The numbered principles in SPEC-000 are bold paragraphs, not headings, so
// markdown-it-anchor does not reach them. This gives each one a stable
// `principle-N` id and a self-link, so a rule is as deep-linkable as a section.
// Slugs key off the number rather than the sentence so rewording a rule does not
// break inbound links. Applied at render time only — SPEC-000 stays untouched.
function principleAnchors(md) {
  // Deliberately narrow: a whole paragraph that is exactly one bold
  // "N. sentence" run. Ordered-list items elsewhere in SPEC-000 also open with
  // bold text, but they are nested (level > 0) and carry trailing prose, so they
  // fail both this pattern and the level check below.
  const PRINCIPLE_RE = /^\*\*(\d+)\.\s[^*]*\*\*$/;

  md.core.ruler.push("principle_anchors", (state) => {
    const tokens = state.tokens;
    for (let i = 0; i < tokens.length - 1; i++) {
      const open = tokens[i];
      if (open.type !== "paragraph_open" || open.level !== 0) continue;

      const inline = tokens[i + 1];
      if (!inline || inline.type !== "inline") continue;

      const match = PRINCIPLE_RE.exec(inline.content);
      if (!match) continue;

      const slug = `principle-${match[1]}`;
      open.attrSet("id", slug);

      // Wrap the paragraph's existing children in a self-link so the rule
      // behaves like a heading anchor (headerLink permalink style).
      const linkOpen = new state.Token("link_open", "a", 1);
      linkOpen.attrSet("class", "header-anchor principle-link");
      linkOpen.attrSet("href", `#${slug}`);
      const linkClose = new state.Token("link_close", "a", -1);

      inline.children.unshift(linkOpen);
      inline.children.push(linkClose);
    }
  });
}

const md = markdownIt({ html: true, linkify: false, typographer: true });
md.use(markdownItAnchor, {
  permalink: markdownItAnchor.permalink.headerLink(),
  level: [2, 3, 4, 5, 6],
  slugify,
});
md.use(principleAnchors);

/** @param {import("@11ty/eleventy").UserConfig} eleventyConfig */
export default function (eleventyConfig) {
  // --- Plugins ---
  eleventyConfig.addPlugin(syntaxHighlight);

  // --- Markdown configuration ---
  eleventyConfig.setLibrary("md", md);

  // --- Custom shortcode: renderSpec ---
  // Reads a markdown file, strips YAML frontmatter, and renders to HTML
  // using the shared markdown-it instance configured above.
  eleventyConfig.addAsyncShortcode("renderSpec", async function (filePath) {
    const resolvedPath = path.resolve(filePath);
    const content = await fs.readFile(resolvedPath, "utf-8");

    // Strip YAML frontmatter (--- delimited block at start of file)
    const body = content.replace(/^---[\s\S]*?---\n*/, "");

    return md.render(body);
  });

  // --- Passthrough copy ---
  eleventyConfig.addPassthroughCopy({ "site/src/css": "css" });
  eleventyConfig.addPassthroughCopy({ "site/src/img": "img" });
  eleventyConfig.addPassthroughCopy({ "site/src/js": "js" });

  // --- Watch targets ---
  // Rebuild when the spec changes (it lives outside the input directory)
  eleventyConfig.addWatchTarget("docs/specs/");
}

export const config = {
  dir: {
    input: "site/src",
    output: "site/_site",
    includes: "_includes",
    data: "_data",
  },
};
