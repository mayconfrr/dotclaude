---
name: visual-spec
description: Use when turning a stakeholder request, feature ask, bug, or rough requirements into a detailed, implementation-ready spec — especially when it will be opened as a GitHub issue. Trigger on "write a spec for", "create an issue for this request", "brainstorm and create an issue", "turn this into something a dev can implement/pick up", "make a visual spec", or any request to produce an implementable spec from a request, even when a visual artifact or these exact words aren't used.
---

# Visual Spec

## Overview

Turn a request into an **implementation-ready spec, presented as a designed, diagrammed Artifact**. The finished spec is self-contained: a fresh `/implement` session (or a teammate) must be able to pick it up cold and build the thing without re-interviewing anyone. Skip this skill when the change is already approved and unambiguous (just build it), or when the user wants a throwaway answer, not a durable spec.

## The toolchain (which skills, and when)

| Skill | When | Role |
|---|---|---|
| `superpowers:brainstorming` | **Always, first** | Process step 1. |
| `artifact-design` | **Always, before writing the artifact** | Calibrate treatment and build the page with real hierarchy, palette, both themes. |
| `diagram-design` | **Always** (a spec has a mechanism) | Draw the mechanism the reader would otherwise assemble from prose. See "Diagrams". |
| `dataviz` | **If** the spec carries a KPI or metric row, a hero number, or a chart with 3+ equally weighted series | Validated palette, tooltips, table view. Every other chart (bar, line, Gantt, waterfall, funnel…) is a `diagram-design` type. Don't hand-roll chart colors. |
| `artifact-capabilities` | **Only if** the spec benefits from a live element the reader uses in place of the doc (a persisted acceptance-criteria checklist reviewers tick, a sign-off) | Keep a static twin so the issue version loses nothing. |

If `artifact-design` or the Artifact tool is unavailable, write the spec as one self-contained, full HTML document (CSS variables for light and dark, inline SVG), save it locally, and tell the user its path. The issue then has no artifact link.

## Language

Write the first pass of the spec and of the stakeholder PDF in ASD-STE100 Simplified Technical English. Read `references/ste.md` before you write. Translate later, on request, from the STE text.

## Diagrams

Load the plugin as `diagram-design:diagram-design`. Set the four dials from its `references/output-spec.md`. For the technical spec use Format `html`, Size `doc-inline`, Detail `balanced`, Audience `engineer`. For the stakeholder PDF use Audience `executive` and Size `fit` at about 720 px wide, so node names print at 8 pt or larger on A4. Draw nine nodes or fewer, and split a bigger flow into two diagrams. Generate the SVG with CSS classes, not literal hex colors. The plugin template defines `--color-paper`, `--color-ink`, `--color-muted` and `--color-accent`. Map them to the page's theme tokens in both themes, and define any extra token (a soft fill, a rule, a tint) yourself from those. Do not run the plugin's onboarding: it rewrites the plugin's own `style-guide.md`. Apply the page palette in your output and do not ask the user. Check each standalone diagram file with the skill's `scripts/self_check.py`, then embed its `<svg>` in the page. If the plugin is missing, say so and draw the diagram by hand as inline SVG.

## Process

1. **Brainstorm** (`superpowers:brainstorming`), before any exploration or writing. Classify (spike / bounded / architectural), understand purpose and constraints, surface approaches, agree on the shape of the deliverable.
2. **Ground it in the real codebase.** Explore the actual modules and quote `file:line`. **Verify mechanisms in code before you write them down** — do not take the request's framing at face value. Requests describe *intent*; the code describes *reality*, and they diverge (one term in the request may map to two different mechanisms in the code; a field or value the request assumes exists may not; a constant in one place may have drifted from its source of truth). Dispatch a search agent for breadth when the surface is large. (Skip only when there is genuinely no codebase yet — a greenfield project — and say so.)
3. **Hunt gaps and ask** — see the discipline below.
4. **Build the visual spec** as an Artifact, following the recipe below.
5. **Review loop.** Send the link, take feedback, **republish to the same URL** as facts firm up.
6. **Get explicit approval.** Nothing ships until the user approves the spec. Present the artifact and wait for a clear yes — a sub-question answered or "looks good so far" is not approval of the whole spec.
7. **Stakeholder companion (on approval, when there's an audience for it).** Once the spec is approved, if the change has a non-implementer audience — product, operations, a sponsor who needs to weigh in — produce a **stakeholder-facing PDF summary** per `references/stakeholder-companion.md` (read it now). Hand over the PDF file path together with the spec link. For an internal-only change with no such audience, skip this — don't manufacture a reader who isn't there.
8. **Open the GitHub issue** — see Shipping.

## Gap discipline (the heart of this skill)

Before building the deliverable, write down every unknown the spec depends on — IDs, field/column names, payload formats, exact names, enum values, mechanism questions, "does X exist?", ownership, edge-case behavior — and **put them to the user.** The user very often has the answer on hand (an ID, a config value, a payload sample); asking turns a `<TBD>` into a real value in one message.

**A spec is done only when every gap is filled or explicitly left open by the user.** "I don't know yet," "leave it," "that's a discovery item," "confirm later" — those are explicit. Silence is not. Your own judgment that a gap is "probably fine to defer" is not.

When a gap stays open by the user's choice, mark it as such in the spec (a **Pending / Discovery** item with what's blocked on it), distinct from **Confirmed** values and from **Open decisions** the user still needs to make.

