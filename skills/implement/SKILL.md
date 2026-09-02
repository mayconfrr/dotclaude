---
name: implement
description: Use when asked to implement, build, fix, refactor, or ship a code change end-to-end without pausing for step-by-step approval, including a bare GitHub issue number such as `/implement 384`. Triggers on "implement X", "build X and open a PR", "work issue 384", "just do it", "don't ask me", "run with it", unattended or autonomous implementation, and any request to carry a GitHub issue through to a draft pull request backed by a green full-suite run. Use it even when the request sounds small, since scope is discovered rather than assumed.
---

# Implement

Drive a change from request to an open draft pull request without stopping for approval.

**Announce at start:** "Using implement to drive this end-to-end. I won't stop for approval — every decision I make on your behalf lands in the PR's Decisions section at the end."

## Skills

Invoke each explicitly; they do not reliably chain to one another. Follow each as
written — do not re-derive it, do not soften it.

| Skill | When | Invoked by |
|---|---|---|
| `superpowers:using-superpowers` | governs the run | already loaded |
| `superpowers:brainstorming` | Phase 1 | controller |
| `superpowers:writing-plans` | Phase 2 | controller |
| `superpowers:using-git-worktrees` | Phase 3 setup | controller |
| `superpowers:subagent-driven-development` | Phase 3 | controller |
| `superpowers:dispatching-parallel-agents` | Phase 3 waves, parallel reviews, parallel investigation | controller |
| `superpowers:test-driven-development` | inside every task | implementer, via dispatch prompt |
| `superpowers:systematic-debugging` | any failure, any phase, incl. CI | both |
| `superpowers:verification-before-completion` | before every claim | both |
| `code-review` | Phases 3 and 4 | controller |
| `superpowers:receiving-code-review` | every fix round; every PR review comment | implementer via fix-round message; controller on the PR |
| `security-review` | end of Phase 4, before `simplify` | controller |
| `simplify` | end of Phase 4, after `security-review` | controller |
| `superpowers:finishing-a-development-branch` | Phase 5 | controller |
| `superpowers:executing-plans` | never | — |
| `superpowers:writing-skills` | never | — |

## Track work

Keep a todo list for the whole run: one entry per phase, one per plan task
once Phase 2 produces them, one per Phase 4 review round, one for the Phase
4.5 full-suite gate, one for the Phase 5 PR-monitoring loop. Update it as
each completes rather than batching updates at the end — it is the run's
visible state, and a resumed or interrupted run reads it before reading
anything else.

## Phase 0 — Resolve the request

Ask nothing.

A bare number is a GitHub issue. `/implement 384` →
`gh issue view 384 --json title,body,labels,comments`. The issue body is the
request, comments are context. Carry the number to the PR body. If `gh` cannot
fetch it, stop and ask.

Run resume-detection first, then read the entry point off the filesystem.

| Found | Enter at |
|---|---|
| SDD ledger whose first line names this plan | Phase 3, resume at first task with no `complete` line |
| Plan in `docs/superpowers/plans/` | Phase 3 |
| Spec, no plan | Phase 2 |
| Neither; the flow being changed already exists here | Phase 1, bounded |
| Neither; new subsystem | Phase 1, architectural |

## Phase 1 — Design

Announce the classification; do not negotiate it. Do not wait for design
approval or spec review.

Every question you would have asked becomes a ledger line:

```
Ruling: <what you decided> — <why> — <what it costs if wrong>
```

Bounded: no spec file, the design lives in the ledger. Architectural: write the
spec, run brainstorming's self-review, commit, continue.

Hidden complexity upgrades bounded → architectural.

## Phase 2 — Plan

Skip the execution-mode question — always `subagent-driven-development`.

Every task carries `Files:` and `Interfaces:` blocks. A plan without them runs
fully serial.

## Phase 3 — Execute

Resolve the base branch, then create the worktree without asking:

