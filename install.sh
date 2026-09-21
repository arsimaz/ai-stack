#!/usr/bin/env bash
# Point any machine at this stack. Run once per machine, per account.
#   ./install.sh            plugins only
#   ./install.sh --mcp      also register MCP servers
#   ./install.sh --link     also symlink skills for non-Claude agents
set -uo pipefail
REPO="${STACK_REPO:-arsimaz/ai-stack}"   # override if you rename it
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ok(){ printf '  \033[32m✓\033[0m %s\n' "$*"; }
no(){ printf '  \033[31m✗\033[0m %s\n' "$*"; }

command -v claude >/dev/null || { no "claude CLI not found"; exit 1; }

echo "== marketplace"
claude plugin marketplace add "$REPO" >/dev/null 2>&1 \
  && ok "added $REPO" || ok "$REPO already registered"

echo "== plugins"
for p in arsimaz-core superpowers obsidian ui-ux-pro-max claude-mem gsd-core; do
  claude plugin install "$p@arsimaz" -y >/dev/null 2>&1 && ok "$p" || no "$p (run manually)"
done
echo "  (ecc omitted — 903 skills. Add with: claude plugin install ecc@arsimaz)"

if [[ "${1:-}" == "--mcp" || "${2:-}" == "--mcp" ]]; then
  echo "== mcp"
  if [[ -n "${N8N_API_URL:-}" && -n "${N8N_API_KEY:-}" ]]; then
    claude mcp add n8n-mcp -e N8N_API_URL="$N8N_API_URL" -e N8N_API_KEY="$N8N_API_KEY" \
      -- npx -y n8n-mcp >/dev/null 2>&1 && ok "n8n-mcp" || no "n8n-mcp"
  else
    no "N8N_API_URL / N8N_API_KEY not set — skipping n8n-mcp"
  fi
fi

if [[ "${1:-}" == "--link" || "${2:-}" == "--link" ]]; then
  echo "== cross-tool links"
  for t in "$HOME/.codex" "$HOME/.cursor" "$HOME/.config/opencode"; do
    [[ -d "$t" ]] && ln -sfn "$HERE/plugins/arsimaz-core/skills" "$t/skills" && ok "$t/skills"
  done
fi

echo; echo "Restart your editor / CLI. Verify: claude plugin list"
