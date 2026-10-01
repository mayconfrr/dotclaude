---
name: cleanup
description: Use when local or origin branches and git worktrees have piled up after PRs merged, or when asked to clean up, prune, tidy, or delete merged, stale, or leftover branches and worktrees — including `.worktrees/` directories left behind by `implement` runs.
---

# Cleanup

Nothing is deleted before the user has seen the exact list.

**Announce at start:** "Using cleanup to inventory branches and worktrees. I'll show you the full list before deleting anything."

## 1. Inventory

Run `scripts/inventory.sh [stale-days]` (in this skill's directory; default 30, or the user's number) from inside the repo. It fetches with `--prune`, then prints one TSV row per local branch, origin branch, and worktree. Do not re-derive its facts with ad-hoc git commands. It does not apply the threshold: compare `age_days` to it yourself.

Local rows: `checkout` is the path where the branch is checked out; `note` is `primary-checkout` for the primary checkout's branch. Worktree rows (non-primary only): `ref` is the path, `checkout` the branch (`(detached)` or `-` if none), `note` the flags `prunable` and `locked`; join them to local rows on that path. Origin rows carry `origin/<name>` in `ref` and `-` in `local_only_commits`, `checkout`, and `dirty`. `author_is_me` compares the tip commit's author email to `git config user.email`.

`merged` says how the branch's content reached origin's default branch: `ancestor` (normal or fast-forward merge), `squash` (the tree already contains the branch's changes — covers squash and rebase merges), `pr-merged` (GitHub reports a merged PR whose head is this exact tip), or `no`. `open_pr` of `?` means `gh` could not tell; treat it as unknown, not as `no`. With `gh=0` in the stderr trailer, `pr-merged` is undetectable, so `merged` = `no` may hide a merged PR: say so in the table.

## 2. Classify

| Group | Rule | Default |
|---|---|---|
| **Merged** | `merged` ≠ `no` and `open_pr` ≠ `yes` | proposed for deletion |
| **Stale** | `merged` = `no`, `age_days` ≥ threshold, `open_pr` ≠ `yes` | listed, deleted only on explicit opt-in |
| **Others' branches** | origin rows with `author_is_me` = `no`, merged or not (this group wins over Merged and Stale) | listed, deleted only on explicit opt-in |
| **Prunable worktrees** | worktree flagged `prunable` (directory already gone) | proposed for `git worktree prune` |

A merged branch's worktree goes with it, shown as part of that branch's row. Anything else is **kept** (unmerged and under the threshold, dirty worktree, open PR). The base branch has no row; it is never touched.

Rows with `open_pr` = `?` stay in their group, marked "PR status unverified" in the table.

**Never propose** (even when merged): `develop`, `dev`, `trunk`, `release/*`, the primary checkout's branch, a branch with `open_pr` = `yes`, a worktree with `dirty` = `yes` or flagged `locked`, and a branch checked out in a worktree that isn't itself being removed.

Flag Stale local branches with `local_only_commits` > 0: those commits exist on no remote.

## 3. Present and confirm

Show one table per group: kind, ref, tip SHA, age, why it qualifies. List what's kept and why. Then ask once (AskUserQuestion, multi-select) which groups to delete. The tip SHAs let a deletion be undone with `git branch <name> <sha>` or `git push origin <sha>:refs/heads/<name>`.

If the user asked to list only, stop here. A request like "delete everything merged" still gets the table first, then proceeds without a second question.

## 4. Delete

Order matters: a branch can't be deleted while a worktree has it checked out.

```bash
git worktree remove <path>
git worktree prune
git branch -D <branch>
git push origin --delete <b1> <b2>
```

Use `-D`: `-d` checks the branch's upstream (or `HEAD` without one), not origin's default branch, so it can refuse a branch the inventory proved merged. Push all approved origin branches in one command, as bare names without `origin/`.

If a command is refused (locked file on Windows, protected remote branch), report it and move on; never retry with `--force` or loosen a rule.

Finish with `git fetch --prune origin`, then report deleted, skipped (with reason), and the SHA of every deleted branch.
