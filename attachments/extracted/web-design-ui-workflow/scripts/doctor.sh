#!/bin/sh
set -eu

CODEX_ROOT=${CODEX_HOME:-"$HOME/.codex"}
SKILLS_ROOT="$CODEX_ROOT/skills"
CONFIG_FILE="$CODEX_ROOT/config.toml"
EXPECTED_MCP='@playwright/mcp@0.0.81'
errors=0
warnings=0

ok() { printf 'OK   %s\n' "$1"; }
warn() { printf 'WARN %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf 'FAIL %s\n' "$1"; errors=$((errors + 1)); }

printf 'Web Design UI Workflow doctor\n'
printf 'CODEX_HOME=%s\n\n' "$CODEX_ROOT"

if command -v node >/dev/null 2>&1; then
  node_version=$(node -p 'process.versions.node' 2>/dev/null || printf 'unknown')
  node_major=$(printf '%s' "$node_version" | awk -F. '{print $1}')
  case "$node_major" in
    ''|*[!0-9]*) fail "Node.js version could not be parsed: $node_version" ;;
    *)
      if [ "$node_major" -ge 18 ]; then ok "Node.js $node_version (>=18)"; else fail "Node.js $node_version; Playwright MCP requires >=18"; fi
      ;;
  esac
else
  fail "node is not on PATH"
fi

if command -v npx >/dev/null 2>&1; then ok "npx is available"; else fail "npx is not on PATH"; fi
if command -v codex >/dev/null 2>&1; then ok "codex executable is available"; else warn "codex executable is not on PATH; Desktop may still load the same CODEX_HOME"; fi

for skill_name in frontend-design frontend-ui-standards accessibility web-design-ui-workflow; do
  skill_file="$SKILLS_ROOT/$skill_name/SKILL.md"
  if [ -f "$skill_file" ]; then
    declared=$(awk '/^name:[[:space:]]*/ {sub(/^name:[[:space:]]*/, ""); print; exit}' "$skill_file")
    if [ "$declared" = "$skill_name" ]; then
      ok "$skill_name is installed"
    else
      fail "$skill_name has mismatched frontmatter name: ${declared:-missing}"
    fi
  else
    fail "$skill_file is missing"
  fi
done

if [ -f "$CONFIG_FILE" ]; then
  if grep -Fq '[mcp_servers.playwright]' "$CONFIG_FILE"; then ok "Playwright MCP section is present"; else fail "Playwright MCP section is missing from $CONFIG_FILE"; fi
  if grep -Fq "$EXPECTED_MCP" "$CONFIG_FILE"; then ok "Playwright MCP is pinned to 0.0.81"; else fail "Expected $EXPECTED_MCP in $CONFIG_FILE"; fi
  if grep -Fq '"--headless"' "$CONFIG_FILE"; then ok "Playwright MCP headless mode is configured"; else fail "--headless is not configured"; fi
  if grep -Fq '"--isolated"' "$CONFIG_FILE"; then ok "Playwright MCP isolated mode is configured"; else fail "--isolated is not configured"; fi
  if grep -Fq '"--no-webmcp"' "$CONFIG_FILE"; then ok "Playwright MCP WebMCP collection is disabled"; else fail "--no-webmcp is not configured"; fi
else
  fail "$CONFIG_FILE is missing"
fi

printf '\nSummary: %s error(s), %s warning(s)\n' "$errors" "$warnings"
[ "$errors" -eq 0 ]
