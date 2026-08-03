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
for f in "$OUTPUT_DIR/index.html" "$OUTPUT_DIR/getting-started/index.html" "$OUTPUT_DIR/colophon/index.html" "$OUTPUT_DIR/css/style.css" "$OUTPUT_DIR/js/theme.js"; do
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

# Rule-level anchors: every numbered principle in SPEC-000 is individually
# deep-linkable (SPEC-001 §Rendering Rules, ADR-004). The invariant is that the
# rendered anchors are exactly the numbered rules in the source, so the expected
# set is derived from SPEC-000 rather than hardcoded — adding a principle should
# not fail this check, but failing to anchor one must. The ids are compared as a
# contiguous sequence because endpoints and a bare count both pass while a
# matcher duplicates one rule and skips another.
spec_source="docs/specs/SPEC-000-anchored-development.md"
principle_total=$(grep -c '^\*\*[0-9]' "$spec_source" 2>/dev/null || true)

# A zero total is the one input that makes every check below compare nothing
# against nothing and pass. That is not hypothetical: restructuring the rules in
# SPEC-000 stops the source pattern and the pipeline matching together, which is
# exactly the coupling ADR-004 records as this approach's standing risk. Fail on
# it rather than let the suite go quiet at the moment it matters most.
if [ -z "$principle_total" ] || [ "$principle_total" -lt 1 ]; then
  echo "FAIL: no numbered rules matched in $spec_source — the anchor assertions below cannot be trusted"
  fail=1
  principle_total=0
fi

# Digits only, so a future heading slugging to principle-<word> cannot inflate
# the set — the spec already renders an id="principles" heading next door.
actual_ids=$(grep -o 'id="principle-[0-9][0-9]*"' "$homepage" \
  | grep -o '[0-9][0-9]*' | sort -n | tr '\n' ' ')
expected_ids=$(i=1; while [ "$i" -le "$principle_total" ]; do printf '%s ' "$i"; i=$((i + 1)); done)

if [ "$actual_ids" != "$expected_ids" ]; then
  echo "FAIL: principle anchors do not match the $principle_total numbered rules in $spec_source"
  echo "      expected: $expected_ids"
  echo "      actual:   $actual_ids"
  fail=1
fi

# Each anchored rule links to itself and carries the shared header-anchor class,
# which is what supplies the inherited text color and the pilcrow affordance
# (SPEC-001 §Element Styling). Without these the ids above are still emitted, so
# the deep link and its visible affordance can regress while the checks pass.
selflink_count=$(grep -o 'href="#principle-[0-9][0-9]*"' "$homepage" | wc -l | tr -d ' ')
if [ "$selflink_count" -ne "$principle_total" ]; then
  echo "FAIL: expected $principle_total principle self-links, found $selflink_count"
  fail=1
fi

anchor_class_count=$(grep -o 'class="header-anchor principle-link"' "$homepage" | wc -l | tr -d ' ')
if [ "$anchor_class_count" -ne "$principle_total" ]; then
  echo "FAIL: expected $principle_total principle anchors on the header-anchor class, found $anchor_class_count"
  fail=1
fi

# Anchor hover affordance: the pilcrow marker reached the stylesheet, and it is
# gated behind the pointer-device query SPEC-001 §Rendering Rules commits to.
if ! grep -q "content: '¶'" "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: anchor pilcrow marker not found in stylesheet"
  fail=1
fi

if ! grep -q '@media (hover: hover)' "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: pilcrow is not gated behind a pointer-device media query"
  fail=1
fi

# The keyboard trigger is a separate rule from the hover one so that it survives
# on devices without hover. This catches the rule going missing; that it sits
# outside the media query is checked by hand (SPEC-001 §Rendering Rules).
if ! grep -q '\.header-anchor:focus-visible::after' "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: pilcrow has no keyboard-focus trigger"
  fail=1
fi

# Link treatment (SPEC-001 §Element Styling, ADR-005). The absence of visited
# styling is the invariant worth pinning: reintroducing it is a one-line edit
# whose effect reaches the prose links and needs suppressing in three other
# places, so it is the kind of thing that comes back by accident.
if grep -q ':visited' "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: stylesheet contains a :visited rule — links are not distinguished by visited state"
  fail=1
fi

link_token_count=$(grep -c -- '--link-color:' "$OUTPUT_DIR/css/style.css" || true)
if [ "$link_token_count" -lt 2 ]; then
  echo "FAIL: --link-color is not resolved per theme (found $link_token_count definition(s), expected a light and a dark)"
  fail=1
fi

# The focus indicator answers to the same per-theme discipline (SPEC-001 §Color
# Palette). It is the control that tells a keyboard visitor where they are, so a
# value that only works against one background is a real loss on the other.
focus_token_count=$(grep -c -- '--focus-color:' "$OUTPUT_DIR/css/style.css" || true)
if [ "$focus_token_count" -lt 2 ]; then
  echo "FAIL: --focus-color is not resolved per theme (found $focus_token_count definition(s), expected a light and a dark)"
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

# Dark mode support (data-theme override block in stylesheet)
if ! grep -q '\[data-theme="dark"\]' "$OUTPUT_DIR/css/style.css"; then
  echo "FAIL: dark mode [data-theme=\"dark\"] block not found in stylesheet"
  fail=1
fi

# Theme slider control rendered on the homepage
if ! grep -q 'theme-slider' "$homepage"; then
  echo "FAIL: theme slider control not found in homepage"
  fail=1
fi

# Inline head script that sets the theme before first paint (no-flash guarantee)
if ! grep -q 'dataset.theme' "$homepage"; then
  echo "FAIL: inline theme-init head script not found in homepage"
  fail=1
fi

# Persistence contract: the theme choice is saved so it survives reloads and
# navigation between pages (SPEC-001 §Theme Toggle, ADR-003). This guards the
# load-bearing "the choice is remembered" invariant.
if ! grep -q 'localStorage' "$OUTPUT_DIR/js/theme.js"; then
  echo "FAIL: theme code does not persist the choice (no localStorage use)"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "PASS: rendering rules verified."