### Rationalizations — all false

| Excuse | Reality |
|---|---|
| "I'll put a placeholder and note it as TBD." | A silent TBD reads as finished. Ask first; only the user turns it into a deferred item. |
| "The implementer can figure the ID out." | They can't — it lives in an external system the user can see and they can't. One question saves a blocked PR. |
| "It's obvious from context." | Mix-ups feel obvious until they ship. Confirm the specific value. |
| "Asking is slower than just writing it." | Writing on a wrong assumption is slower — you rewrite the spec and the code. |
| "I'll assume the common case." | Assumptions are how the two-mechanism / wrong-field-name bugs get baked in. Verify in code, then ask. |
| "The request already says what to do." | The request states intent; it omits the values and is sometimes wrong about the mechanism. Ground and ask. |

### Red flags — STOP and ask

- You're about to type `<TODO>`, `<TBD>`, `<ID_...>`, `XXX`, or "to be confirmed" and the user hasn't said to defer it.
- You're writing an enum/ID/field name you inferred rather than confirmed.
- You caught yourself thinking "they probably mean…".
- You're describing a mechanism you read *about* (docs, the request) but didn't confirm in the *code*.

All of these mean: list the gap, ask the user, wait for the answer.

## Visual spec recipe

Author as HTML per `artifact-design` (never Markdown as a shortcut past the design pass). Scale sections to the work; a small change doesn't need all of them. Non-Goals, prioritized requirements, acceptance criteria and, when the spec carries them, success metrics and user stories have a required shape: read `references/spec-sections.md` when you build them. A typical implementation-ready spec has:

- **Source request, verbatim.** The stakeholder/user's exact words, quoted, marked as the source of truth. Everything else derives from it.
- **Metadata strip.** Surface (backend/frontend/config), modules touched, dependencies, scope at a glance.
- **Current state, grounded.** How it works today, with `file:line` references and the mechanism distinctions that matter. This is where code-grounding pays off.
- **Mechanism diagram(s)** (`diagram-design`). Draw the flow, the data that moves, the thing that changes — highlight the delta in one accent color. Label the arrows.
- **The change, itemized.** Per feature / case / rule: exact behavior, the config or code that expresses it, and the real values. Tag each item P0 / P1 / P2.
- **Non-Goals.** Out-of-scope items, each with why — the boundary that keeps scope from creeping.
- **Config / code shapes.** Concrete blocks with real names and values (not placeholders).
- **Acceptance criteria.** Checkable, per-case — Given/When/Then or checklist, covering error and negative cases.
- **Confirmed values** vs **Pending/Discovery** vs **Open decisions** — three distinct buckets (see gap discipline); tag each open item with its owner (eng / design / product / legal).

**Section sidebar.** Give the page a sidebar of section shortcuts, unless the spec has three sections or fewer. Use plain anchor links to each section `id`, with short labels that mirror the headings, and `scroll-margin-top` on the element that carries the `id`, so a jump clears the page edge. The sidebar is sticky on wide screens. At phone width it collapses to an "On this page" disclosure that stays sticky and opens as an overlay, so closing it does not shift the page. There is no horizontal scroll. Use two nav blocks if the disclosure cannot stay open on wide screens without JavaScript. Highlighting the current section (an `IntersectionObserver`) is optional, and the links must work without JavaScript. Use smooth scrolling only under `prefers-reduced-motion: no-preference`. The GitHub issue carries the spec text, so it has no sidebar.

## Shipping

The issue is the spec's durable record; write no markdown file. Open it once step 7, if it applies, is done. Open it ready-for-review (not draft). Check for an issue/PR template and mirror its headings. Bake **confirmed values** in; keep Pending/Open buckets visible so `/implement` knows what's still blocked. Link the artifact. The issue must stand alone — a cold reader implements from it without this conversation.
