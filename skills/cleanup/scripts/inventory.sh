#!/usr/bin/env bash
# Usage: inventory.sh [stale-days]   (default 30)
# Read-only apart from `git fetch --prune`. Prints one TSV row per local branch,
# origin branch, and worktree, with the facts the cleanup skill needs to decide.
set -uo pipefail

STALE_DAYS="${1:-30}"
git rev-parse --git-dir >/dev/null 2>&1 || { echo "not a git repository" >&2; exit 2; }

git fetch --prune origin >/dev/null 2>&1 || echo "warning: fetch failed, origin data may be stale" >&2

BASE=""
for candidate in "$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)" origin/main origin/master; do
  if [ -n "$candidate" ] && git rev-parse --verify --quiet "$candidate^{commit}" >/dev/null; then BASE="$candidate"; break; fi
done
[ -n "$BASE" ] || { echo "cannot resolve origin's default branch" >&2; exit 2; }
BASE_NAME="${BASE#origin/}"
BASE_TREE="$(git rev-parse "$BASE^{tree}")"
HAVE_GH=0; command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 && HAVE_GH=1
NOW="$(date +%s)"
ME="$(git config user.email || true)"

PRIMARY="$(git worktree list --porcelain | awk '/^worktree /{print substr($0,10); exit}')"
declare -A CHECKED_OUT
current_path=""
while IFS= read -r line; do
  case "$line" in
    "worktree "*) current_path="${line#worktree }" ;;
    "branch refs/heads/"*) CHECKED_OUT["${line#branch refs/heads/}"]="$current_path" ;;
  esac
done < <(git worktree list --porcelain)

merged_by() { # $1 = ref (local branch or origin/x)
  local ref="$1" tip tree
  tip="$(git rev-parse "$ref^{commit}")"
  if git merge-base --is-ancestor "$tip" "$BASE"; then echo ancestor; return; fi
  tree="$(git merge-tree --write-tree "$BASE" "$tip" 2>/dev/null | head -n1)"
  if [ "$tree" = "$BASE_TREE" ]; then echo squash; return; fi
  if [ "$HAVE_GH" = 1 ]; then
    local name="${ref#origin/}"
    if gh pr list --head "$name" --state merged --json headRefOid -q '.[].headRefOid' 2>/dev/null | grep -qx "$tip"; then
      echo pr-merged; return
    fi
  fi
  echo no
}

open_pr() { # $1 = branch name
  [ "$HAVE_GH" = 1 ] || { echo "?"; return; }
  local n; n="$(gh pr list --head "$1" --state open --json number -q length 2>/dev/null)" || { echo "?"; return; }
  [ "${n:-0}" -gt 0 ] && echo yes || echo no
}

age_days() { echo $(( (NOW - $(git log -1 --format=%ct "$1")) / 86400 )); }

printf 'kind\tref\ttip\tmerged\tage_days\topen_pr\tlocal_only_commits\tupstream_gone\tcheckout\tdirty\tauthor_is_me\tnote\n'

while IFS= read -r br; do
  [ "$br" = "$BASE_NAME" ] && continue
  tip="$(git rev-parse --short "$br")"
  local_only="$(git rev-list --count "$br" --not --remotes)"
  gone="no"; [ "$(git for-each-ref --format='%(upstream:track)' "refs/heads/$br")" = "[gone]" ] && gone="yes"
  co="${CHECKED_OUT[$br]:-}"; dirty="-"; note=""
  if [ -n "$co" ]; then
    dirty="no"; [ -n "$(git -C "$co" status --porcelain 2>/dev/null)" ] && dirty="yes"
    [ "$co" = "$PRIMARY" ] && [ "$(git -C "$PRIMARY" symbolic-ref --short HEAD 2>/dev/null)" = "$br" ] && note="primary-checkout"
  fi
  mine="$([ "$(git log -1 --format=%ae "$br")" = "$ME" ] && echo yes || echo no)"
  printf 'local\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$br" "$tip" "$(merged_by "$br")" "$(age_days "$br")" "$(open_pr "$br")" "$local_only" "$gone" "${co:--}" "$dirty" "$mine" "$note"
done < <(git for-each-ref --format='%(refname:short)' refs/heads)

while IFS= read -r ref; do
  name="${ref#origin/}"
  [ "$name" = "HEAD" ] || [ "$name" = "$BASE_NAME" ] || [ "$ref" = "origin" ] && continue
  mine="$([ "$(git log -1 --format=%ae "$ref")" = "$ME" ] && echo yes || echo no)"
  printf 'origin\t%s\t%s\t%s\t%s\t%s\t-\t-\t-\t-\t%s\t\n' \
    "$ref" "$(git rev-parse --short "$ref")" "$(merged_by "$ref")" "$(age_days "$ref")" "$(open_pr "$name")" "$mine"
done < <(git for-each-ref --format='%(refname:short)' refs/remotes/origin)

wt_path=""; wt_branch="-"; wt_flags=""
emit_worktree() {
  [ -n "$wt_path" ] && [ "$wt_path" != "$PRIMARY" ] || return 0
  local dirty="-"
  case "$wt_flags" in *prunable*) ;; *) dirty="no"; [ -n "$(git -C "$wt_path" status --porcelain 2>/dev/null)" ] && dirty="yes" ;; esac
  printf 'worktree\t%s\t-\t-\t-\t-\t-\t-\t%s\t%s\t-\t%s\n' "$wt_path" "$wt_branch" "$dirty" "${wt_flags:-}"
}
while IFS= read -r line; do
  case "$line" in
    "worktree "*) emit_worktree; wt_path="${line#worktree }"; wt_branch="-"; wt_flags="" ;;
    "branch refs/heads/"*) wt_branch="${line#branch refs/heads/}" ;;
    "locked"*) wt_flags="$wt_flags locked" ;;
    "prunable"*) wt_flags="$wt_flags prunable" ;;
    "detached") wt_branch="(detached)" ;;
  esac
done < <(git worktree list --porcelain; echo)
emit_worktree

echo "# base=$BASE stale_days=$STALE_DAYS gh=$HAVE_GH" >&2
