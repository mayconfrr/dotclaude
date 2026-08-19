---
name: skill-audit
description: Audit a skill file for prose that narrates its own development history — approaches tried and abandoned, past mistakes, the iteration journey — instead of stating only the current, correct procedure. Use when asked to audit, clean up, lean, or reduce a skill to "just the recipe," or when a skill reads like a record of how it was built rather than instructions to follow now.
---

# Skill Audit

A skill is a recipe, not a lab notebook. State the correct procedure; don't
narrate the wrong turns taken to find it.

## What to cut

- **Development narration**: "we tried X first, then switched to Y", "an
  earlier version did Z instead", "this was originally written as...".
  Keep only the current approach.
- **Attribution to a discovery moment**: "found during a session on...",
  "the user pointed out that...", or any timestamp/session reference that
  doesn't serve a reader following the recipe today.
- **Redundant restatement**: the same instruction in an intro, a numbered
  step, and a closing note. State it once, where it's used.
- **Meta-commentary about the skill itself** — how thorough or careful it
  is — rather than what to actually do.

## What to keep

- A **warning against a specific wrong approach**, when removing it would
  let a reader repeat a concrete mistake. Keep it as a rule ("never do X —
  Y happens"), not a story ("we found that X...").
- Facts the skill depends on being correct (a spec's version, an API's
  behavior) — these aren't development history.

## Procedure

1. Read the skill file in full.
2. For each paragraph: does it say what to do now, or how the skill came
   to be? Narration fails even when true.
3. For a "don't do X" warning: is X still a live temptation, or dead
   history? Keep only the former, and only as a rule, not a story.
4. Merge duplicate instructions into their single best location; delete
   the rest.
5. Re-validate frontmatter and structure after editing (skill-creator's
   `quick_validate.py`, if available).
6. Report what was cut and why — don't silently discard something the
   user may have wanted kept.
