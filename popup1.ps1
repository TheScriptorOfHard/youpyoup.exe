Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName presentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()

$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([uri]::new((Resolve-Path "$PSScriptRoot\idiot.mp3").Path))
$mediaPlayer.Play()

$loopTimer = New-Object System.Windows.Forms.Timer
$loopTimer.Interval = 500
$loopTimer.Add_Tick({
    if ($mediaPlayer.NaturalDuration.HasTimeSpan -and $mediaPlayer.Position -ge $mediaPlayer.NaturalDuration.TimeSpan) {
        $mediaPlayer.Position = [TimeSpan]::Zero
        $mediaPlayer.Play()
    }
})
$loopTimer.Start()

$screenW = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenH = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

function New-Popup {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'You Are An Idiot'
    $form.Width = 400
    $form.Height = 300
    $form.StartPosition = 'Manual'
    $form.FormBorderStyle = 'None'
    $form.TopMost = $true
    $form.ShowInTaskbar = $false
	$form.ControlBox = $false

    $pic = New-Object System.Windows.Forms.PictureBox
    $pic.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\idiot.gif")
    $pic.Dock = 'Fill'
    $pic.SizeMode = 'StretchImage'
    $form.Controls.Add($pic)

    $pic.Add_Click({
        New-Popup
    })

    $x = Get-Random -Minimum 0 -Maximum ($screenW - $form.Width)
    $y = Get-Random -Minimum 0 -Maximum ($screenH - $form.Height)
    $dx = 15
    $dy = 15

    $form.Location = New-Object System.Drawing.Point($x, $y)

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 20

    $state = @{ x = $x; y = $y; dx = $dx; dy = $dy }

    $timer.Add_Tick({
        $state.x += $state.dx
        $state.y += $state.dy

        if ($state.x -le 0) { $state.x = 0; $state.dx = -$state.dx }
        if ($state.x + $form.Width -ge $screenW) { $state.x = $screenW - $form.Width; $state.dx = -$state.dx }
        if ($state.y -le 0) { $state.y = 0; $state.dy = -$state.dy }
        if ($state.y + $form.Height -ge $screenH) { $state.y = $screenH - $form.Height; $state.dy = -$state.dy }

        $form.Location = New-Object System.Drawing.Point($state.x, $state.y)
    }.GetNewClosure())

    $timer.Start()

    $form.Add_FormClosed({
        $timer.Stop()
    })

    $form.Show()
}

New-Popup

[System.Windows.Forms.Application]::Run()