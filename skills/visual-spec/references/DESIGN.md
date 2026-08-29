# DESIGN — stakeholder companion

Design system for the **stakeholder companion** artifact (the technical spec stays utilitarian and
does not use this). Read-mode: built to carry a reader to a decision, calm and considered.

If the `impeccable` skill is installed, treat it as the authority: design in its **Read** mode, run
`polish`, and let its detector override anything here. This file is the inheritable system + the
fallback.

## Tokens

Define the light palette on bare `:root`; redefine under `@media (prefers-color-scheme: dark)`
(guarded `:root:not([data-theme="light"])`) and again under `:root[data-theme="dark"]`.

| Token | Light | Dark | Role |
|---|---|---|---|
| `--paper` | `#faf8f4` | `#16181b` | page ground (warm neutral — not beige-yellow, not gray) |
| `--surface` | `#ffffff` | `#1c1f23` | raised panels |
| `--tint` | `#f2efe8` | `#23262b` | quiet fill (pull-quotes, diagram boxes) |
| `--ink` | `#23262b` | `#ecebe6` | primary text |
| `--ink-soft` | `#565b63` | `#b2b3ad` | body / secondary |
| `--ink-faint` | `#8b8f97` | `#83868c` | labels, captions |
| `--rule` | `#e6e1d6` | `#2c2f34` | hairline dividers |
| `--rule-strong` | `#d5cfc0` | `#3c4046` | neutral box borders |
| `--accent` | `#1f6f5c` | `#5cb49c` | the known / common path — the one confident color |
| `--accent-soft` | `#e4efea` | `#182d28` | accent fill |
| `--delta` | `#ad5228` | `#d98a5f` | the change under discussion (warm clay) |
| `--delta-soft` | `#f5e7dd` | `#33241b` | delta fill |
| `--ok` | `#3f7d5c` | `#63b088` | success outcome |
| `--stop` | `#a8412f` | `#d97a68` | failure / "won't" |

One accent + one delta is the whole palette beyond ink and paper. No third hue.

## Type

- **Headings** — Newsreader (serif), weights 400/500/600, **never italic**. H1 `clamp(2.6rem, 6vw,
  3.9rem)`, line-height 1.05, weight 500. Standfirst: Newsreader 400, ~1.24rem, ~34ch.
- **Body / UI** — Public Sans, 400/500/600/700. Body line-height 1.65; reading column ~62ch.
- **Labels** — Public Sans, 11px, letter-spacing .17em, uppercase, weight 600. No monospace anywhere
  unless a specific value truly needs it.

## Layout & components

- Wrap max-width 720px; section rhythm `margin-top: 68px`; header 76px top padding.
- **Hairline rules, not shadows.** Sections separated by `--rule`. No `box-shadow`.
- **Flat, never nested.** No card inside a card. The two-column "split" is one bordered block with a
  single internal divider.
- Radii: 12px panels, 10px inner, 8–9px small.
- Diagram: business-role boxes (systems, queues, actions), the delta edge in `--delta`, the shared
  path in `--accent`; boxes are outlined, not filled with shadow.
- Tables: borderless, hairline row rules, uppercase faint header.

## AI tells to avoid

Purple/indigo gradients · glassmorphism · italic-serif display · nested cards · pulsing dots ·
drop-shadow overuse · pill/chip "soup" · overly rounded corners · AI-beige palettes · vague
headlines. Each is a default an agent reaches for; each cheapens the page.
