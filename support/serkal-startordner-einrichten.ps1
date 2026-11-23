$ErrorActionPreference = 'Stop'
$hub = 'C:\ppd\serkal\serkal_dev'
$desktopRepo = Join-Path $hub 'serkal_desktop'
$websiteRepo = Split-Path $PSScriptRoot -Parent
$desktop = [Environment]::GetFolderPath('DesktopDirectory')

$launchers = [ordered]@{
    'PULL-PD.BAT' = Join-Path $websiteRepo 'PULL-PD.BAT'
    'NUR-WEBSITE-HOCHLADEN.BAT' = Join-Path $websiteRepo 'NUR-WEBSITE-HOCHLADEN.BAT'
    'WEBSITE-PRUEFEN.BAT' = Join-Path $websiteRepo 'support\elwms_website_check.bat'

}

if (!(Test-Path -LiteralPath $hub -PathType Container)) { throw "Ordner fehlt: $hub" }

if (!(Test-Path -LiteralPath (Join-Path $desktopRepo 'package.json') -PathType Leaf)) {
    $desktopRepo = Join-Path (Split-Path $hub -Parent) 'serkal_desktop'
}
if (!(Test-Path -LiteralPath (Join-Path $desktopRepo 'package.json') -PathType Leaf)) {
    throw 'SerKal Desktop wurde an beiden bekannten Orten nicht gefunden (package.json fehlt).'
}
$desktopCommands = [ordered]@{
    'SERKAL-STARTEN.CMD' = 'npm start'
    'SERKAL-PAKETE-INSTALLIEREN.CMD' = 'npm install'
}

foreach ($target in $launchers.Values) {
    if (!(Test-Path -LiteralPath $target -PathType Leaf)) { throw "Startdatei fehlt: $target" }
}
$marker = 'rem Erstellt von SERKAL-STARTORDNER-EINRICHTEN'
foreach ($name in (@($launchers.Keys) + @($desktopCommands.Keys))) {
    $file = Join-Path $hub $name
    if ((Test-Path -LiteralPath $file) -and
        !(Select-String -LiteralPath $file -SimpleMatch -Quiet $marker)) {
        throw "Vorhandene eigene Batch bleibt erhalten: $file"
    }
}

foreach ($name in $launchers.Keys) {
    $target = $launchers[$name]
    $file = Join-Path $hub $name
    @(
        '@echo off'
        $marker
        ('cd /d "' + $hub + '" || exit /b 1')
        ('cmd /d /c call "' + $target + '" %*')
        'exit /b %errorlevel%'
    ) | Set-Content -LiteralPath $file -Encoding Ascii
}

foreach ($name in $desktopCommands.Keys) {
    $file = Join-Path $hub $name
    @(
        '@echo off'
        $marker
        ('cd /d "' + $hub + '" || exit /b 1')
        'setlocal'
        ('pushd "' + $desktopRepo + '" || exit /b 1')
        ('cmd /d /c ' + $desktopCommands[$name])
        'set "SERKAL_RESULT=%ERRORLEVEL%"'
        'popd'
        'exit /b %SERKAL_RESULT%'
    ) | Set-Content -LiteralPath $file -Encoding Ascii
}

$shell = New-Object -ComObject WScript.Shell
$locations = @(
    (Join-Path $desktop 'serkal_cmd.lnk')
    (Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\serkal_cmd.lnk')
)
foreach ($file in $locations) {
    if ($file -ne $locations[0] -and !(Test-Path -LiteralPath $file)) { continue }
    $shortcut = $shell.CreateShortcut($file)
    $shortcut.TargetPath = Join-Path $env:SystemRoot 'System32\cmd.exe'
    $shortcut.Arguments = '/d /k cd /d "' + $hub + '"'
    $shortcut.WorkingDirectory = $hub
    $shortcut.Save()
}

Write-Host "Startdateien eingerichtet: $hub"
Write-Host 'serkal_cmd liegt auf dem Desktop. Eine vorhandene gleichnamige Taskleisten-Verknuepfung wurde mit angepasst, sofern Windows sie als Datei bereitstellt.'
