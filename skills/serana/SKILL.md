---
name: serana
description: "Use when asked to set up or introduce Serena in a project, add Serena language servers, onboard Serena, or give agents durable code-verified repo knowledge via Serena memories (vs a docs bundle). Generic — not scoped to one project."
---

# Serena Setup

Serena gives coding agents LSP-backed symbolic tools plus a project memory system (`.serena/memories/*.md`): durable, non-obvious repo knowledge that survives sessions. This bootstraps both. Keeping memory content fresh afterwards is the agent's job on each change (the `remind` hook nudges it).

## Procedure

1. **Confirm Serena MCP is registered** — `mcp__serena__*` tools available this session. If not, fetch the current install command from Serena's client docs (`https://raw.githubusercontent.com/oraios/serena/main/docs/02-usage/030_clients.md` or its successor) and quote the `serena setup <client>` / `<client> mcp add … serena start-mcp-server --context <client>` line; stop until it connects.

2. **Register language servers** in `.serena/project.yml` (Serena creates it on activation). Set `language_servers` to the languages actually in the repo — detect them (files per extension; `angular.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `tsconfig.json`). Fetch valid ids from the comment atop `project.yml` or Serena's `LanguageServerId` enum (`src/solidlsp/ls_config.py`) — don't hardcode; ids get added.
   - **Ordering:** the first server supporting a file serves it; the first entry is the default/fallback. When two servers claim one extension (e.g. `angular` and `typescript` both serve `.ts`), a flat list can't scope per-subfolder — order deliberately and record the tradeoff (a memory or `project.yml` comment).
   - **Prerequisites gate startup:** e.g. `angular` needs `npm install` in the Angular root; TS/svelte/vue/deno need node/deno on PATH. Check Serena's language docs; note any unmet prerequisite rather than assuming the server starts.

3. **Version-control `.serena/`** so settings and memories are shared across team/worktrees. `.serena/.gitignore` must ignore `/cache` and `/project.local.yml`; keep `project.yml` + `memories/` tracked. Confirm `project.yml` holds no secrets or machine-specific absolute paths.

4. **Onboarding → memories.** Call the `onboarding` tool for the target layout (usually `core`, `tech_stack`, `suggested_commands`, `conventions`, `task_completion`, plus per-module `<module>/core`). Read the seeded `memory_maintenance` first and follow its style: dense agent notes, durable + non-obvious only, a graph rooted at `core`, no volatile line-level detail. **Verify every claim against the code before writing it** — never propagate an inherited doc's assertion unchecked. Write with `write_memory`. Migrating from an existing agent-docs bundle: compress to memory altitude, re-verify, then repoint dangling references (in `CLAUDE.md`, code comments) at the new `mem:…`.

5. **Index large projects (optional):** run `serena project index` once to pre-cache symbols and avoid a slow first tool call. Writes only to the gitignored `.serena/cache`.

6. **Install the recommended Claude Code hooks.** Fetch the current block from step 1's docs page rather than trusting this list; normally four `serena-hooks` commands merged into `.claude/settings.json` (project level):
   - `PreToolUse` `""` → `serena-hooks remind --client=<client>`
   - `PreToolUse` `mcp__serena__*` → `serena-hooks auto-approve --client=<client>` — relaxes permissions; get explicit approval before adding it
   - `SessionStart` `""` → `serena-hooks activate --client=<client>`
   - `SessionEnd` `""` → `serena-hooks cleanup --client=<client>`

   Needs the `serena-hooks` CLI on PATH where the client runs (ships with Serena). Validate the written file — `jq` may be absent — with `python -c "import json; json.load(open('.claude/settings.json'))"`, confirm the commands landed, then point the user at `/hooks`.

7. **Report:** language servers registered (and any unmet prerequisite), memories written, whether indexed, and hooks added or already present.
