---
name: instruction-audit
description: Use when asked to audit, clean up, lean, compact, or reduce a skill file or CLAUDE.md — or when one reads like a record of how it was built, or is simply longer than it needs to be. Trims anything that isn't load-bearing, since every line loads into context on every session that reads it. `/instruction-audit install` or `hook` is a separate command, covered in the Procedure section — it does not audit anything.
---

# Instruction Audit

A skill or CLAUDE.md is a recipe, not a lab notebook — and every line of it
loads into context on every session that reads it. Cost is not
hypothetical: length here is a direct, recurring tax on every future
invocation. State the correct procedure, as compactly as it can be stated
correctly; don't narrate the wrong turns taken to find it.

## What to cut

- **Development narration and discovery attribution**: "we tried X first,
  then switched to Y", "an earlier version did Z instead", "found during a
  session on...", "the user pointed out that...", or any timestamp/session
  reference that doesn't serve a reader following the recipe today. Keep
  only the current approach.
- **Redundant restatement**: the same instruction in an intro, a numbered
  step, and a closing note. State it once, where it's used.
- **Meta-commentary about the skill itself** — how thorough or careful it
  is — rather than what to actually do.
- **Justification prose that doesn't change behavior**: a paragraph
  explaining *why* a rule is a good idea, when the rule itself is already
  clear and a reader only needs to follow it, not be convinced of it. Keep
  a justification only when it disambiguates an edge case the rule alone
  wouldn't cover.
- **A project-specific fact stated as universal, in a global skill**
  (`~/.claude/skills`, or a skill on claude.ai): a build directory's name, a
  specific error message, a package manager's quirk — true for the project
  the skill was written against, not for every project it will run
  against. Generalize to the underlying principle, or cut it. A
  project-scoped skill (`<project>/.claude/skills`) or a project's
  `CLAUDE.md` is exempt — project facts are exactly what it's for.
- **Any phrase sayable in fewer words with the same meaning.** This is not
  a style pass done once at the end — check it on every paragraph you
  touch, cut and keep alike. Dropping a qualifier that narrows or hedges
  the meaning ("for any reason", "in this codebase") is not this — only
  drop words whose absence changes nothing a reader would act on.

## What to keep

