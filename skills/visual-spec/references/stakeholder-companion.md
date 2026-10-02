# Stakeholder companion recipe

How to build the stakeholder-facing companion — loaded only when Process step 7 fires.

Its reader is a decision-maker who will never open the repo — product, operations, a sponsor — who must be able to **approve, prioritize, or veto and be right about it**, without code. "Lacks implementation detail" is not "vague": every decision-relevant fact from the technical spec must survive, translated out of code terms. Under-detailing, not over-detailing, is the failure mode.

A **PDF summary**, never an Artifact. The first pass is ASD-STE100 English per [ste.md](ste.md). Aim for two pages of A4 portrait, three at most for a large change. Build it as self-contained, print-styled HTML and render that to PDF with headless Chromium, so the SVG stays vector (the `pdf` skill builds PDFs with reportlab, not from HTML; use it to inspect the result). Treat it as paper: `@page` A4 with margins, a light theme only, body text of 10 to 11 pt, `break-inside: avoid` on the diagram, table rows and decision blocks (not on a whole table), and no sidebar or interactive elements. Let `artifact-design` calibrate the treatment: calm and text-forward, not dashboard-dense. Load fonts from Google Fonts at render time, so the render needs network access. Static fonts embed as TrueType and variable fonts embed as Type3 glyphs. Both stay selectable.

Include, scaled to the change:

- **Source request, verbatim** — the same anchor as the technical spec.
- **Plain-language framing.** What the thing is, in the domain's own vocabulary; define the one or two terms the decision actually hinges on. Don't assume the reader knows the internal system names.
- **Impact — why it matters.** The size and cost of the problem, in whatever evidence already exists (support-ticket volume, a metric, user research, the request's own framing) — what a sponsor weighs to prioritize. Carry the evidence through; never manufacture research the spec doesn't have — absent that, say the request asserts the impact and nobody measured it.
- **The change, in behavior terms.** The *same cases* the technical spec itemizes, described by what becomes different for a user, an operator, or the data. A behavior table (per case → what happens) usually carries this best.
- **Mechanism diagram** (`diagram-design`, Audience `executive`, embedded as SVG with light-theme tokens) — the same flow and the same accent nodes as the technical diagram (nodes may merge), but boxes named for business roles (systems, queues, actions, people), **never** class / file / method / config names. Highlight the same delta.
- **What it will and won't do.** Explicit boundaries. The "won't" list prevents false expectations and is frequently the real crux of the decision — state it plainly.
- **Before / after, or side-by-side** with whatever it mirrors or replaces, so the delta is visible at a glance.
- **Decision-relevant tradeoffs, dependencies, and risk.** What this relies on from other teams or systems, what could go wrong, what stays open. Carry the technical spec's **Pending/Discovery** and **Open decisions** across in plain terms — the stakeholder frequently owns exactly these.
- **Success metrics and user stories, when the change has them.** Leading/lagging indicators with targets, and per-persona stories — the lens this reader thinks in. See [spec-sections.md](spec-sections.md); include only when they inform the decision, not as boilerplate.

Exclude anything that only matters to whoever writes the code — code, config, `file:line`, class/method names, internal identifiers. The discriminator: a fact that only guides implementation is out; a fact that changes the decision stays, however technical.

**Litmus test:** a reader who will never see the repo can say "yes", "no", or "change X" — and be correct — from this PDF alone. If a likely objection or question can't be answered from the PDF, it's missing a decision-relevant fact.

**Consistency check.** Before handing it over, reconcile the companion against the technical spec fact by fact — ids, names, values, per-case outcomes, dependencies, what's in and out of scope. Omitting or generalizing an implementation detail is expected (that's the point); stating a fact that *disagrees* is a bug. On a mismatch, fix the companion, never the spec — the spec is the source of truth. The one exception: if the check exposes a genuine error in the technical spec, correct the spec first (and re-confirm with the user), then re-derive the companion.

**Render check.** Render the PDF and open it. Confirm three things: the page count is within the target above, the diagram is whole on one page (not split or clipped), and the text is selectable. Run the STE check from [ste.md](ste.md).
