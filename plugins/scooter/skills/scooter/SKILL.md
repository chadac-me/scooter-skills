---
name: scooter
description: Hand a task to Scooter (a remote coding agent with its own sandbox) and follow it with the scooter CLI. Use when the user asks to send, delegate or hand off work to Scooter, asks how a Scooter task is going, or when a task needs what only Scooter has (cluster or cloud access, hours of runtime, work that should outlive this session). Covers starting conversations, waiting on them, relaying approvals and reporting back.
---

# Scooter handoffs

Scooter runs a coding agent in a remote sandbox, one per conversation. The
`scooter` CLI starts and follows those conversations. Every command prints
JSON. [reference.md](reference.md) lists the commands and their output.

## When to delegate

- The user asks you to ("give this to Scooter", "/scooter ...").
- The task needs something Scooter has and you don't: cluster or cloud
  access, a long runtime, or it should keep going after this session ends.
  Suggest the handoff and say why. Don't hand off on your own initiative.

Everything else you do yourself, locally.

## Write a brief that stands alone

The remote agent can't see this chat or this machine. Its first message must
say:

- the repo and branch to work on. Pass `--project` to name the current
  repo's remote and branch. Uncommitted or unpushed work doesn't travel, so
  push a branch first (ask the user if pushing isn't clearly fine);
- the goal, and the facts you already found (file paths, error messages,
  what you tried);
- what "done" looks like: a PR, a report, a deployed fix.

## Start and follow

```sh
scooter new --project --title "Fix flaky login test" - <<'EOF'
<the brief>
EOF
```

Tell the user the conversation `url`. Then follow it with
`scooter wait ID`, run in the background (Bash `run_in_background`). You are
woken when it exits. Never loop over `show` or `sleep`. To add to a running
task, use `scooter send ID "..."`, or `send --wait` to send and wait in one
step.

`wait` returns a `state`:

- `idle`: the turn ended. Read `last_message`, then report.
- `needs_user`: the remote agent waits on the approvals or questions in
  `pending`. Relay them to the user with the `url`, then stop. **Never answer
  or approve them yourself**: grants and approvals are the user's decision,
  made in Scooter's web UI. Once the user says they answered, `wait` again.
- `error`: the run failed. Report `error`.
- `running`: the timeout passed. Wait again if the user still wants you to.

## Ask first

Starting, messaging and waiting need no confirmation. `scooter cancel` and
`scooter suspend` do: ask the user before either one.

## Report back

Summarise what the remote agent did in a few lines and link its PRs and the
conversation `url`. Don't paste the transcript. For more detail, run
`scooter show ID --last N`.

## Keep track

Remember the ids of the conversations you started. If you lose track,
`scooter ls --active` lists the user's running ones.

## When the CLI fails

- Exit code 3 means a login is missing or expired. Tell the user to run
  `scooter login` (it may open a browser or ask for a cookie). You can't do
  it for them.
- `no server`: the user hasn't configured one. Point them at `scooter login -h`.
