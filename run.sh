#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

export HOME=/data
mkdir -p /data/.claude

# Read addon config
MCP_URL=$(bashio::config 'mcp_url')
MODEL=$(bashio::config 'model')
AUTO_UPDATES=$(bashio::config 'auto_updates_channel')
NOTES=$(bashio::config 'notes')

# Build settings.json dynamically from addon config
cat > /data/.claude/settings.json << EOF
{
  "enabledPlugins": {
    "home-assistant-skills@home-assistant-skills": true
  },
  "extraKnownMarketplaces": {
    "home-assistant-skills": {
      "source": {
        "source": "github",
        "repo": "homeassistant-ai/skills"
      }
    }
  },
  "autoUpdatesChannel": "${AUTO_UPDATES}",
  "permissions": {
    "allow": [
      "mcp__ha__*",
      "Read(**)",
      "Edit(**)",
      "Write(**)",
      "Bash(*)",
      "WebSearch(*)",
      "WebFetch(*)"
    ],
    "deny": [
      "Read(/config/secrets.yaml)"
    ]
  }
}
EOF

# Write CLAUDE.md into /config (working directory)
cat > /config/CLAUDE.md << EOF
# Home Assistant — Claude Context

## Environment
- Working directory: /config (Home Assistant configuration)
- MCP server connected: ${MCP_URL}
- All HA entities, automations, scripts and dashboards are accessible via MCP tools

## Key conventions
- Use \`entity_id\` in triggers and actions, never \`device_id\`
- Dashboard edits: prefer \`python_transform\` over full config replacement
- Blueprints are stored in \`/config/blueprints/automation/homeassistant/\`

## Backups
- Before performing critical refactoring (removing or restructuring automations, scripts, dashboards, or configuration files), check when the last backup was created. Only ask the user whether a backup should be created if no backup exists from the recent past.

## Learning
- When an MCP tool call fails or behaves unexpectedly, identify the correct usage and save it to memory before retrying. This prevents repeating the same mistake in future sessions.

## Restrictions
- Never read or output the contents of /config/secrets.yaml

## Notes
${NOTES}
EOF

# Write MCP server config
cat > /config/.mcp.json << EOF
{
  "mcpServers": {
    "ha": {
      "type": "http",
      "url": "${MCP_URL}"
    }
  }
}
EOF

# Build claude CLI flags
CLAUDE_FLAGS=""
if find /data/.claude/projects -name "*.jsonl" 2>/dev/null | grep -q .; then
  CLAUDE_FLAGS="--continue"
fi
if bashio::config.has_value 'model'; then
  CLAUDE_FLAGS="${CLAUDE_FLAGS} --model ${MODEL}"
fi

bashio::log.info "Starting Claude Code (model: ${MODEL})"

exec ttyd \
  --port 7681 \
  --writable \
  tmux new-session -A -s claude bash -c "cd /config && claude ${CLAUDE_FLAGS}; exec bash"
