# arsimaz/ai-stack

One repo. Every skill, plugin and MCP server, on every machine and every AI tool.

## Why a repo

A Claude Code **marketplace is just a git repo**. Adding this repo once on any
machine exposes everything in it — including third-party plugins it re-exports,
so you never add six separate marketplaces again.

## Use it

```bash
claude plugin marketplace add arsimaz/ai-stack
claude plugin install arsimaz-core@arsimaz
```

Or clone and run `./install.sh` to get everything at once.

## Reach, by surface

| Surface | How it gets the stack |
|---|---|
| Claude Code CLI | `claude plugin marketplace add` — this repo |
| Claude Code in VS Code / JetBrains | same `~/.claude` config as the CLI — nothing extra |
| claude.ai web, desktop, Cowork | enable the plugin at **account level**; it then syncs into every cloud session automatically |
| Codex / Cursor / OpenCode / Gemini | `AGENTS.md` at the repo root (`CLAUDE.md` and `GEMINI.md` symlink to it); `./install.sh --link` symlinks the skills dir |
| Other people | make the repo public — anyone can `marketplace add` it |

## Layout

```
.claude-plugin/marketplace.json   the catalog (yours + re-exported third-party)
plugins/arsimaz-core/             your own skills, commands, agents, hooks
mcp/servers.json                  MCP server definitions
AGENTS.md                         shared instructions for every agent
install.sh                        one command per machine
```

## Adding a skill

```bash
mkdir -p plugins/arsimaz-core/skills/my-skill
$EDITOR plugins/arsimaz-core/skills/my-skill/SKILL.md   # name + description frontmatter
claude plugin validate .
git commit -am "add my-skill" && git push
```

Bump `version` in `plugins/arsimaz-core/.claude-plugin/plugin.json`, then
`claude plugin update arsimaz-core` on your other machines.

## Never commit secrets

`mcp/servers.json` uses `${ENV_VAR}` placeholders on purpose. API keys belong in
your shell profile, not in this repo — especially if it is public.
