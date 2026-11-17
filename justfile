# scooter-skills task runner: `just` with no args lists recipes.

default:
    @just --list

# Every JSON manifest parses.
check-json:
    for f in .claude-plugin/marketplace.json plugins/*/.claude-plugin/plugin.json plugins/*/hooks/hooks.json; do jq empty "$f" || exit 1; done

# Hook scripts pass shellcheck and are executable.
check-hooks:
    shellcheck plugins/*/hooks/*.sh test/*.sh
    for f in plugins/*/hooks/*.sh; do test -x "$f" || { echo "$f is not executable"; exit 1; }; done

# Each plugin the marketplace lists exists, and its skills have frontmatter.
check-layout:
    for p in $(jq -r '.plugins[].source' .claude-plugin/marketplace.json); do test -f "$p/.claude-plugin/plugin.json" || exit 1; done
    for f in plugins/*/skills/*/SKILL.md; do head -1 "$f" | grep -qx -- --- && grep -q '^name: ' "$f" && grep -q '^description: ' "$f" || { echo "$f: bad frontmatter"; exit 1; }; done

# The SessionStart hook says the right thing with and without a CLI.
test-hook:
    ./test/hook-test.sh

ci: check-json check-hooks check-layout test-hook
    @echo "✅ ci passed"
