# scooter-skills

A [Claude Code](https://docs.claude.com/en/docs/claude-code) plugin that lets
a local agent hand tasks to [Scooter](https://github.com/chadac-me/scooter)
and follow them: start a conversation, wait for it, relay approvals and
questions to you, and report back.

## Install

1. Install the `scooter` CLI and sign in:

   ```sh
   nix profile install github:chadac-me/scooter-cli   # or a release binary
   scooter login --server home --url https://scooter.example.org --cookie
   ```

   See [scooter-cli](https://github.com/chadac-me/scooter-cli) for OIDC
   sign-in and the other commands.

2. In Claude Code:

   ```
   /plugin marketplace add chadac-me/scooter-skills
   /plugin install scooter@scooter
   ```

## Use

Ask for it ("give this to Scooter") or run `/scooter <task>`. The agent
writes a brief the remote agent can work from on its own, starts the
conversation, gives you its link, and waits in the background. It never
answers approvals or questions for you; it passes them on with the link.
It asks before cancelling or suspending a conversation.

When the plugin starts, a hook checks that `scooter` is installed and signed
in, and tells the agent if not.

## Develop

`nix develop -c just ci` checks the manifests, the hook script and the
skill frontmatter.
