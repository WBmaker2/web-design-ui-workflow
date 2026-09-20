#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CODEX_ROOT=${CODEX_HOME:-"$HOME/.codex"}
SKILLS="$CODEX_ROOT/skills"
CONFIG="$CODEX_ROOT/config.toml"
LOCK="$CODEX_ROOT/web-design-ui-workflow.lock.json"
STAMP=$(TZ=Asia/Seoul date '+%Y%m%dT%H%M%S%z')
BACKUP="$CODEX_ROOT/backups/web-design-ui-workflow/$STAMP"
STAGE="$CODEX_ROOT/.stage-web-design-ui-workflow-$STAMP"

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

hash_stream() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | awk '{print $1}'
  else
    shasum -a 256 | awk '{print $1}'
  fi
}

digest_dir() {
  dir=$1
  (
    cd "$dir"
    find . -type f | LC_ALL=C sort | while IFS= read -r file; do
      printf '%s  %s\n' "$(hash_file "$file")" "$file"
    done
  ) | hash_stream
}

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

command -v node >/dev/null 2>&1 || fail "Node.js is required."
node_major=$(node -p 'process.versions.node.split(".")[0]')
[ "$node_major" -ge 18 ] || fail "Node.js 18 or newer is required."
command -v npx >/dev/null 2>&1 || fail "npx is required."

for name in frontend-design frontend-ui-standards accessibility web-design-ui-workflow; do
  [ -f "$SCRIPT_DIR/skills/$name/SKILL.md" ] || fail "Bundle is missing skills/$name/SKILL.md"
done

# Refuse to rewrite an unrelated Playwright server configuration.
if [ -f "$CONFIG" ] && grep -Eq '^\[mcp_servers\.playwright\][[:space:]]*$' "$CONFIG"; then
  if ! grep -Fq '@playwright/mcp@0.0.81' "$CONFIG" || \
     ! grep -Fq '"--headless"' "$CONFIG" || \
     ! grep -Fq '"--isolated"' "$CONFIG" || \
     ! grep -Fq '"--no-webmcp"' "$CONFIG"; then
    fail "An existing [mcp_servers.playwright] section differs from this bundle. Review $CONFIG manually; nothing was changed."
  fi
fi

umask 022
mkdir -p "$SKILLS" "$BACKUP" "$STAGE"
cleanup() { rm -rf "$STAGE"; }
trap cleanup EXIT HUP INT TERM

had_config=0
had_lock=0
if [ -f "$CONFIG" ]; then
  had_config=1
  cp -p "$CONFIG" "$BACKUP/config.toml.before"
else
  printf 'No pre-existing config.toml.\n' > "$BACKUP/config.toml.before.absent"
fi
if [ -f "$LOCK" ]; then
  had_lock=1
  cp -p "$LOCK" "$BACKUP/lock.before.json"
fi

mkdir -p "$BACKUP/skills"
for name in frontend-design frontend-ui-standards accessibility web-design-ui-workflow; do
  if [ -e "$SKILLS/$name" ]; then
    cp -a "$SKILLS/$name" "$BACKUP/skills/$name"
  fi
  cp -a "$SCRIPT_DIR/skills/$name" "$STAGE/$name"
done

for name in frontend-design frontend-ui-standards accessibility web-design-ui-workflow; do
  rm -rf "$SKILLS/$name"
  mv "$STAGE/$name" "$SKILLS/$name"
done

if [ ! -f "$CONFIG" ]; then
  cp "$SCRIPT_DIR/config-snippet.toml" "$CONFIG"
elif ! grep -Eq '^\[mcp_servers\.playwright\][[:space:]]*$' "$CONFIG"; then
  printf '\n' >> "$CONFIG"
  cat "$SCRIPT_DIR/config-snippet.toml" >> "$CONFIG"
fi

fd_digest=$(digest_dir "$SKILLS/frontend-design")
ui_digest=$(digest_dir "$SKILLS/frontend-ui-standards")
a11y_digest=$(digest_dir "$SKILLS/accessibility")
workflow_digest=$(digest_dir "$SKILLS/web-design-ui-workflow")
config_sha=$(hash_file "$CONFIG")

cat > "$LOCK" <<LOCK_EOF
{
  "schema_version": 1,
  "installed_at": "$STAMP",
  "codex_home": "$CODEX_ROOT",
  "orchestrator": {
    "name": "web-design-ui-workflow",
    "path": "$SKILLS/web-design-ui-workflow",
    "digest_sha256": "$workflow_digest"
  },
  "dependencies": {
    "frontend-design": {
      "repository": "https://github.com/Ilm-Alan/frontend-design",
      "commit": "1641823c70438a5ca36e2a5ea43f6154e3e70b81",
      "license": "MIT",
      "digest_sha256": "$fd_digest"
    },
    "frontend-ui-standards": {
      "repository": "https://github.com/MaxHan7/frontend-ui-standards-skill",
      "commit": "0609cb07793ee1f8f6626c98042ee2e811f81735",
      "license": "MIT",
      "digest_sha256": "$ui_digest"
    },
    "accessibility": {
      "repository": "https://github.com/KreerC/ACCESSIBILITY.md",
      "commit": "2bf8ddcf87e09dd0caac609abb979cc19aca2555",
      "license": "MIT",
      "digest_sha256": "$a11y_digest"
    },
    "playwright-mcp": {
      "package": "@playwright/mcp",
      "version": "0.0.81",
      "license": "Apache-2.0",
      "server_name": "playwright",
      "mode": ["headless", "isolated", "no-webmcp"],
      "browser": "default Playwright Chromium"
    }
  },
  "config_sha256": "$config_sha",
  "backup_path": "$BACKUP"
}
LOCK_EOF
lock_sha=$(hash_file "$LOCK")

