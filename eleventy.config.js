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

const md = markdownIt({ html: true, linkify: false, typographer: true });
md.use(markdownItAnchor, {
  permalink: markdownItAnchor.permalink.headerLink(),
  level: [2, 3, 4, 5, 6],
  slugify,
});

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
