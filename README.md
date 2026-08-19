# claude-code-skills

Personal [Claude Code](https://claude.com/claude-code) skills, kept here so they can be
versioned, shared, and pulled into `~/.claude/skills` on any machine.

## Skills

| Skill | What it does |
|---|---|
| [`implement`](implement/SKILL.md) | Drives a code change end-to-end — brainstorm, plan, subagent-driven execution, whole-branch review, PR — without stopping for step-by-step approval. |
| [`okf`](okf/SKILL.md) | Bootstraps a project's [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog) bundle, or keeps an existing one's declared spec version current. |
| [`skill-audit`](skill-audit/SKILL.md) | Audits a skill file for prose that narrates its own development history instead of stating only the current, correct procedure. |

## Using a skill

Drop a skill's folder into `~/.claude/skills/<name>/` (global) or
`<project>/.claude/skills/<name>/` (project-scoped) so Claude Code picks it up.

## Uploading to claude.ai

Every push to `main` packages each skill into a `<name>.skill` file, published to
the [`latest` release](../../releases/tag/latest). Despite the extension it's a
standard zip — download it and upload as-is via claude.ai's Settings → Skills →
Create skill.
