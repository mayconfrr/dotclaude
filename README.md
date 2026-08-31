# dotclaude

Personal [Claude Code](https://claude.com/claude-code) setup — skills and global
config — kept here so they can be versioned, shared, and pulled onto any machine.

## Skills

| Skill | What it does |
|---|---|
| [`implement`](skills/implement/SKILL.md) | Drives a code change end-to-end — brainstorm, plan, subagent-driven execution, whole-branch review, PR — without stopping for step-by-step approval. |
| [`instruction-audit`](skills/instruction-audit/SKILL.md) | Audits a skill file, CLAUDE.md, or hook instruction text for anything that isn't load-bearing — development narration, redundant restatement, verbose phrasing — verifies its facts, duplicates, and contradictions, and compacts what survives. |
| [`okf`](skills/okf/SKILL.md) | Introduces [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) to a project — scaffolds a `docs/` knowledge bundle, authors the base concepts, wires the freshness hooks, and installs a curation skill — giving agents durable repo knowledge that ships in git. |
| [`serana`](skills/serana/SKILL.md) | Sets up [Serena](https://github.com/oraios/serena) in a project — registers language servers, seeds onboarding memories, and installs the recommended Claude Code hooks — giving agents durable, code-verified repo knowledge. |
| [`visual-spec`](skills/visual-spec/SKILL.md) | Turns a stakeholder request, feature ask, or bug into an implementation-ready spec — grounded in the real codebase, gaps hunted and confirmed with the user, presented as a designed, diagrammed Artifact — then shipped as a markdown doc and/or GitHub issue. |

## Prerequisites

| Skill | Needs |
|---|---|
| `implement` | The [`superpowers`](https://github.com/obra/superpowers-marketplace) plugin marketplace (brainstorming, writing-plans, subagent-driven-development, etc.) and the [`gh`](https://cli.github.com/) CLI. `code-review` and `simplify` ship bundled with Claude Code — no separate install. |
| `instruction-audit` | None required; uses `skill-creator`'s `quick_validate.py` if that plugin is installed, but works without it. |
| `okf` | None required — scaffolds plain markdown and wires Claude Code hooks, both built in. Network access to fetch the OKF spec is helpful but not essential. |
| `serana` | The Serena MCP server registered (`mcp__serena__*` tools); network access to fetch its client-setup and hooks docs; the `serena-hooks` CLI on PATH for the hooks step. |
| `visual-spec` | The `artifact-design`, `artifact-diagramming`, `artifact-capabilities`, and `dataviz` skills, which ship bundled with Claude Code, plus `brainstorming` from the [`superpowers`](https://github.com/obra/superpowers-marketplace) plugin marketplace. |

## Using a skill

Drop a skill's folder into `~/.claude/skills/<name>/` (global) or
`<project>/.claude/skills/<name>/` (project-scoped) so Claude Code picks it up.

## Global config

The repo is rooted directly at `~/.claude/` behind a deny-by-default
`.gitignore` — nothing is tracked unless explicitly allow-listed, so session
state, caches, and credentials stay out (none of those are, or ever will be, in
this repo). The allow-listed personal-setup files are `CLAUDE.md` and
`settings.json`.

**`settings.json` runs with `permissions.defaultMode: "bypassPermissions"`** —
every tool call executes with no confirmation prompt. That's a deliberate
choice for this machine; copying this file elsewhere inherits that with it —
know what it does before you do.

## Uploading to claude.ai

Every push to `main` packages each skill into a `<name>.skill` file, published to
the [`latest` release](../../releases/tag/latest). Despite the extension it's a
standard zip — download it and upload as-is via claude.ai's Settings → Skills →
Create skill.
