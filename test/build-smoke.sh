#!/usr/bin/env sh
# Build smoke test — verifies the Eleventy build completes and produces
# expected output files. Run from the repository root.
set -eu

OUTPUT_DIR="site/_site"

# Clean previous build output
rm -rf "$OUTPUT_DIR"

# Run the build
npm run build

# Check that critical output files exist
fail=0
for f in "$OUTPUT_DIR/index.html" "$OUTPUT_DIR/getting-started/index.html" "$OUTPUT_DIR/colophon/index.html" "$OUTPUT_DIR/css/style.css"; do
  if [ ! -f "$f" ]; then
    echo "FAIL: missing $f"
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "PASS: all expected output files are present."

# Verify rendering rules on the homepage
homepage="$OUTPUT_DIR/index.html"

# Heading anchor links (h2–h6 should have anchor links)
if ! grep -q 'header-anchor' "$homepage"; then
  echo "FAIL: no heading anchor links found in homepage"
  fail=1
fi

# Syntax highlighting at build time (Prism class wrappers)
if ! grep -q 'class="language-' "$homepage"; then
  echo "FAIL: no syntax-highlighted code blocks found in homepage"
  fail=1
fi

# Bare URL auto-detection is disabled (README.md should appear as text, not a link)
if grep -q '<a[^>]*>README\.md</a>' "$homepage"; then
  echo "FAIL: bare .md reference was auto-linked (linkify should be disabled)"
  fail=1
fi

# Dark mode support (prefers-color-scheme media query in stylesheet)
if ! grep -q 'prefers-color-scheme' "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: dark mode media query not found in stylesheet"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "PASS: rendering rules verified."
