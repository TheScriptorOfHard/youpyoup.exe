@echo off
title Kill All

powershell -command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { $_.CommandLine -match 'music1\.mp3|error1\.mp3|popup1\.ps1|idiot\.mp3' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }"

exit