cat > "$BACKUP/install-state.env" <<STATE_EOF
CODEX_HOME_AT_INSTALL='$CODEX_ROOT'
HAD_CONFIG='$had_config'
HAD_LOCK='$had_lock'
INSTALLED_CONFIG_SHA='$config_sha'
INSTALLED_LOCK_SHA='$lock_sha'
FRONTEND_DESIGN_DIGEST='$fd_digest'
FRONTEND_UI_STANDARDS_DIGEST='$ui_digest'
ACCESSIBILITY_DIGEST='$a11y_digest'
WORKFLOW_DIGEST='$workflow_digest'
STATE_EOF

cat > "$BACKUP/rollback.sh" <<'ROLLBACK_EOF'
#!/bin/sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$HERE/install-state.env"
CODEX_ROOT=${CODEX_HOME:-$CODEX_HOME_AT_INSTALL}
SKILLS="$CODEX_ROOT/skills"
CONFIG="$CODEX_ROOT/config.toml"
LOCK="$CODEX_ROOT/web-design-ui-workflow.lock.json"
changed=0

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'; else shasum -a 256 "$1" | awk '{print $1}'; fi
}
hash_stream() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum | awk '{print $1}'; else shasum -a 256 | awk '{print $1}'; fi
}
digest_dir() {
  dir=$1
  (cd "$dir"; find . -type f | LC_ALL=C sort | while IFS= read -r file; do printf '%s  %s\n' "$(hash_file "$file")" "$file"; done) | hash_stream
}
remove_or_restore_skill() {
  name=$1
  expected=$2
  current="$SKILLS/$name"
  previous="$HERE/skills/$name"
  if [ -d "$current" ]; then
    actual=$(digest_dir "$current")
    if [ "$actual" != "$expected" ]; then
      printf 'SKIP modified skill: %s\n' "$current" >&2
      changed=1
      return
    fi
    rm -rf "$current"
  fi
  if [ -d "$previous" ]; then
    cp -a "$previous" "$current"
    printf 'RESTORE %s\n' "$current"
  else
    printf 'REMOVE %s\n' "$current"
  fi
}

remove_or_restore_skill frontend-design "$FRONTEND_DESIGN_DIGEST"
remove_or_restore_skill frontend-ui-standards "$FRONTEND_UI_STANDARDS_DIGEST"
remove_or_restore_skill accessibility "$ACCESSIBILITY_DIGEST"
remove_or_restore_skill web-design-ui-workflow "$WORKFLOW_DIGEST"

if [ -f "$CONFIG" ]; then
  actual_config=$(hash_file "$CONFIG")
  if [ "$actual_config" = "$INSTALLED_CONFIG_SHA" ]; then
    if [ "$HAD_CONFIG" = "1" ] && [ -f "$HERE/config.toml.before" ]; then cp -p "$HERE/config.toml.before" "$CONFIG"; printf 'RESTORE %s\n' "$CONFIG"; else rm -f "$CONFIG"; printf 'REMOVE %s\n' "$CONFIG"; fi
  else
    printf 'SKIP modified config: %s\n' "$CONFIG" >&2
    changed=1
  fi
fi

if [ -f "$LOCK" ]; then
  actual_lock=$(hash_file "$LOCK")
  if [ "$actual_lock" = "$INSTALLED_LOCK_SHA" ]; then
    if [ "$HAD_LOCK" = "1" ] && [ -f "$HERE/lock.before.json" ]; then cp -p "$HERE/lock.before.json" "$LOCK"; printf 'RESTORE %s\n' "$LOCK"; else rm -f "$LOCK"; printf 'REMOVE %s\n' "$LOCK"; fi
  else
    printf 'SKIP modified lock file: %s\n' "$LOCK" >&2
    changed=1
  fi
fi

if [ "$changed" -ne 0 ]; then printf 'Rollback left modified files untouched.\n' >&2; exit 1; fi
printf 'Rollback completed.\n'
ROLLBACK_EOF
chmod 755 "$BACKUP/rollback.sh" "$SKILLS/web-design-ui-workflow/scripts/doctor.sh"

"$SKILLS/web-design-ui-workflow/scripts/doctor.sh"
printf '\nInstalled web-design-ui-workflow globally in %s\n' "$CODEX_ROOT"
printf 'Rollback: %s/rollback.sh\n' "$BACKUP"
