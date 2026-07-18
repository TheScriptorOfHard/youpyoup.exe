@echo off
title fuck you

start "" powershell -command "Add-Type -AssemblyName presentationCore; $player = New-Object System.Windows.Media.MediaPlayer; $player.Open([uri]::new((Resolve-Path '%~dp0music1.mp3').Path)); $player.Play(); while($true) { Start-Sleep -Seconds 1 }"

start "" powershell -command "Add-Type -AssemblyName presentationCore; while($true) { $delay = Get-Random -Minimum 500 -Maximum 1000; Start-Sleep -Milliseconds $delay; $p = New-Object System.Windows.Media.MediaPlayer; $p.Open([uri]::new((Resolve-Path '%~dp0error1.mp3').Path)); $p.Play() }"

call :RickRoll
call :Idiot
exit /b

:RickRoll
start https://i.giphy.com/g7GKcSzwQfugw.webp
goto :eof

:Idiot
start "" powershell -ExecutionPolicy Bypass -File "%~dp0popup1.ps1"
goto :eof