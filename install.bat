@echo off
REM Wire this machine up to the stack.  Usage:  install.bat
setlocal

echo == marketplaces
REM Third-party plugins come from THEIR OWN marketplaces, not re-exported from
REM ours: re-exports clone over SSH and fail without a key. See README.
for %%m in (arsimaz/ai-stack obra/superpowers kepano/obsidian-skills nextlevelbuilder/ui-ux-pro-max-skill thedotmack/claude-mem) do call claude plugin marketplace add %%m

echo == plugins
call claude plugin install arsimaz-core@arsimaz
call claude plugin install superpowers@superpowers-dev
call claude plugin install obsidian@obsidian-skills
call claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
call claude plugin install claude-mem@thedotmack

echo.
echo Omitted by weight - add explicitly if you want them:
echo   gsd-core ^(144 skills / 64 agents^):
echo     claude plugin marketplace add open-gsd/gsd-core
echo     claude plugin install gsd-core@gsd-core
echo   ecc ^(903 skills / 68 agents^):
echo     claude plugin marketplace add affaan-m/everything-claude-code
echo     claude plugin install ecc@ecc
echo.
echo Restart Claude Code, then verify:  claude plugin list
endlocal
