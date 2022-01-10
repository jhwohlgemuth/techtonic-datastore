<#
.SYNOPSIS
Setup script for configuring Windows Terminal
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Switch] $Initial,
    [Switch] $EnableRemoting,
    [Switch] $SkipInstall,
    [PSObject] $InstallOptions = @{ PackageManager = 'Scoop'; Include = 'extra'},
    [ValidateSet(
        'agnoster',
        'aliens',
        'blueish',
        'iterm2',
        'lambda',
        'microverse',
        'night-owl',
        'paradox',
        'powerlevel',
        'princess',
        'tonybaloney',
        'robbyrussel',
        'slim',
        'space',
        'star',
        'wopian'
    )]
    [String] $Theme = 'powerline'
)
if ($Initial) {
    if ($PSCmdlet.ShouldProcess('==> [INFO] Create dev folder and install git')) {
        New-Item -ItemType Directory -Name dev -Path '~/dev/foo' -Force
        scoop install git
    }
}
if (-not $SkipInstall) {
    if ($PSCmdlet.ShouldProcess('==> [RUN] Invoke-Install.ps1')) {
        '==> [RUN] Executing Invoke-Install.ps1' | Write-Verbose
        '==> [INFO] Install options:' | Write-Verbose
        $InstallOptions | Write-Verbose
        & .\Invoke-Install.ps1 @InstallOptions
    }
} else {
    '==> [INFO] Skipping execution of Invoke-Install.ps1' | Write-Verbose
}
# Copy windows terminal profile
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy profile configuration')) {
    "==> [INFO] Copying profile configuration to ${PROFILE}" | Write-Verbose
    Set-Content -Path $PROFILE -Value (Get-Content -Path .\Microsoft.Powershell_profile.ps1)
}
# Copy windows terminal settings.json
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy settings JSON file')) {
    $LocalSettingsPath = "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
    Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path .\settings.json)
}
# Update oh-my-posh theme
$ThemeName = @{
    'agnoster'    = 'agnoster'
    'aliens'      = 'aliens'
    'blueish'     = 'blueish'
    'iterm2'      = 'iterm2'
    'lambda'      = 'lambda'
    'microverse'  = 'microverse-power'
    'night-owl'   = 'night-owl'
    'paradox'     = 'paradox'
    'powerlevel'  = 'powerlevel10k_rainbow'
    'princess'    = 'M365Princess'
    'tonybaloney' = 'tonybaloney'
    'robbyrussel' = 'robbyrussel'
    'slim'        = 'slim'
    'space'       = 'space'
    'star'        = 'star'
    'wopian'      = 'wopian'
}[$Theme]
if ($PSCmdlet.ShouldProcess("==> [INFO] Update oh-my-posh theme to ${ThemeName}")) {
    "==> [INFO] Updating oh-my-posh theme to ${ThemeName}" | Write-Verbose
    Set-PoshPrompt -Theme $ThemeName
    ((Get-Content -path $PROFILE -Raw) -replace 'Set-PoshPrompt -Theme .*\r\n', "Set-PoshPrompt -Theme ${ThemeName}`n") | Set-Content -Path $PROFILE
}