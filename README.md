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

Or clone and run the installer for your OS:

```bash
./install.sh      # macOS / Linux
```
```bat
install.bat       :: Windows (cmd or PowerShell)
```

On Windows, `./install.sh` will not run in cmd — use `install.bat`. Pasting a
multi-line block into cmd also merges the lines; run one command per line, or
chain them with `&&` on a single line.

## Reach, by surface

| Surface | How it gets the stack |
|---|---|
| Claude Code CLI | `claude plugin marketplace add` — this repo |
| Claude Code in VS Code / JetBrains | same `~/.claude` config as the CLI — nothing extra |
| claude.ai web, desktop, Cowork | enable the plugin at **account level**; it then syncs into every cloud session automatically |
| Codex / Cursor / OpenCode / Gemini | `AGENTS.md` at the repo root (`CLAUDE.md` and `GEMINI.md` symlink to it); `./install.sh --link` symlinks the skills dir |
| Other people | make the repo public — anyone can `marketplace add` it |

## Known limitation: subdirectory plugins

A marketplace can re-export a third-party plugin that sits at its **repo root**.
It cannot re-export one that lives in a **subdirectory** — the `path` field on a
`github` source is silently ignored, and you get the repo root instead (which
installs with zero components, with no error).

`claude-mem` is such a plugin (`thedotmack/claude-mem` → `./plugin`), so it is
NOT in this marketplace. `install.sh` adds its upstream marketplace instead:

```bash
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack
```

Verify any re-export actually landed with `claude plugin details <name>` — a
zero-component inventory means the source path is wrong.

## Weight

Measured with `claude plugin details` after install:

| Plugin | Skills | Agents | Hooks |
|---|---|---|---|
| obsidian | 6 | 0 | 0 |
| ui-ux-pro-max | 7 | 0 | 0 |
| superpowers | 15 | 0 | 1 |
| claude-mem | 20 | 0 | 7 |
| gsd-core | 144 | 64 | 7 |
| ecc | ~903 | 68 | 6 |

`gsd-core` and `ecc` are an order of magnitude heavier than the rest. Both are
excluded from `install.sh`'s default set for that reason.

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
