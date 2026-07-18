@echo off
title Kill All
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
	exit /b
)

powershell -WindowStyle Hidden -command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { $_.CommandLine -match 'music1\.mp3|error1\.mp3|popup1\.ps1|idiot\.mp3' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f

exit