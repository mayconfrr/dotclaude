# Stakeholder companion recipe

How to build the stakeholder-facing companion — loaded only when Process step 7 fires (see there
for when this applies).

Its reader is a decision-maker who will never open the repo — product, operations, a sponsor. The job is to let them **approve, prioritize, or veto and be right about it**, without code. "Lacks implementation detail" is not "vague": every decision-relevant fact from the technical spec must survive, translated out of code terms — under-detailing, not over-detailing, is the failure mode, since a stakeholder who can't tell what actually changes can't give real approval.

A **separate** Artifact, in the stakeholders' language (default to the project/request's). Unlike the technical spec — where design barely matters — give it a calm, considered treatment: inherit the design system in `DESIGN.md` (in this directory) — which prefers the `impeccable` skill when available, with a Read-mode fallback.

**Format.** Ask how the stakeholder needs to receive it — a published **Artifact** (a live, theme-aware link, but the recipient may need Claude access to open it) or a **PDF** (portable, opens anywhere; pick this when it goes to someone outside the Claude team), or both. For a PDF, render the same HTML companion to PDF (via the `pdf` skill or headless Chromium) so it matches the page exactly.

Include, scaled to the change:

- **Source request, verbatim** — the same anchor as the technical spec.
- **Plain-language framing.** What the thing is, in the domain's own vocabulary; define the one or two terms the decision actually hinges on. Don't assume the reader knows the internal system names.
- **The change, in behavior terms.** The *same cases* the technical spec itemizes, described by what becomes different for a user, an operator, or the data — with the config/code that expresses each case removed. A behavior table (per case → what happens) usually carries this best.
- **Mechanism diagram** (`artifact-diagramming`) — the same flow as the technical diagram, but boxes named for business roles (systems, queues, actions, people), **never** class / file / method / config names. Highlight the same delta.
- **What it will and won't do.** Explicit boundaries. The "won't" list prevents false expectations and is frequently the real crux of the decision — state it plainly.
- **Before / after, or side-by-side** with whatever it mirrors or replaces, so the delta is visible at a glance.
- **Decision-relevant tradeoffs, dependencies, and risk.** What this relies on from other teams or systems, what could go wrong, what stays open. Carry the technical spec's **Pending/Discovery** and **Open decisions** across in plain terms — the stakeholder frequently owns exactly these.
- **Success metrics and user stories, when the change has them.** Leading/lagging indicators with targets, and per-persona stories — the lens this reader thinks in. See [spec-sections.md](spec-sections.md); include only when they inform the decision, not as boilerplate.

Exclude anything that only matters to whoever writes the code — code, config, `file:line`, class/method names, internal identifiers. The discriminator: a fact that only guides implementation is out; a fact that changes the decision stays, however technical.

**Litmus test:** a reader who will never see the repo can say "yes", "no", or "change X" — and be correct — from this artifact alone. If a likely objection or question can't be answered from the page, it's missing a decision-relevant fact.

**Consistency check.** Before handing it over, reconcile the companion against the technical spec fact by fact — ids, names, values, per-case outcomes, dependencies, what's in and out of scope. Omitting or generalizing an implementation detail is expected (that's the point); stating a fact that *disagrees* is a bug. On a mismatch, fix the companion, never the spec — the spec is the source of truth. The one exception: if the check exposes a genuine error in the technical spec, correct the spec first (and re-confirm with the user), then re-derive the companion.