- A **warning against a specific wrong approach**, when removing it would
  let a reader repeat a concrete mistake. Keep it as a rule ("never do X —
  Y happens"), not a story ("we found that X...").
- Facts the skill depends on being correct (a spec's version, an API's
  behavior) — these aren't development history.
- A concrete before/after example that's the fastest way to make an
  abstract rule unambiguous — keep it, but state it as a timeless example
  ("X should be Y, not Z"), not as a discovery story ("we used to write Z
  until we noticed...").

## What to verify (correctness, not just leanness)

- **Load-bearing instructions**: before cutting anything as filler, check
  whether removing it would silently break a real invocation — an exact
  escape sequence, a specific flag, a step a later step depends on. Looking
  redundant isn't the same as being inert.
- **Duplicates**: the same fact, path, command, or instruction stated more
  than once, even when the wording differs each time — including a
  frontmatter description restated as the body's opening line or
  paragraph, a common place for it to hide. Consolidate to one location.
- **Contradictions**: two parts of the skill that disagree — a rule one
  section states that an example elsewhere violates, a frontmatter claim
  the body doesn't match, two steps that assume opposite things.
- **Wrong facts**: a file path, tool name, command, version, or URL that no
  longer matches reality. Verify each one directly — read the file it
  points to, run the command — don't take the skill's word for it.

## Frontmatter and structure rules

Applies to a `SKILL.md`'s YAML frontmatter and file layout; a `CLAUDE.md`
has neither, so skip this section for one.

- **Required fields**: `name` and `description`, both strings. The only
  other recognized keys are `license`, `allowed-tools`, `metadata`,
  `compatibility` — flag any other key.
- **`name`**: kebab-case only (lowercase letters, digits, hyphens), no
  leading or trailing hyphen, no consecutive hyphens, max 64 characters.
- **`description`**: max 1024 characters (hard cap), under ~500 if
  possible; no angle brackets. States triggering conditions — ideally
  opening with "Use when..." — rather than previewing the body's steps: a
  description that summarizes the procedure lets an agent act on it and
  skip reading the rest.
- **Body size**: no hard cap, but every line is a recurring context tax —
  hold it to what step 8 leaves after compacting. Past roughly 500 lines,
  point to a separate reference file instead of staying inline.

## Procedure

**Invoked as `/instruction-audit install` or `/instruction-audit hook`:** install the
reminder hook below and stop — don't audit anything.

**Invoked any other way:** audit the given skill file or `CLAUDE.md`; never
touch the hook.

1. Read the file in full.
2. Note where it lives: global (`~/.claude/skills`, claude.ai), project
   `CLAUDE.md`/`AGENTS.md`, or project-scoped skill
   (`<project>/.claude/skills`). Only a global skill needs the
   project-specific-fact bullet in "What to cut."
3. Walk every paragraph against "What to cut" and "What to keep" — check
   load-bearing status, per "What to verify," before acting on any of it.
4. Apply "What to verify": merge duplicates, flag contradictions, and
   verify every concrete fact directly (read the file it points to, run
   the command) rather than trust it — correct what's wrong.
5. Compact what survives, per the last "What to cut" bullet — this applies
   to content just kept, not only new edits.
6. Check frontmatter and structure against the rules above. Skill-creator's
   `quick_validate.py`, if present, checks the same mechanical rules — a
   convenient cross-check, not a dependency.
7. Report what was cut, merged, corrected, and compacted, and why — don't
   silently discard something the user may have wanted kept. Note the
   before/after size (lines or words) so the context-footprint reduction
   is visible, not just claimed.

## Reminder hook

Installed globally, on demand, by `/instruction-audit install` (or `hook`) — never
as a side effect of an ordinary audit. Two hooks work together: `PostToolUse`
marks that a `SKILL.md`/`CLAUDE.md` edit happened, `Stop` fires the reminder
once per turn and clears the mark. This detects the edit at the moment it
happens rather than scanning the transcript for it afterward — on a long
call chain, enough tool output after the edit can push it past any bounded
scan window, so scanning can silently miss it; detecting it live cannot.

Check `~/.claude/settings.json` for both hooks already present and matching
the versions below (covering both `SKILL.md` and `CLAUDE.md`); skip only
then. A `Stop`-only hook that scans the transcript, or one covering
`SKILL.md` alone, is the stale prior design — replace it. Merge these in
without replacing any existing `hooks` arrays. Uses `sed`/`grep` only, not
`jq` — a global hook can't assume `jq` is on this machine:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "IN=$(cat); SID=$(printf '%s' \"$IN\" | sed -n 's/.*\"session_id\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p'); [ -n \"$SID\" ] && printf '%s' \"$IN\" | grep -qE '\"file_path\":\"[^\"]*(SKILL\\.md|CLAUDE\\.md)\"' && touch \"${TMPDIR:-/tmp}/instruction-audit-pending-$SID\"; true"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "IN=$(cat); SID=$(printf '%s' \"$IN\" | sed -n 's/.*\"session_id\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p'); MARKER=\"${TMPDIR:-/tmp}/instruction-audit-pending-$SID\"; [ -n \"$SID\" ] && [ -f \"$MARKER\" ] && { rm -f \"$MARKER\"; echo '{\"hookSpecificOutput\":{\"hookEventName\":\"Stop\",\"additionalContext\":\"A SKILL.md or CLAUDE.md file was edited this turn. Once every change to it is done, run instruction-audit on it.\"}}'; }; true"
          }
        ]
      }
    ]
  }
}
```
`PostToolUse`'s `matcher` restricts it to `Edit`/`Write` calls; its command
reads `tool_input.file_path` and `session_id` straight from its own JSON —
no transcript involved — and touches a session-scoped marker file when the
path ends in `SKILL.md` or `CLAUDE.md`. `Stop` reads the same `session_id`,
checks for that marker, fires once, and deletes it — so a file edited
several times in one turn still triggers only one reminder, and a later
`Stop` with nothing new stays silent. Scoping the marker to `session_id`
keeps concurrent sessions on the same machine from tripping each other's
reminder.

Pipe-test both commands before installing: feed `PostToolUse` a synthetic
`Edit`/`Write` JSON line targeting `SKILL.md`/`CLAUDE.md` and confirm the
marker appears, then one targeting an unrelated file and confirm it
doesn't. Feed `Stop` a matching `session_id` and confirm it fires once and
clears the marker, then feed it again and confirm it now stays silent.
Validate the written file with
`python -c "import json; json.load(open('...'))"` (valid JSON) and
`grep -c 'instruction-audit-pending' ~/.claude/settings.json` (both hooks
are actually in there).
