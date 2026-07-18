@echo off
title Kill All

powershell -command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { $_.CommandLine -match 'music1\.mp3|error1\.mp3|popup1\.ps1|idiot\.mp3' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f

exit