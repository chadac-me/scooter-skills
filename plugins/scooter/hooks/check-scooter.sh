#!/bin/sh
# Tells the agent when Scooter can't be used yet; silent when it can.
if ! command -v scooter >/dev/null 2>&1; then
  echo "Scooter plugin: the scooter CLI is not installed, so Scooter handoffs won't work. If the user asks for one, tell them to install it: nix profile install github:chadac-me/scooter-cli, or a release from https://github.com/chadac-me/scooter-cli/releases."
  exit 0
fi
if ! servers=$(scooter servers 2>/dev/null); then
  echo "Scooter plugin: this scooter CLI is too old for one-shot commands. If the user asks for a Scooter handoff, tell them to update it from https://github.com/chadac-me/scooter-cli."
  exit 0
fi
case "$servers" in
  *'"signed_in": true'*) ;;
  *) echo "Scooter plugin: no Scooter server is signed in. If the user asks for a handoff, tell them to run scooter login (see scooter login -h); you can't do it for them." ;;
esac
exit 0
