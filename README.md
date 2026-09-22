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

## Why upstream marketplaces

This repo does NOT re-export third-party plugins, even though the manifest
format allows it. Two failures made re-export unusable:

1. **Subdirectory plugins install empty.** `path` on a `github` source is
   silently ignored, so you get the repo root — zero components, no error.
2. **Re-exports clone over SSH.** A `github` source resolves to
   `git@github.com:` at install time and dies with
   `Permission denied (publickey)` on any machine without an SSH key.
   `"protocol": "https"` validates but is ignored. `marketplace add` has an
   HTTPS fallback; the plugin-install path does not.

So `install.sh` adds each third-party marketplace directly. The marketplace
clone uses the HTTPS fallback, and the plugin then installs from local disk —
no second clone, no SSH. One command still does everything; it just registers
five marketplaces instead of one.

This repo's own marketplace carries `arsimaz-core` only.

After installing, confirm nothing landed empty:

```bash
claude plugin details <name>    # zero components == broken source
```

## Weight

Measured with `claude plugin details` after install:

| Plugin | Marketplace | Skills | Agents | Hooks |
|---|---|---|---|---|
| obsidian | `obsidian-skills` | 6 | 0 | 0 |
| ui-ux-pro-max | `ui-ux-pro-max-skill` | 7 | 0 | 0 |
| superpowers | `superpowers-dev` | 15 | 0 | 1 |
| claude-mem | `thedotmack` | 20 | 0 | 7 |
| gsd-core | `gsd-core` | 144 | 64 | 7 |
| ecc | `ecc` | ~903 | 68 | 6 |

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
