@echo off
REM Windows installer. Run from anywhere:  install.bat
setlocal

echo == marketplaces
call claude plugin marketplace add arsimaz/ai-stack
REM claude-mem lives in a subdirectory and cannot be re-exported, so add upstream
call claude plugin marketplace add thedotmack/claude-mem

echo == plugins
for %%p in (arsimaz-core superpowers obsidian ui-ux-pro-max) do call claude plugin install %%p@arsimaz
call claude plugin install claude-mem@thedotmack

echo.
echo Omitted by weight - add explicitly if you want them:
echo    claude plugin install gsd-core@arsimaz   ^(144 skills / 64 agents^)
echo    claude plugin install ecc@arsimaz        ^(903 skills / 68 agents^)
echo.
echo Restart Claude Code, then verify:  claude plugin list
endlocal
