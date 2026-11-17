#!/bin/sh
# Runs the SessionStart hook against fake scooter binaries.
set -eu
hook="$(cd "$(dirname "$0")/.." && pwd)/plugins/scooter/hooks/check-scooter.sh"
bin=$(mktemp -d)
trap 'rm -rf "$bin"' EXIT
sh_path=$(command -v sh)

expect() { # name, wanted substring ("" for silence)
  out=$(PATH="$bin" "$sh_path" "$hook")
  if [ -z "$2" ] && [ -n "$out" ]; then echo "FAIL $1: expected silence, got: $out"; exit 1; fi
  case "$out" in *"$2"*) echo "ok $1" ;; *) echo "FAIL $1: got: $out"; exit 1 ;; esac
}
fake() { printf '#!%s\n%s\n' "$sh_path" "$1" > "$bin/scooter"; chmod +x "$bin/scooter"; }

expect "missing CLI" "not installed"
fake 'exit 2'
expect "old CLI" "too old"
fake 'echo "[{\"name\": \"home\", \"signed_in\": false}]"'
expect "signed out" "scooter login"
fake 'echo "[{\"name\": \"home\", \"signed_in\": true}]"'
expect "ready" ""
