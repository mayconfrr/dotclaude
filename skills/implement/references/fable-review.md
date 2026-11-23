# Fable review prompt

Dispatch on `model: fable`, `subagent_type: general-purpose`. Fill the
placeholders; send the rest verbatim.

```
Read-only code review. Do not edit, commit, push or comment anywhere. Temp
files only in <scratchpad path>.

Repo worktree: <worktree path> (branch <branch>, PR <number> in <owner/repo>,
base <base>). Review only the final state of the branch: `git diff
<base>...HEAD`. Ignore the commit history and how the change got here.

This is the last check, after per-task, whole-branch, simplify, security and
lazy senior review rounds. Report only what those rounds missed. The PR body
(`gh pr view <number> -R <owner/repo>`) states the intent; its `## Decisions`
and `## Findings not fixed` sections list what is already settled, so do not
re-raise those unless you have new evidence.

Check correctness against the intent, edge cases the tests miss, the repo's
own rules (AGENTS.md / CLAUDE.md), and the docs the change touches. Verify
library and platform behaviour against their documentation (Context7 or the
web), not memory.

Return: verdict (pass / fix first), then findings labelled Critical /
Important / Minor with file:line and one-sentence reasons. Under 300 words.
```
