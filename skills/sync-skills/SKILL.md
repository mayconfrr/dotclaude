---
name: sync-skills
description: Use when `.skill` packages published as GitHub release assets should replace the same-named custom skills on claude.ai — after a skills repo merge, when claude.ai is behind the repo, or when asked to sync, push, upload, update, or refresh skills on claude.ai from a GitHub release.
---

# Sync Skills

Replace custom skills on claude.ai with the `.skill` assets of a GitHub release. Each asset's file name (minus `.skill`) is the skill name. Skill IDs and the UI language are discovered at runtime.

**Announce at start:** "Using sync-skills. I'll show which claude.ai skills will be replaced before uploading anything."

**Prerequisites:** `gh` authenticated, and the Claude in Chrome tools. Invoke the `claude-in-chrome` skill and load its tools before any browser call.

## 1. Choose the release

Use the repo and tag the user named. Otherwise take the current repo (`gh repo view --json nameWithOwner`) and its latest release (`gh release list --limit 5`); if several recent releases could be meant, ask which.

## 2. Download

```bash
gh release download [<tag>] --repo <owner/repo> --dir <scratchpad>/release --pattern '*.skill' --clobber
```

Omit `<tag>` for the latest release. Download with `gh`, never a browser, into the session scratchpad: the browser upload tool rejects files outside session-shared folders.

## 3. Match and confirm

Open `https://claude.ai/customize/skills/yours` in a new tab. The list has several sections; only the one holding skills you created is replaceable. Match each asset to a row by skill name. Open a matched row: its URL becomes `.../customize/skills/yours/id/<skill_id>`. Note the skill's current version.

Show a table of assets that will replace a skill, and assets with no match (reported, never created). Ask once before uploading. Replacing overwrites a live skill with the release's content, which may be older than what is there.

## 4. Replace each skill

For every confirmed skill:

1. Navigate to `<detail url>/replace`. Use this path, not the three-dot menu: menu labels vary with the UI language.
2. Locate the page's file input with `find`, and set the downloaded file with the file-upload tool. Never click the drop zone: it opens a native picker you can't drive.
3. A preview appears under the drop zone. Check that its title matches the skill being replaced; if not, cancel and report it, since uploading would replace this skill with different content.
4. Click the page's primary upload button (the one that appeared after the preview), then screenshot the result.
5. Reopen the skill's detail page and confirm the version number went up.

If a step fails twice, stop that skill, report what you saw, and continue with the next. Never re-click upload without first checking the skill's current version.

## 5. Report

One table: skill, previous version, new version, result. List unmatched assets and any failures. Close the tab you opened.
