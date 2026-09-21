# arsimaz AI stack

Shared instructions and capabilities for every AI coding agent.

`AGENTS.md` is read by Codex, Cursor, OpenCode, Gemini CLI, Factory Droid and
others. Claude Code reads `CLAUDE.md`. Both are symlinked to this file so there
is exactly one source of truth.

## Skills

Reusable skills live in `plugins/arsimaz-core/skills/<name>/SKILL.md`.
Each is a Markdown file with YAML frontmatter (`name`, `description`).
Tools that do not natively support skills can still read them as plain docs.

## Conventions

<!-- Put your own house rules here: style, testing, commit conventions. -->
