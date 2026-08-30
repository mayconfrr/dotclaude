---
name: okf
description: "Use when asked to set up, introduce, bootstrap, or adopt OKF (Open Knowledge Format) in a project — scaffold a docs/ knowledge bundle, stand up an agent-maintained knowledge graph as versioned markdown concepts, or give agents durable repo knowledge in git as an alternative to Serena memories or a wiki. Generic — not scoped to one project. Keywords: OKF, Open Knowledge Format, knowledge bundle, docs/, concept, index.md, log.md, stale_after, freshness, provenance."
---

# Introduce OKF to a project

OKF (Open Knowledge Format) represents durable repo knowledge as plain markdown
files with YAML frontmatter, organized as a **bundle**: a git-versioned tree of
concepts that agents and humans both read and maintain. This skill stands up that
bundle in any project and the loop that keeps it fresh.

Spec: OKF v0.2 — https://github.com/GoogleCloudPlatform/open-knowledge-format.
Full concept format: `references/okf-format.md` (read it before authoring).

**Fire-and-forget:** run this end to end with sensible defaults — don't stop to
ask. Infer the layout from the repo, scaffold, read the whole project to author
the base bundle, wire the hooks, and install a curation skill. The two calls that
could surprise or be destructive — touching a competing knowledge system, and
committing — are *reported*, not performed, so the run needs no decisions from
the user.

## Why OKF (and when to prefer it)

- Knowledge lives in git beside the code — versioned, diffable, reviewed in PRs.
- Trust, provenance, and freshness are first-class frontmatter signals.
- No SDK, runtime, or database; anyone (human or agent) produces and consumes it.

Prefer it when you want repo knowledge that ships in the repo. For LSP-backed
symbolic tools plus agent-only memories instead, see the `serana` skill — the two
solve overlapping problems; pick one canonical home (step 6).

## Procedure

1. **Decide the bundle root and layout.**
   - Default root `docs/`; use a dedicated `knowledge/` only if `docs/` is
     already taken by unrelated tooling.
   - Mirror the repo's real structure: one top-level dir per component /
     subproject / domain, plus a cross-cutting dir (`shared/`) for knowledge that
     spans them. Split a component by surface only when it has distinct audiences
     (e.g. backend modules vs. frontend features).
   - The tree is for humans; cross-links carry the real relationships, so the
     bundle can reflect a many-to-many system, not just the folder hierarchy.

2. **Scaffold the reserved files.**
   - Root `index.md` with frontmatter `okf_version: "0.2"`, listing the areas.
   - Root `log.md` (date-grouped changelog, newest first).
   - An `index.md` in each area dir. `index.md` and `log.md` are the only
     reserved filenames; every other `.md` is a concept.

3. **Learn the concept format.** Read `references/okf-format.md`: frontmatter
   fields, actor convention, cross-linking, freshness rules, index/log formats,
   conformance.

4. **Read the whole project and author the base bundle.** This is the point of
   introducing OKF — don't just scaffold an empty tree. Explore the codebase
   comprehensively (for a large repo, dispatch a subagent per component in
   parallel) to find the high-signal knowledge — cross-component contracts,
   integration seams, non-obvious rationale, domain vocabulary, playbooks — and
   author a verified concept for each, cross-linked to mirror the real
   dependencies. **Verify every claim against the code before writing it** —
   never propagate an inherited doc's assertion unchecked — and capture only what
   a reader can't get from the code itself (see *What belongs*). This populated
   base is what makes OKF immediately useful; it grows from here.

5. **Wire the freshness loop** — this is what keeps the bundle from rotting.
   Two halves, each backed by a Claude Code hook (exact config in
   `references/hooks.md`):
   - **Read-before** → a `SessionStart` hook reminds the agent to read the
     relevant `docs/<area>/` concepts before editing that area.
   - **Update-after** → a `Stop` (end-of-turn) hook nudges when code changed
     without a matching `docs/` change: update the concept, bump `generated.at`,
     refresh `index.md`, append `log.md`.
   - **Cross-component:** if you change a contract others depend on, follow the
     inbound links and update the callers' concepts too.
   Wire both hooks as part of setup — invoking this skill authorizes them (they
   only inject reminders, never block, and the user can remove them via `/hooks`).

6. **Install the curation skill (a baseline to adapt).** Copy the bundled
   `assets/curating-docs/` into the target's `.claude/skills/curating-docs/`, so
   the "what belongs / how to author a concept" judgment travels with the project
   and fires whenever someone documents something or is tempted to bury rationale
   in a comment. **It ships generic — treat it as a baseline and adapt it to this
   codebase**: add the project's domain vocabulary, its real `type` values, its
   area/module names, and any project-specific capture/skip calls, so it reflects
   the project rather than a template.

7. **Detect competing knowledge homes — report, don't act.** If the project
   already routes durable rationale elsewhere (a wiki, inline comments, Serena
   memories), do **not** migrate or delete it automatically — that choice is
   destructive and project-specific. Flag it in the report with a recommendation
   to pick one canonical home, and leave it for the user.

8. **Leave it staged; don't commit.** Stage the new files for the user to commit —
   committing is theirs to do. Confirm no secrets or machine-specific absolute
   paths in concepts. If the project deliberately gitignores its docs tree, note
   it and pick a tracked root instead — an untracked bundle loses git as its
   provenance layer.

9. **Report:** bundle root + layout, files scaffolded, concepts authored, hooks
   added, the curation skill installed, any competing knowledge home detected
   (with a recommendation), and that the files are staged for the user to commit.

## What belongs (capture vs skip)

Capture what a reader would otherwise reverse-engineer or ask a teammate about:
cross-component contracts & integration seams, "why not the naive approach",
gotchas and constraints, domain vocabulary, operational playbooks, architectural
decisions.

Skip what the code already states plainly, anything derivable by reading the
file, a concept that only restates a well-named symbol, and transient task notes.

Split concepts by trust and freshness — each carries its own `verified` and
`stale_after`, so a volatile config and a stable rule belong in separate,
linked concepts.

## Optional tooling

OKF ships a reference **enrichment agent** (drafts concepts from a data source)
and a static HTML **graph visualizer** (browsable concept graph). Both optional;
neither is needed to stand a bundle up.

## Grounding

Format is OKF v0.2 (spec above). The curation heuristics here are conventional
best practice — OKF is deliberately minimally opinionated about *what* to
document, so this skill supplies that judgment.
