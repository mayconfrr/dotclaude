# claude-code-skills

Personal [Claude Code](https://claude.com/claude-code) skills, kept here so they can be
versioned, shared, and pulled into `~/.claude/skills` on any machine.

## Skills

| Skill | What it does |
|---|---|
| [`implement`](implement/SKILL.md) | Drives a code change end-to-end — brainstorm, plan, subagent-driven execution, whole-branch review, PR — without stopping for step-by-step approval. |
| [`okf`](okf/SKILL.md) | Bootstraps a project's [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog) bundle, or keeps an existing one's declared spec version current. |
| [`skill-audit`](skill-audit/SKILL.md) | Audits a skill file for prose that narrates its own development history instead of stating only the current, correct procedure. |

## Prerequisites

| Skill | Needs |
|---|---|
| `implement` | The [`superpowers`](https://github.com/obra/superpowers-marketplace) plugin marketplace (brainstorming, writing-plans, subagent-driven-development, etc.) and the [`gh`](https://cli.github.com/) CLI. `code-review` and `simplify` ship bundled with Claude Code — no separate install. |
| `okf` | Network access to fetch the spec; `jq` to validate the commit hook it installs. |
| `skill-audit` | None required; uses `skill-creator`'s `quick_validate.py` if that plugin is installed, but works without it. |

## Using a skill

Drop a skill's folder into `~/.claude/skills/<name>/` (global) or
`<project>/.claude/skills/<name>/` (project-scoped) so Claude Code picks it up.

## Uploading to claude.ai

Every push to `main` packages each skill into a `<name>.skill` file, published to
the [`latest` release](../../releases/tag/latest). Despite the extension it's a
standard zip — download it and upload as-is via claude.ai's Settings → Skills →
Create skill.
