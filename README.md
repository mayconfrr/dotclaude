# dotclaude

Personal [Claude Code](https://claude.com/claude-code) setup — skills and global
config — kept here so they can be versioned, shared, and pulled onto any machine.

## Skills

| Skill | What it does |
|---|---|
| [`implement`](skills/implement/SKILL.md) | Drives a code change end-to-end — brainstorm, plan, subagent-driven execution, whole-branch review, PR — without stopping for step-by-step approval. |
| [`okf`](skills/okf/SKILL.md) | Bootstraps a project's [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog) bundle, or keeps an existing one's declared spec version current. |
| [`instruction-audit`](skills/instruction-audit/SKILL.md) | Audits a skill file or CLAUDE.md for anything that isn't load-bearing — development narration, redundant restatement, verbose phrasing — verifies its facts, duplicates, and contradictions, and compacts what survives. |
| [`visual-spec`](skills/visual-spec/SKILL.md) | Turns a stakeholder request, feature ask, or bug into an implementation-ready spec — grounded in the real codebase, gaps hunted and confirmed with the user, presented as a designed, diagrammed Artifact — then shipped as a markdown doc and/or GitHub issue. |

## Prerequisites

| Skill | Needs |
|---|---|
| `implement` | The [`superpowers`](https://github.com/obra/superpowers-marketplace) plugin marketplace (brainstorming, writing-plans, subagent-driven-development, etc.) and the [`gh`](https://cli.github.com/) CLI. `code-review` and `simplify` ship bundled with Claude Code — no separate install. |
| `okf` | Network access to fetch the spec; `jq` to validate the commit hook it installs. |
| `instruction-audit` | None required; uses `skill-creator`'s `quick_validate.py` if that plugin is installed, but works without it. |
| `visual-spec` | The `artifact-design`, `artifact-diagramming`, `artifact-capabilities`, and `dataviz` skills, which ship bundled with Claude Code, plus `brainstorming` from the [`superpowers`](https://github.com/obra/superpowers-marketplace) plugin marketplace. |

## Using a skill

Drop a skill's folder into `~/.claude/skills/<name>/` (global) or
`<project>/.claude/skills/<name>/` (project-scoped) so Claude Code picks it up.

## Global config

`global-config/` mirrors select files from `~/.claude/` — the personal-setup
ones, not session state, caches, or credentials (none of those are, or ever
will be, in this repo). Currently: `CLAUDE.md` and `settings.json`.

**`settings.json` runs with `permissions.defaultMode: "bypassPermissions"`** —
every tool call executes with no confirmation prompt. That's a deliberate
choice for this machine; copying this file elsewhere inherits that with it —
know what it does before you do.

## Uploading to claude.ai

Every push to `main` packages each skill into a `<name>.skill` file, published to
the [`latest` release](../../releases/tag/latest). Despite the extension it's a
standard zip — download it and upload as-is via claude.ai's Settings → Skills →
Create skill.
