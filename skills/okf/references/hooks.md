# Freshness-loop hooks (Claude Code)

Two project-level hooks in the target project's `.claude/settings.json` keep its
OKF bundle current. They assume the bundle root is `docs/` and a POSIX shell
(adjust the commands if the target runs hooks under Windows cmd/PowerShell).
Merge into any existing `hooks` arrays — don't replace them. Add with the user's
approval; the `Stop` hook runs at every turn end.

After editing, validate:
`python -c "import json; json.load(open('.claude/settings.json'))"`, confirm both
landed, then point the user at `/hooks`.

## Read-before — `SessionStart`

Injects a reminder to consult the bundle before editing.

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"This project keeps an OKF knowledge bundle in docs/. Before changing code in an area, read the matching docs/<area>/ concepts (start at docs/index.md); if a concept is missing or past its stale_after, refresh it first.\"}}'"
          }
        ]
      }
    ]
  }
}
```

## Update-after — `Stop`

Fires at end of turn; nudges *only* when code changed but `docs/` did not, so it
stays quiet on turns that don't touch code.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "P=$(git status --porcelain 2>/dev/null | sed 's/^...//; s/.* -> //'); NONDOCS=$(printf '%s\\n' \"$P\" | grep -vE '^docs/|^$'); DOCS=$(printf '%s\\n' \"$P\" | grep -E '^docs/'); [ -n \"$NONDOCS\" ] && [ -z \"$DOCS\" ] && echo '{\"hookSpecificOutput\":{\"hookEventName\":\"Stop\",\"additionalContext\":\"Code changed but docs/ did not. If any change added or altered durable knowledge, update the matching OKF concept before finishing: bump generated.at, refresh the area index.md, append log.md.\"}}'; true"
          }
        ]
      }
    ]
  }
}
```

## Notes

- `sed 's/^...//; s/.* -> //'` strips the two-column porcelain status prefix and
  resolves rename entries (`R old -> new`) to the new path.
- The `Stop` hook is a **reminder, not a gate** — the trailing `true` ensures it
  never fails the turn.
- The `git`-diff check assumes the bundle root is `docs/`. If the bundle lives
  elsewhere, change the `^docs/` patterns to that root.
- For precise per-file read enforcement, a `PreToolUse` hook on `Edit|Write`
  could inject the concept for the file being edited — heavier, and usually the
  `SessionStart` nudge is enough. Add it only if the read step is being skipped
  in practice.
