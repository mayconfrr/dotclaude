# Spec sections — section-by-section guidance

Loaded from the Visual spec recipe when you build one of these sections — each below matches a
section named there.

The PM-framing sections — user stories, success metrics — usually belong in the
[stakeholder companion](stakeholder-companion.md), not the technical spec; use them here only when
the technical spec itself needs them. Adapted from `anthropics/knowledge-work-plugins`
(`product-management/write-spec`), retargeted from a product PRD to a code-grounded implementation spec.

## Non-Goals

3-5 things the change explicitly will **not** do. Each names the adjacent capability excluded and,
in a few words, why — low impact, too complex, a separate initiative, premature, or v2+.

- When a request implicitly drags in something out of scope, surface it here — not as a TODO.
- Revisit them at each review-loop pass; scope shifts, but the shift gets written down.
- Example: "Export to CSV — deferred (v2+), low demand, adds maintenance without core value."

## Prioritized requirements (P0 / P1 / P2)

Categorize every requirement. Be ruthless about P0 — a tighter must-have list ships and teaches faster.

| Tier | Label | Test |
|---|---|---|
| **P0** | Must-have | "If we cut this, does it still solve the core problem?" No → P0. |
| **P1** | Nice-to-have | Materially better, but the core use case works without it. Fast-follow material, not a wish list. |
| **P2** | Future | Out of scope for v1, but the design should not foreclose it. Architectural insurance. |

"If everything is P0, nothing is P0" — challenge each must-have: would we really not ship without it?
(MoSCoW maps onto this: Must→P0, Should/Could→P1, Won't-this-time→P2 or a Non-Goal.)

## Acceptance criteria

Checkable, per case. Two formats — pick per criterion:

**Given / When / Then** — for behavior with a precondition:
- Given [precondition/context] · When [user action] · Then [expected outcome]
- e.g. Given SSO is configured for the org · When a member hits the login page · Then they're redirected to the org's SSO provider.

**Checklist** — for a set of discrete, independently-true facts:
- [ ] Admin can enter the SSO provider URL in org settings
- [ ] A failed SSO attempt shows a clear error message

Rules:
- Cover happy path, error cases, and edge cases — and state what must **not** happen (negative cases).
- Specify behavior, not implementation. Each criterion independently testable.
- Ban ambiguous words — "fast", "user-friendly", "intuitive" — define them concretely or cut them.
- Optional: a live checklist reviewers tick via `artifact-capabilities` — keep a static twin.

## Success metrics (when the spec carries them)

Only when the change has a measurable outcome the reader will track; a pure mechanism change often
has none — don't manufacture one. The stakeholder companion is the usual home for these.

- **Leading** (days–weeks): adoption, activation, task-completion, error rate, usage frequency.
- **Lagging** (weeks–months): retention, revenue, satisfaction/NPS, support-ticket reduction, win rate.
- Targets are specific — "50% adoption within 30 days", not "high adoption" — with a measurement
  method and an evaluation window. Set a success threshold and a stretch target. Route any chart
  through `dataviz`.

## User stories (multi-persona or companion only)

Skip for a single-mechanism technical change. Use when the change serves distinct personas, or in the
companion. Format: "As a [specific user type], I want [capability] so that [benefit]" — the type
specific ("enterprise admin", not "user"), the capability a goal not a UI widget, the benefit the why.
Order by priority; include error/empty/boundary states.

Good stories are **INVEST**: Independent, Negotiable, Valuable, Estimable, Small, Testable. Common
misses: too vague, solution-prescriptive ("a dropdown"), no benefit, too large, or internally framed
("we want to refactor the DB" — that's a task, not a story).
