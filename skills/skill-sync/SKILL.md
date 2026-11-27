---
name: skill-sync
description: Use when `.skill` packages published as GitHub release assets should replace the same-named custom skills on claude.ai, or add new skills the user names — after a skills repo merge, when claude.ai is behind the repo, or when asked to sync, push, upload, update, or refresh skills on claude.ai from a GitHub release.
---

# Sync Skills

Hand the user a release's `.skill` files, ready to upload on claude.ai. Each asset's file name (minus `.skill`) is the skill name.

Never drive the upload with browser automation: browser extensions refuse claude.ai's Settings and Customize pages under any setting, so the upload click is the user's. Open pages and folders with the operating system's own launcher instead.

**Prerequisite:** `gh` authenticated.

## 1. Choose the release

Use the repo and tag the user named. Otherwise take the current repo (`gh repo view --json nameWithOwner`) and its latest release (`gh release list --limit 5`); if several recent releases could be meant, ask which. If a packaging workflow is still running for the commit just merged, wait for it (`gh run watch <id> --exit-status`) before downloading.

## 2. Download

```bash
gh release download [<tag>] --repo <owner/repo> --dir <scratchpad>/release --pattern '<skill>.skill' --clobber
```

One `--pattern` per skill the user named; `'*.skill'` only when they asked for all. Skip `skill-sync.skill`: it drives `gh` and the local machine, so a copy on claude.ai does nothing.

## 3. Open the folder and the page

Open both with the OS launcher, not a browser tool:

| OS | Folder | Page |
|---|---|---|
| Windows | `explorer.exe "<folder>"` (backslash path) | `Start-Process "https://claude.ai/customize/skills/yours"` |
| macOS | `open "<folder>"` | `open "https://claude.ai/customize/skills/yours"` |
| Linux | `xdg-open "<folder>"` | `xdg-open "https://claude.ai/customize/skills/yours"` |

## 4. Report

One line per file: skill name, full path, and the action for the user: "<skill> → Replace" for an existing skill, or "add menu → Upload" for a new one the user named. Replacing overwrites the live skill, even if the release is older.
