#!/usr/bin/env bash
# Wire this machine up to the stack. Run once per machine, per account.
#   ./install.sh            plugins
#   ./install.sh --mcp      also register MCP servers
set -uo pipefail
REPO="${STACK_REPO:-arsimaz/ai-stack}"
ok(){ printf '  \033[32m✓\033[0m %s\n' "$*"; }
no(){ printf '  \033[31m✗\033[0m %s\n' "$*"; }

command -v claude >/dev/null || { no "claude CLI not found"; exit 1; }

# Each third-party plugin is installed from ITS OWN marketplace, not re-exported
# from ours. See README "Why upstream marketplaces" — re-exports clone over SSH
# and fail on any machine without a key.
echo "== marketplaces"
for m in "$REPO" obra/superpowers kepano/obsidian-skills \
         nextlevelbuilder/ui-ux-pro-max-skill thedotmack/claude-mem; do
  claude plugin marketplace add "$m" >/dev/null 2>&1 && ok "$m" || ok "$m (already present)"
done

echo "== plugins"
install_one(){ claude plugin install "$1" >/dev/null 2>&1 && ok "${1%%@*}" || no "${1%%@*} — claude plugin install $1"; }
install_one arsimaz-core@arsimaz
install_one superpowers@superpowers-dev
install_one obsidian@obsidian-skills
install_one ui-ux-pro-max@ui-ux-pro-max-skill
install_one claude-mem@thedotmack

echo
echo "  Omitted by weight — add explicitly if you want them:"
echo "    gsd-core  144 skills / 64 agents:"
echo "      claude plugin marketplace add open-gsd/gsd-core && claude plugin install gsd-core@gsd-core"
echo "    ecc       903 skills / 68 agents:"
echo "      claude plugin marketplace add affaan-m/everything-claude-code && claude plugin install ecc@ecc"

if [[ "${1:-}" == "--mcp" ]]; then
  echo "== mcp"
  if [[ -n "${N8N_API_URL:-}" && -n "${N8N_API_KEY:-}" ]]; then
    claude mcp add n8n-mcp -e N8N_API_URL="$N8N_API_URL" -e N8N_API_KEY="$N8N_API_KEY" \
      -- npx -y n8n-mcp >/dev/null 2>&1 && ok "n8n-mcp" || no "n8n-mcp"
  else
    no "N8N_API_URL / N8N_API_KEY not set — skipping n8n-mcp"
  fi
fi

echo; echo "Restart Claude Code. Verify: claude plugin list"
