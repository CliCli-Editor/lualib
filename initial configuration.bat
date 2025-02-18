@echo off
md "%~dp0\..\.vscode"
md "%~dp0\..\.log"
xcopy /Y /E "%~dp0demo\ProjectConfiguration\*" "%~dp0.."
pause