```bash
git fetch origin --prune
for b in staging main master; do
  git show-ref -q --verify "refs/remotes/origin/$b" && { BASE="origin/$b"; break; }
done
git worktree add ".worktrees/$BRANCH" -b "$BRANCH" "$BASE"
```

Reuse `$BASE` for the final review's merge base and the PR target. Report which
one resolved.

A red baseline is a ruling, not a question. Unrelated to the change → work
around it. Related → task zero.

Dispatch implementers in waves rather than strictly serially. Two tasks share a
wave only when all five hold; fail one and they stay serial:

1. Their Create / Modify path sets are disjoint.
2. Neither's `Consumes` names anything in the other's `Produces`.
3. Neither touches a shared choke point — `package.json`, lockfiles,
   migrations, an ordered migration index file, barrel exports, CI config.
4. Neither is the plan's first task.
5. Neither carries an integration test that touches a local database — a
   per-process instance narrows this, not closes it; a shared process
   can leak state through paths a database name never touches (a static
   field, a cache, a registry). Serial unless a passing repeat run
   proves otherwise; a design argument doesn't.

Wave cap 4. Implementers commit explicit paths only; `git add -A` is forbidden.

Dispatch a wave's task reviews in one response. Every review dispatch in
this phase — each task's review and the final whole-branch review — runs
through `code-review` against that task's or that branch's diff; none of
them use a bespoke reviewer prompt.

### Isolate a parallel wave

Serial tasks keep the one worktree. A wave of 2+ gets one worktree per task,
created by the controller — never by the Agent tool's `isolation` option. From
`.worktrees/$BRANCH`:

```bash
ROOT=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
WAVE_BASE=$(git rev-parse HEAD)
WB="$BRANCH--w$WAVE-$SLUG"
git -C "$ROOT" worktree add ".worktrees/$WB" -b "$WB" "$WAVE_BASE"
```

Branch off the `$WAVE_BASE` SHA, not `$BRANCH` — one branch cannot be checked
out twice. Separator `--`; `/` collides when `$BRANCH` holds one. Siblings are
local and ephemeral: never pushed, deleted at wave end.

Each dispatch gets its worktree path and `$WAVE_BASE`. Its review range is
`$WAVE_BASE..HEAD`, read in its own worktree. After `--no-ff` integration,
`<merge>^1..^2` is not the same range — it reports phantom deletions for
anything the other sibling also touched. Read a landed task's range from its
branch ref instead; keep that ref until the run closes.

Each worktree keeps its own build output: never shared, never hand-deleted.
Each also needs its own dependency install — a missing one can block a
commit that needs a pre-commit hook — and never symlinked or junctioned in
from another worktree: that's a documented breakage risk for some
dependency resolvers, and hand-deleting build output mid-run corrupts
incremental build state.

If the project has a `package.json` with a `package-lock.json` or
`yarn.lock`, install per worktree with `pnpm` instead — it reads the same
`package.json`. Local only: never commit `pnpm-lock.yaml`, never touch
`packageManager` in `package.json`; CI keeps the project's own lockfile and
package manager. Verify once per stack — pnpm's non-hoisted `node_modules`
can break a build that relies on npm's phantom dependencies. On that
failure, install with the project's own package manager per worktree and
rule on it. No such files: this doesn't apply, install however the project
already does.

Suite-wide numbers count only where `git status --short` is empty. A shared
worktree's wave reports scoped evidence only; the controller verifies the
suite itself between waves.

### Land a wave

Integrate once, after every review in the wave closes; landing them as they
finish puts the previous sibling inside the next one's range. From
`.worktrees/$BRANCH`, in plan order:

```bash
git merge --no-ff --no-edit "$WB"
git -C "$ROOT" worktree remove ".worktrees/$WB"
git branch -d "$WB"
```

Merge, never rebase: rebasing rewrites the commits the task reviewer
inspected. `--no-ff` even for the first sibling, or it fast-forwards and loses
its boundary.

