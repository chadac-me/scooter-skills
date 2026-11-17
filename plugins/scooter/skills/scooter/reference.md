# scooter CLI reference

Flags may come before or after arguments. `--server NAME|URL` picks a server
(default: `$SCOOTER_SERVER`, then the configured default). `PROMPT` may be
`-` to read stdin. Exit codes: 0 ok, 1 error, 2 usage, 3 login needed.

| Command | Does |
|---|---|
| `scooter servers` | configured servers: `name`, `url`, `auth`, `default`, `signed_in` |
| `scooter ls [--active] [--all] [--limit N]` | your conversations, newest first |
| `scooter new [--project] [--title T] [--model M] [--private] [--wait] PROMPT` | start one; `{id, url}`, or a wait result with `--wait` |
| `scooter send [--wait] ID PROMPT` | add a message; `{id, url}`, or a wait result |
| `scooter wait [--timeout 10m] ID` | block until the turn ends or needs the user |
| `scooter show [--last 5] ID` | state, pending requests, recent messages |
| `scooter cancel ID` | stop the running turn (ask the user first) |
| `scooter suspend ID` | suspend the sandbox (ask the user first) |
| `scooter url ID` | the web UI link, as plain text |
| `scooter login ...` | the user's job, not yours |

`--timeout 0` waits forever. `--project` adds "I'm working in REMOTE on
branch B; clone it" to the prompt.

## Wait result

```json
{
  "id": "c9e97f62-...",
  "state": "needs_user",
  "last_message": "I need AWS access to read the bucket.",
  "pending": [
    {"id": "t1", "kind": "approval", "message": "AWS access: s3:GetObject on ..."},
    {"id": "q1", "kind": "questions", "message": "Which DB?",
     "questions": [{"question": "Which DB?", "header": "DB",
                    "options": [{"label": "Postgres"}, {"label": "SQLite"}]}]}
  ],
  "url": "https://scooter.example.org/chat/c9e97f62-..."
}
```

`state` is `idle`, `running`, `needs_user` or `error`; `error` holds the
failure message when there is one. `show` adds `title`, `sandbox` (its status, such as
`running` or `suspended`) and `messages` (`{role, text}`; long texts truncated).

## ls entry

```json
{"id": "...", "title": "Fix flaky login test", "sandbox": "running",
 "state": "running", "last_activity": "2026-11-17T18:30:00Z", "url": "..."}
```
