---
name: skill-audit
description: Audit a skill file for prose that narrates its own development history — approaches tried and abandoned, past mistakes, the iteration journey — instead of stating only the current, correct procedure. Use when asked to audit, clean up, lean, or reduce a skill to "just the recipe," or when a skill reads like a record of how it was built rather than instructions to follow now. `/skill-audit install` or `/skill-audit hook` instead installs a global reminder hook that nudges a future SKILL.md edit to get audited — it does not audit anything itself.
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
- **A project-specific fact stated as universal, in a global skill**
  (`~/.claude/skills`, or a skill on claude.ai): a build directory's name, a
  specific error message, a package manager's quirk — true for the project
  the skill was written against, not for every project it will run
  against. Generalize to the underlying principle, or cut it. A
  project-scoped skill (`<project>/.claude/skills`) is exempt — project
  facts are exactly what it's for.

## What to keep

- A **warning against a specific wrong approach**, when removing it would
  let a reader repeat a concrete mistake. Keep it as a rule ("never do X —
  Y happens"), not a story ("we found that X...").
- Facts the skill depends on being correct (a spec's version, an API's
  behavior) — these aren't development history.

## What to verify (correctness, not just leanness)

- **Load-bearing instructions**: before cutting anything as filler, check
  whether removing it would silently break a real invocation — an exact
  escape sequence, a specific flag, a step a later step depends on. Looking
  redundant isn't the same as being inert.
- **Duplicates**: the same fact, path, command, or instruction stated more
  than once, even when the wording differs each time. Consolidate to one
  location.
- **Contradictions**: two parts of the skill that disagree — a rule one
  section states that an example elsewhere violates, a frontmatter claim
  the body doesn't match, two steps that assume opposite things.
- **Wrong facts**: a file path, tool name, command, version, or URL that no
  longer matches reality. Verify each one directly — read the file it
  points to, run the command — don't take the skill's word for it.

## Procedure

**Invoked as `/skill-audit install` or `/skill-audit hook`:** install the
reminder hook below and stop — don't audit anything.

**Invoked any other way:** audit the given skill file; never touch the hook.

1. Read the skill file in full.
2. Note where it lives: global (`~/.claude/skills`, claude.ai) or
   project-scoped (`<project>/.claude/skills`). Only global skills get
   step 4's check.
3. For each paragraph: does it say what to do now, or how the skill came
   to be? Narration fails even when true.
4. For a global skill, for each concrete fact or example: does it hold for
   any project this skill might run against, or only the one it was
   written against? Generalize the ones that don't, or cut them.
5. For a "don't do X" warning: is X still a live temptation, or dead
   history? Keep only the former, and only as a rule, not a story.
6. Before cutting anything from steps 3-5, check it isn't load-bearing —
   would removing it break a real invocation, not just read as filler?
7. Merge duplicates into their single best location; delete the rest — even
   ones that don't share wording. Flag any contradiction between two parts
   of the file. Verify every concrete path, command, tool name, version, or
   URL directly (read the file, run the command) rather than trust it —
   correct what's wrong.
8. Re-validate frontmatter and structure after editing (skill-creator's
   `quick_validate.py`, if available).
9. Report what was cut, merged, corrected, and why — don't silently discard
   something the user may have wanted kept.

## Reminder hook

Installed globally, on demand, by `/skill-audit install` (or `hook`) — never
as a side effect of an ordinary audit. Check `~/.claude/settings.json` for a
`Stop` hook whose command mentions `SKILL.md`; skip if one already does.
Otherwise merge this in (don't replace any existing `hooks`/`Stop` array).
Uses `sed`/`grep`/`tail` only, not `jq` — a global hook can't assume `jq` is
on this machine:
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "sed -n 's/.*\"transcript_path\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p' | { read -r tp; [ -n \"$tp\" ] && tail -c 50000 \"$tp\" 2>/dev/null | grep -qE '\"name\":\"(Edit|Write)\",\"input\":\\{\"file_path\":\"[^\"]*SKILL\\.md\"' && echo '{\"hookSpecificOutput\":{\"hookEventName\":\"Stop\",\"additionalContext\":\"A SKILL.md file was edited this turn. Once every change to it is done, run skill-audit on it.\"}}'; }; true"
          }
        ]
      }
    ]
  }
}
```
A `Stop` hook fires once when the turn ends, not once per edit — so a file
edited several times in one turn still only triggers one reminder, after
every change to it has already landed. The pattern matches only an `Edit`
or `Write` tool call whose `file_path` ends in `SKILL.md` — never grep for
the bare substring `SKILL.md` across the tail: it also matches a `Read`
call, and in a skill-heavy conversation it matches ordinary prose too,
firing on nearly every turn regardless of whether anything was edited.
Pipe-test the raw command with a synthetic transcript line shaped like a
real `Edit`/`Write` tool-use block targeting a `SKILL.md` path, and with one
that only mentions `SKILL.md` in prose or in a `Read` call, to confirm the
second one stays silent. Validate the written file with
`python -c "import json; json.load(open('...'))"` (valid JSON) and
`grep -c 'SKILL\.md' ~/.claude/settings.json` (the hook is actually in there).