`remove` refuses a dirty worktree and `-d` refuses an unmerged branch.
Inspect what a refusal names before forcing past it. `--force` and `-D` wait
until `git log $WAVE_BASE..$WB` shows every commit landed on `$BRANCH`. A
dead subagent leaves an intact, resumable worktree — resume its implementer
in it rather than discarding it.

Controller resolves and rules on it: a conflict that is a pure addition at
one shared anchor, neither side modifying a line the other wrote. Re-run the
check covering that file on a clean tree after.

Abort and re-dispatch instead: a conflict needing either side's intent.
Re-dispatch the implementer who wrote that side, to rebase its worktree and
re-verify — never a fresh agent, and never a dedicated integration subagent;
neither holds the context, and both would author unreviewed code in a
worktree they don't own.

### Amend the dispatch prompt

`using-superpowers` opens with `<SUBAGENT-STOP>`; dispatched subagents
self-discover no skills. Amend `implementer-prompt.md` at dispatch:

```
- Write tests (following TDD if task says to)
+ Invoke superpowers:test-driven-development and follow it

- **TDD Evidence** (if TDD was required for this task):
+ **TDD Evidence** (always):

+ On any failing test or unexpected behaviour, invoke
+   superpowers:systematic-debugging before proposing a fix.
+ Before writing your status line, invoke
+   superpowers:verification-before-completion.

+ Comments earn their place. Write one only where the code cannot be
+   made to explain itself — a non-obvious constraint, a workaround and
+   the cause it works around, a deliberate tradeoff. Never restate what
+   the line already says.
```

And in every fix-round message:

```
+ Invoke superpowers:receiving-code-review before implementing these
+   findings. Verify each against the codebase; push back with technical
+   reasoning rather than complying.
```

TDD's own exceptions stand — throwaway prototypes, generated code, config
files. The task brief declares them. An implementer never rules itself exempt
mid-task.

## Phase 4 — Whole-branch review

Give the whole-branch review the task loop's shape — up to **5 rounds**, each
one fix dispatch plus one scoped re-review.

At round 5 with findings still open, hand over, carrying the open findings
verbatim, what each round attempted, every ruling made in the run, and the
branch state.

Two consecutive clean rounds close this phase; one alone isn't enough
evidence.

Once closed: invoke `security-review`, adjudicate its findings with the same
fix-then-reverify discipline as the rounds above, then invoke `simplify`,
then one more `code-review` round on what `simplify` touched. A finding
there opens its own fix-then-review loop, capped at **3 rounds** — separate
from the budget above, since a cleanup pass has a narrower footprint to
re-check. At round 3 with findings still open, hand over the same way.

## Phase 4.5 — Full-suite gate

The implementation is not finished until every automated test suite the
change spans passes in full, run the way the project runs them for a full
build (the commands its CI, build file, or contributing docs use), from a
clean tree. If the project splits suites by layer, service, or package, run
every one the change touches, not just the one that changed. Read the
actual output under `superpowers:verification-before-completion` — a suite
you did not run is not a suite that passed.

A project with no automated test suite has nothing to gate on here; don't
invent one — note the absence and move on.

This gate is independent of CI: required even when the PR's CI is disabled,
unavailable, or out of budget. A failure here is Phase-3 work, not a
Phase-5 footnote — root-cause it with `superpowers:systematic-debugging`,
fix it, and re-run until green before opening or finishing the PR. Never
narrow the suite, mark a failing test skipped/pending, or ship red to "let
CI sort it out."

## Phase 5 — Finish and ship

The base branch is already resolved — do not confirm it. Present no menu; the
terminal state follows the remote.

**GitHub** (`gh repo view` succeeds, or `origin` matches github.com): take
Option 2, but open the PR **as a draft** (`gh pr create --draft`, or
`gh pr ready --undo` if the forge tooling opened it ready). The PR base is
`${BASE#origin/}`. From an issue run, the body closes it (`Closes #384`). The
body carries a `## Decisions` section: every ruling, from any phase, where more
than one viable option existed and you picked one without asking — what you
decided, why, what it costs if wrong. A mechanical step with no real
alternative doesn't belong here; a genuine judgment call does, whether or not
it turned out to matter.

