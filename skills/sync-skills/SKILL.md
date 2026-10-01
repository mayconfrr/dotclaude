---
name: sync-skills
description: Use when `.skill` packages published as GitHub release assets should replace the same-named custom skills on claude.ai, or add new skills the user names — after a skills repo merge, when claude.ai is behind the repo, or when asked to sync, push, upload, update, or refresh skills on claude.ai from a GitHub release.
---

# Sync Skills

Replace custom skills on claude.ai with the `.skill` assets of a GitHub release. Each asset's file name (minus `.skill`) is the skill name. Skill IDs and the UI language are discovered at runtime.

**Announce at start:** "Using sync-skills. I'll show what will be replaced or added before uploading anything."

**Prerequisites:** `gh` authenticated, and the Claude in Chrome tools. Invoke the `claude-in-chrome` skill and load its tools before any browser call.

## 1. Choose the release

Use the repo and tag the user named. Otherwise take the current repo (`gh repo view --json nameWithOwner`) and its latest release (`gh release list --limit 5`); if several recent releases could be meant, ask which.

## 2. Download

```bash
gh release download [<tag>] --repo <owner/repo> --dir <scratchpad>/release --pattern '*.skill' --clobber
```

Download with `gh`, never a browser, into the session scratchpad: the browser upload tool rejects files outside session-shared folders.

## 3. Match and confirm

Open `https://claude.ai/customize/skills/yours` in a new tab. The list has several sections; only the one holding skills you created is replaceable. Match each asset to a row by skill name, never by position: the list reorders by last update. Open a matched row: its URL becomes `.../customize/skills/yours/id/<skill_id>`. Note the skill's current version.

Show a table of replacements, additions, and unmatched assets. Unmatched assets are reported, not added, unless the user named them as additions. Ask once before uploading, unless the user's request already names exactly what to replace and add. Replacing overwrites the live skill, even if the release is older.

## 4. Replace each skill

For every confirmed replacement:

1. Navigate to `<detail url>/replace`, then wait a few seconds: `find` returns nothing until the page has rendered. Use this path, not the three-dot menu: menu labels vary with the UI language.
2. Locate the page's file input with `find` (the match labelled as a file input, not the drop-zone button), and set the downloaded file with the file-upload tool. Never click the drop zone: it opens a native picker you can't drive.
3. A preview appears under the drop zone. Check that its title matches the skill being replaced; if not, cancel and report it.
4. Take a fresh screenshot and click the upload button by its coordinates in that screenshot's frame. The button moves with the preview's length, and the frame size changes between screenshots. A click by element reference sometimes doesn't register.
5. Success redirects to the skill's `/contents` page. If the page stays on `/replace`, nothing was uploaded.
6. Open the skill's detail page and confirm the version number went up (shown in the header).

If a step fails twice, stop that skill, report what you saw, and continue with the next. Never re-click upload without first checking the skill's current version.

## Add a new skill

For user-named additions only. On the skills list, open the add menu (top right) and choose its upload item, which opens `https://claude.ai/customize/skills/new/upload`. That page works like the replace page: wait for render, set the file, check the preview title, click upload by coordinates, and expect a redirect to the new skill's `/contents` page at v1. Upload one skill at a time.

## 5. Report

One table: skill, previous version (none for additions), new version, result. List unmatched assets and any failures. Close the tab you opened.
