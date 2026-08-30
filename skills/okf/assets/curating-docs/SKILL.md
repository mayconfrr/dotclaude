---
name: curating-docs
description: "Use when deciding whether something belongs in the project's docs/ OKF knowledge bundle, when authoring or updating a concept there, when a SessionStart or Stop hook nudges you to consult or update docs/, or when you're about to bury non-obvious rationale in an inline comment. Keywords: OKF, knowledge bundle, concept, docs/, what to document, freshness, generated.at, stale_after, cross-link, integration."
---

# Curating docs

`docs/` is this project's OKF knowledge bundle — a git-native graph of markdown
concepts. Full concept format: the OKF v0.2 spec
(https://github.com/GoogleCloudPlatform/open-knowledge-format); `docs/README.md`
states the read/update loop.

The bundle is only worth reading if it holds signal: **document what a reader
can't get from the code itself, and skip what it already states plainly.**

## The decision: capture or skip

Ask: would a competent engineer be surprised by this, or have to reconstruct it
from the code? If yes, capture it. If they'd learn it by reading the file, skip it.

| Capture — durable & non-obvious | Skip — noise or derivable |
|---|---|
| Cross-component contracts & integration seams | What the code already says plainly |
| "Why not the naive approach" — non-obvious rationale | Anything you'd learn by reading the file |
| Gotchas, constraints, sharp edges | A concept that only restates a well-named symbol |
| Domain vocabulary | A value that lives in one obvious place |
| Playbooks & architectural decisions | Transient task state or one-off notes |

Borderline? Add a linked line to an existing concept rather than a new file.

## Granularity

One concept per asset or idea. Split when trust or freshness differ — each
concept carries its own `verified` and `stale_after`, so a volatile config and a
stable rule don't share a file. Link them instead.

## Authoring a concept

Frontmatter + a structural body (headings, tables, fenced blocks — not prose):

- `type` (required) + `title`, `description`, `tags`; `resource` if there's an
  underlying asset (repo path, console URL, endpoint).
- Freshness: `generated: { by, at }` (actor: `human:<id>` or `<agent>/<version>`);
  add a `verified` entry on human confirmation; `stale_after` on volatile
  concepts; `status: draft` when documenting something not yet in the code.
  Timestamps (`at`, `stale_after`) are full ISO-8601 datetimes with a UTC offset
  (`2026-08-28T14:00:00Z`), never a bare date.
- Cross-links: bundle-relative paths (`/area/concept.md`) for real dependencies,
  also recorded in `sources`; the prose says the relationship (invokes / reads
  config from / provisioned by).

See the OKF spec for the full field list.

**Example — an inline comment becomes a concept.** Instead of burying a
"why we do it this non-obvious way" comment at a call site, author
`docs/<area>/<name>.md` that states the rationale, links the contract it depends
on via `sources`, and carries a `generated.at` date — none of which a comment
gives you.

## The loop

Read the relevant concept before editing an area; update it in the same change
(bump `generated.at`, refresh the area's `index.md`, append `log.md`). If you
change a contract others depend on, follow the inbound links and update the
callers' concepts too. The `SessionStart` / `Stop` hooks nudge both halves.

## Common mistakes

| Mistake | Fix |
|---|---|
| Documenting what the code already says | Delete it; a good name is the doc. |
| A new file for a borderline fact | Add a linked line to an existing concept. |
| One concept mixing a stable rule and a volatile config | Split by trust/freshness. |
| Updating the body but not `generated.at` | Bump it — it's the freshness signal. |
| Leaving a cross-component dependency implicit | Make it a bundle-relative link + `sources`. |
| Writing prose paragraphs | Use headings, tables, lists — concepts are scanned. |

## Red flags — stop and reconsider

- "I'll add a comment explaining why…" → it's a concept, not a comment.
- "This is obvious from the code but I'll document it anyway" → skip it.
- "I'll put everything about X in one big file" → split by trust/freshness.
- "I changed the code, docs can wait" → update in the same change.
