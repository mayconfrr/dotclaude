# OKF v0.2 concept format (reference)

The concept format for an OKF bundle. Authoritative spec:
https://github.com/GoogleCloudPlatform/open-knowledge-format/blob/main/SPEC.md.
This file is the working subset needed to author and maintain a bundle.

## Contents
- [Bundle layout](#bundle-layout)
- [Concept anatomy](#concept-anatomy)
- [Frontmatter fields](#frontmatter-fields)
- [Actor convention](#actor-convention)
- [Cross-linking](#cross-linking)
- [Freshness rules](#freshness-rules)
- [index.md](#indexmd)
- [log.md](#logmd)
- [references/ convention](#references-convention)
- [Conformance](#conformance)

## Bundle layout

A bundle is a directory tree of markdown files, shipped in git. Reserved
filenames per directory: `index.md` (listing) and `log.md` (changelog); every
other `.md` is a concept.

```
<bundle-root>/            # e.g. docs/
├─ index.md               # carries okf_version: "0.2"
├─ log.md
├─ <component-a>/
│  ├─ index.md
│  ├─ <concept>.md
│  └─ references/          # mirrored external artifacts (optional)
├─ <component-b>/
└─ shared/                # cross-cutting concepts
```

Concepts cross-link across any directories (see below), so the graph can mirror
a many-to-many system rather than only the folder hierarchy.

## Concept anatomy

YAML frontmatter delimited by `---`, then a markdown body that favors headings,
tables, and fenced blocks over prose. Conventional body headings include
`# Schema` and `# Examples`.

## Frontmatter fields

| Field | Status | Meaning |
|---|---|---|
| `type` | **required** | Concept category. Self-chosen, descriptive, not centrally registered. Common values: `Service`, `Module`, `API Endpoint`, `Entity`, `Feature`, `Integration`, `Playbook`, `Convention`, `Glossary Term`, `API Reference`. Extend freely. Reserve `API Reference` for **mirrored external artifacts**; for in-repo code use `Module`/`API Endpoint`/`Entity`/`Service`. |
| `title` | recommended | Human display name; falls back to filename. |
| `description` | recommended | One sentence; used in `index.md` and search snippets. |
| `tags` | recommended | List of cross-cutting labels. |
| `resource` | optional | The underlying asset: a repo path, a console URL, an endpoint. Omit for abstract concepts. |
| `sources` | optional | List of `{ resource, title, author, last_modified }` the concept was derived from, including cross-component targets. |
| `generated` | recommended | `{ by, at }` — actor + ISO-8601 UTC of the last meaningful content change. Bump on every edit. |
| `verified` | optional | List of `{ by, at }` confirmations. A `human:` entry marks the concept human-reviewed. |
| `status` | optional | `draft` · `stable` (default) · `deprecated`. Deprecate, don't delete. |
| `stale_after` | optional | Absolute ISO-8601 instant. Consumers warn when `now >= stale_after`. Set on volatile concepts. |

Producers may add any extra keys; consumers preserve unknown keys and never
reject a concept for missing optional fields, unknown `type`, or broken links.

## Actor convention

For `generated.by` and `verified[].by`:
- `human:<id>` — people. The `human:` prefix is what marks a concept
  human-reviewed.
- `<producer>/<version>` — agents/tools, e.g. an agent id and model.
- `process:<id>` — automated processes.

## Cross-linking

- **Bundle-relative (preferred):** begins with `/` (relative to the bundle
  root), stable across moves — `[buyer lookup](/services/buyer-lookup.md)`.
- **Relative:** standard markdown — `[neighbor](./other.md)`.

Links are untyped directed edges; the surrounding prose conveys the relationship
(invokes / reads config from / provisioned by). Broken links are tolerated, so a
concept may point at a target that doesn't exist yet.

Path-valued fields (`resource`, `sources[].resource`) accept absolute URLs,
bundle-relative paths, or relative paths.

Per-claim attribution uses markdown footnotes keyed to a `sources[].id`:

```markdown
The call is synchronous by design.[^contract]
[^contract]: /services/buyer-lookup.md — invoked service contract
```

## Freshness rules

- A concept is **stale** when `now >= stale_after` — an absolute instant, plain
  comparison, no relative TTL.
- `generated.at` = last content change; `verified[].at` = a re-confirmation.
  They're independent: content can change without re-confirmation, and a fact can
  be re-confirmed without regeneration.
- Set `stale_after` on things that expire (integration configs, deploy steps,
  anything time-bound).
- All timestamp values (`generated.at`, `verified[].at`, `stale_after`) are
  ISO-8601 **datetimes with a UTC offset** (`2026-08-28T14:00:00Z`) — not bare
  dates.

## index.md

Lists a directory's concepts under headings, one bullet each with the concept's
description. Frontmatter is allowed **only** in the root `index.md`, to declare
the version:

```markdown
---
okf_version: "0.2"
---
# <Project> knowledge bundle

## Components
* [service-a/](service-a/) — one-line description
* [service-b/](service-b/) — one-line description

## Cross-cutting
* [shared/](shared/) — glossary, conventions, integrations
```

## log.md

Date-grouped, newest first, ISO dates, with `**Creation** / **Update** /
**Deprecation**` conventions:

```markdown
# Update log

## 2026-01-15
* **Update**: Revised [service-a](/service-a/index-concept.md); bumped generated.at.
* **Creation**: Established [service-b](/service-b/overview.md).
```

## references/ convention

A `references/` subdirectory inside an area mirrors external material as
first-class concepts (e.g. a vendor's API contract). A project's *own*
understanding of a third-party API is a normal `Integration` concept in the main
tree; the mirrored external artifact is an `API Reference` concept under
`references/` that the integration cites via `sources`. Mirror only when the
source is gated, unstable, or worth a pinned snapshot — otherwise just put its
URL in `sources[].resource`.

## Conformance

A bundle is conformant when every non-reserved `.md` parses as frontmatter +
body with a non-empty `type`, and the reserved files follow the structures
above. Consumers must not reject a bundle for missing optional fields, unknown
`type` values, unknown extra keys, broken links, or missing `index.md`.
