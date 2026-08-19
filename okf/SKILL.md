---
name: okf
description: "Bootstrap a project's Open Knowledge Format (OKF) bundle, or keep an existing one's declared spec version current. Use when asked to introduce OKF, set up an OKF bundle, or check/update the OKF spec version — and also by intent alone, unnamed: giving AI agents durable context on this repo, or a knowledge base/wiki that survives sessions. For keeping bundle *content* in sync with code changes, that's the commit hook this skill installs, not this skill itself."
---

# OKF

Bootstraps a bundle, or keeps an existing one's `okf_version` current.
Bundle *content* sync is the commit hook's job (step 3) — don't diff code
against docs here.

## Procedure

1. **Fetch the spec fresh, every run — never from memory.** Read
   `https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md`
   (fall back to `https://okf.md/spec/` on 404). Keep no embedded copy of
   its fields, examples, or version in this file. Quote what you fetched
   verbatim for the rest of this run.

2. **Check whether a bundle already exists** — search for its reserved
   marker, an `index.md` with an `okf_version` key, e.g.
   `grep -rl "okf_version" --include=index.md .`. A bundle can live
   anywhere; don't assume a folder name.

   **No bundle: bootstrap it.**
   - Locate the bundle root. If the project has an existing docs
     convention, ask whether to convert it or place OKF alongside it.
     Otherwise default to `okf/` at the repo root, confirmed first.
   - Create the root `index.md` with `okf_version` set to the fetched
     version, and an initial listing.
   - Seed concept docs from the codebase — the APIs, datasets, and modules
     an agent most needs context on. Convert existing docs where possible
     rather than writing from scratch.
   - Start `log.md` with one "Creation" entry per concept seeded, dated
     today.
   - Set up the commit reminder (step 3).

   **Bundle exists: check the version only.**
   - Compare `okf_version` to the fetched spec's version. Equal: nothing to
     do. Newer: bump `okf_version` and report it. A minor bump needs no
     content change; a major bump may need the spec's migration notes read
     first — treat that as its own task, not something to do here.
   - Add the commit reminder (step 3) if it doesn't exist yet.

3. **Add the commit reminder, if missing.** Check `.claude/settings.json`
   for a `PostToolUse` hook on `Bash` with an `if` targeting `git commit`;
   skip if one already reminds about OKF. Otherwise add, at the project
   level (`.claude/settings.json` — shared with the team, not the user's
   global settings):
   ```json
   {
     "hooks": {
       "PostToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "if": "Bash(git commit*)",
               "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"A commit just landed. Check for an OKF bundle: an index.md with an okf_version key, anywhere in the repo. If one exists, update any concept doc whose claims just changed (generated/verified/stale_after fields too, honestly), add a doc for a genuinely new concept worth one, and refresh log.md/index.md for whatever you touch. Leave everything else alone.\"}}'"
             }
           ]
         }
       ]
     }
   }
   ```
   Merge into any existing `hooks`/`PostToolUse` array. Pipe-test the raw
   command first (`echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m x"}}' | <cmd>`),
   then validate with
   `jq -e '.hooks.PostToolUse[] | select(.matcher == "Bash") | .hooks[] | select(.if | contains("git commit"))' .claude/settings.json`.
   Tell the user it's live and point them at `/hooks`.

4. **Report:** bootstrapped or version-checked, the fetched spec version
   and whether the bundle's version moved, and whether the reminder was
   added or already existed.

Never invent a requirement, source, or reviewer. Never reject a bundle for
what the fetched spec tolerates — missing optional fields, an unknown
`type`, extra frontmatter keys, broken links, no `index.md`.