The PR stays a draft — promoting it to ready-for-review is the human's call,
never the run's.

**Any other remote, or none:** take Option 3.

### Monitor the PR

After the PR exists, watch its checks:

```bash
gh pr checks --watch
```

A repo may gate CI on `draft == false`: no checks start until it's promoted,
so `gh pr checks` reports none pending. That is expected, not a failure — do
not promote the draft to force them. The Phase 4.5 full-suite gate, which
already ran from a clean tree independent of CI, is the green evidence here;
skip straight to handling review comments, next.

On red (checks that do run): invoke `superpowers:systematic-debugging`, fix the
root cause, commit, push, watch again.

Handle review comments under `superpowers:receiving-code-review` as they
arrive — on cloud the run is auto-subscribed to the PR, so a comment wakes it
later; do not poll or hold a window open waiting for one. Reply in the comment
thread, never at top level. Pushing a fix reruns the checks: watch them again.

Red CI is capped at 5 rounds, then hand over with the failing job's log excerpt
and what each round tried.

The run ends when the checks are green (or the PR is a draft with CI gated
off). A later comment resumes it in the preserved worktree.

### Close out

`## Decisions` is exhaustive or the run is unreviewable — a human reviewing
the PR sees the PR, not a ledger deleted at Finish.

## Hard stops

Stop and hand over for:

- an irreversible or destructive operation
- a security-sensitive action
- a side effect outside the worktree, except pushing this feature branch and
  opening its PR
- a plan defect where every path forward is a guess
- the whole-branch fix loop reaching round 5 with findings open
- the post-`simplify` fix loop reaching round 3 with findings open
- the Phase 4.5 full suite(s) still red after root-causing it, rather than
  opening or finishing the PR on a red suite
- the PR's CI reaching round 5 still red
- an integration conflict surviving one rebase round per side
- `/implement <number>` where the issue cannot be fetched

This run's branch set is `$BRANCH` plus the `$BRANCH--w*` siblings the
controller creates; merging a sibling into `$BRANCH` is authorized. Merging
the PR, pushing to `$BASE`, force-pushing, publishing, and touching a branch
outside that set are never authorized.

## Red flags

**The discipline skills are not gates. They are what replaced the human's
oversight.**

| Thought | Reality |
|---|---|
| "Autonomous means I can skip the RED step" | Nobody is waiting on RED. It is the only proof the test works. |
| "No one is watching, so a lighter review is fine" | Reviews replaced the watching. Fewer reviews with no human is worse, not equal. |
| "I'll just fix this review finding myself" | Controller fixes pollute your context and skip review. Resume the implementer. |
| "This test failure is obvious, I'll patch it" | Root cause first. `systematic-debugging` is named in the dispatch prompt for this moment. |
| "This got big, I should check in before Phase 3" | Scope growth upgrades the path and gets a ruling. It buys no check-in. |
| "The user would obviously want this merged" | The PR is authorized. The merge is not. |
| "CI is flaky, re-run and move on" | A red check is a failure. Investigate it, or spend a round and say so in the handoff. |
| "`## Decisions` is long, I'll summarize" | Summarizing is discarding. Exhaustive or it substitutes for nothing. |
| "Waves are faster, I'll batch these two anyway" | All five conditions or serial. A collided wave costs more than it saved. |
| "Build output looks stale, I'll delete it" | Hand-deleting it corrupts incremental state and manufactures confusing errors that look like real bugs. Clean via the project's own build tool, or leave it. |
| "Both halves passed review, so the merge is a formality" | Independent reviews say nothing about the seam. Judge the merge itself, same as any other change. |
| "I'll ask which base branch to use" | `origin/staging`, then `main`, then `master`. Report which resolved. |
