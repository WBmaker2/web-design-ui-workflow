# Web Design UI Workflow — global Codex installer

This bundle installs four user-global Codex components into `${CODEX_HOME:-$HOME/.codex}`:

- `frontend-design`
- `frontend-ui-standards`
- `accessibility`
- `web-design-ui-workflow`

It also registers Playwright MCP as `playwright`, pinned to `@playwright/mcp@0.0.81` with headless, isolated, and WebMCP-disabled settings. Playwright uses its default Chromium browser.

## Install

```bash
chmod +x install.sh
./install.sh
```

Restart Codex Desktop or the Codex CLI after installation if skills are not refreshed automatically.

## Verify

```bash
${CODEX_HOME:-$HOME/.codex}/skills/web-design-ui-workflow/scripts/doctor.sh
```

## Use

```text
$web-design-ui-workflow
Create or improve this web interface, apply the child skills in order, and verify it with Playwright MCP.
```

The installer creates a timestamped backup under `${CODEX_HOME:-$HOME/.codex}/backups/web-design-ui-workflow/`. Run the `rollback.sh` in that backup folder to restore the previous state. Modified files are never deleted automatically during rollback.
