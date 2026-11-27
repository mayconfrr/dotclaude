# Spec sections — section-by-section guidance

Loaded from the Visual spec recipe when you build one of these sections.

User stories and success metrics usually belong in the [stakeholder companion](stakeholder-companion.md);
use them in the technical spec only when it needs them.

## Non-Goals

3-5 things the change explicitly will **not** do. Each names the adjacent capability excluded and,
in a few words, why — low impact, too complex, a separate initiative, premature, or v2+.

- When a request implicitly drags in something out of scope, surface it here — not as a TODO.
- Revisit them at each review-loop pass; scope shifts, but the shift gets written down.
- Example: "Export to CSV — deferred (v2+), low demand, adds maintenance without core value."

## Prioritized requirements (P0 / P1 / P2)

Categorize every requirement. Be ruthless about P0.

| Tier | Label | Test |
|---|---|---|
| **P0** | Must-have | "If we cut this, does it still solve the core problem?" No → P0. |
| **P1** | Nice-to-have | Materially better, but the core use case works without it. Fast-follow material, not a wish list. |
| **P2** | Future | Out of scope for v1, but the design should not foreclose it. Architectural insurance. |

## Acceptance criteria

Checkable, per case. Two formats — pick per criterion:

**Given / When / Then** — for behavior with a precondition:
- Given [precondition/context] · When [user action] · Then [expected outcome]

**Checklist** — for a set of discrete, independently-true facts:
- [ ] Admin can enter the SSO provider URL in org settings
- [ ] A failed SSO attempt shows an error message that names the cause

Rules:
- Cover happy path, error cases, and edge cases — and state what must **not** happen (negative cases).
- Specify behavior, not implementation. Each criterion independently testable.
- Ban ambiguous words — "fast", "user-friendly", "intuitive" — define them concretely or cut them.

## Gates

A page section, not a file: the behavior to implement, worded like a Gherkin feature so a reader sees each gate the change must pass. Show it as a `gherkin` code block in the page and copy it into the issue as is.

- One `Scenario` per gate; `Scenario Outline` + `Examples` when only the values change; `Background` for shared preconditions.
- Domain words the reader knows, real values from the spec, no UI selectors, endpoints or class names in the steps.
- Same STE rules as the criteria; tag each scenario with its priority.
- When every acceptance criterion is a scenario here, this section replaces the criteria list.

```gherkin
Feature: SSO login
  @P0
  Scenario: Member is sent to the org's SSO provider
    Given SSO is configured for the org
    When a member opens the login page
    Then the member is redirected to the org's SSO provider
```

## Success metrics (when the spec carries them)

Only when the change has a measurable outcome the reader will track; a pure mechanism change often
has none — don't manufacture one.

- **Leading** (days–weeks): adoption, activation, task-completion, error rate, usage frequency.
- **Lagging** (weeks–months): retention, revenue, satisfaction/NPS, support-ticket reduction, win rate.
- Targets are specific — "50% adoption within 30 days", not "high adoption" — with a measurement
  method and an evaluation window. Set a success threshold, and a stretch target only if the request gives one.

## User stories (multi-persona or companion only)

Skip for a single-mechanism technical change. Use when the change serves distinct personas, or in the
companion. Format: "As a [specific user type], I want [capability] so that [benefit]" — the type
specific ("enterprise admin", not "user"), the capability a goal not a UI widget, the benefit the why.
Order by priority; include error/empty/boundary states. Avoid stories that are too large or internally framed ("we want to
refactor the DB" is a task, not a story).
