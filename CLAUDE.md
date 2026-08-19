# Documentation lookups

Check documentation for any library, framework, SDK, API, CLI tool, or cloud
service through the Context7 MCP. This applies even when the answer seems known.

1. Resolve the library with `mcp__claude_ai_Context7__resolve-library-id`.
2. Fetch with `mcp__claude_ai_Context7__query-docs`.
3. Fall back to `WebSearch` only when Context7 returns no entry for the library,
   or no entry for the required version. State which of the two occurred.

Never answer a documentation question from memory.

# Code comments

Never add a comment that restates what a well-named field, method, or
variable already says. Prefer a clearer name, a smaller function, or an
extracted variable over a comment.

When something is genuinely non-obvious — a subtle correctness gotcha, a
known limitation, a "why not the naive approach" justification — record it
in the project's docs, not as an inline comment: a per-module reference doc,
an architecture doc, a gotchas/constraints file, or an Open Knowledge Format
(OKF) bundle if the project has one — write the concept doc directly,
following the bundle's existing conventions. If the project keeps no such
doc and has no OKF bundle, start one with the `okf` skill rather than
defaulting to a comment.
