# Claude Home

Claude Code running directly inside Home Assistant — with a browser-based terminal, full access to `/config`, and the HA MCP server.

---

## Warning

**Use at your own risk.**

- Always create a full Home Assistant backup before using Claude Home.
- Claude has direct access to all entities and can switch devices on or off. Misunderstood instructions can cause unexpected actions.
- The loop feature runs unattended in the background. Review the configured task carefully and monitor its behavior, especially during initial setup.

---

## Configuration

| Option | Description |
|--------|-------------|
| `mcp_url` | Full URL to the HA MCP server including auth token, e.g. `https://your-ha/mcp_server/sse?token=...` |
| `model` | Claude model: `claude-opus-4-6` (most capable), `claude-sonnet-4-6` (fast & smart), `claude-haiku-4-5-20251001` (fastest) |
| `auto_updates_channel` | Update channel: `latest` (stable) or `beta` |
| `notes` | Free-text context passed to Claude at the start of every session — describe your setup, rooms, devices, or preferences |
| `loop_enabled` | Enable the periodic task loop |
| `loop_interval` | How often the loop runs (minutes) |
| `loop_start_delay` | Seconds to wait after session start before the loop activates |
| `loop_task` | What Claude should do on each loop iteration (plain text) |

---

## First Start / Login

Claude Home needs to be authenticated once on first start:

1. Start the addon and open it from the sidebar
2. Claude starts automatically and displays an authentication URL
3. **Hold Shift** and select the URL with the mouse, then copy it (Ctrl+C or right-click → Copy)
4. Open the URL in a browser, log in with your Claude.ai Pro account, and authorize the device
5. Done — credentials are stored in `/data/.claude/` and persist across updates and restarts

> **Note:** Holding Shift while selecting bypasses tmux's mouse mode and lets the browser handle the copy normally.

---

## Sessions

The terminal runs inside a tmux session named `claude`. The session starts when the container starts — regardless of whether the web panel is open. Opening the sidebar panel attaches to the running session. After a restart, the last conversation is automatically resumed.

---

## Periodic Loop

When `loop_enabled` is active, Claude automatically starts a loop after `loop_start_delay` seconds. The loop runs every `loop_interval` minutes and executes the configured task. It self-renews before the 3-day Claude Code session limit is reached and runs indefinitely as long as the addon is active.

---

## Slash Commands

| Command | Function |
|---------|---------|
| `/ha-backup` | Check last backup age, create a new one if needed |
| `/ha-check` | Validate the HA configuration |
| `/ha-restart` | Restart Home Assistant (with confirmation) |
| `/ha-log` | Display logbook entries |
| `/ha-discover` | Scan the full HA environment and save an overview to memory |
| `/ha-optimize` | Analyse the setup for optimization opportunities |
| `/ha-loop-start` | Start the periodic loop manually |

---

## Included Plugins

- **home-assistant-skills** — Best practices for HA automations, helpers, scripts, and dashboards
