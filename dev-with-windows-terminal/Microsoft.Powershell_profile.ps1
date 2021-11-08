#
# Import Powershell modules
#
function Test-Installed {
    $Name = $Args[0]
    Get-Module -ListAvailable -Name $Name
}
if (Test-Installed PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
}

$Modules = @(
    'PSScriptAnalyzer'
    'posh-git'
    'oh-my-posh'
    'Terminal-Icons'
    'Prelude'
)
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
foreach ($Module in $Modules) {
    if (Test-Installed $Module) {
        Import-Module -Name $Module
    }
}
#
# Set Oh-my-posh theme
#
# $Env:POSH_GIT_ENABLED = $True
Set-PoshPrompt -Theme powerlevel10k_rainbow
#
# Import Chocolatey profile
#
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}
#
# Set aliases
#
if (Test-Command git) {
    function Invoke-GitCommand { git $Args }
    function Invoke-GitCommit { git commit -vam $Args }
    function Invoke-GitDiff { git diff $Args }
    function Invoke-GitPushMaster { git push origin master }
    function Invoke-GitStatus { git status -sb }
    function Invoke-GitRebase { git rebase -i $Args }
    function Invoke-GitCheckout {
        Param(
            [Parameter(Position = 0)]
            [String] $File = '.'
        )
        git checkout -- $File
    }
    function Invoke-GitLog { git log --oneline --decorate }
    Set-Alias -Scope Global -Option AllScope -Name g -Value Invoke-GitCommand
    Set-Alias -Scope Global -Option AllScope -Name gcam -Value Invoke-GitCommit
    Set-Alias -Scope Global -Option AllScope -Name gd -Value Invoke-GitDiff
    Set-Alias -Scope Global -Option AllScope -Name glo -Value Invoke-GitLog
    Set-Alias -Scope Global -Option AllScope -Name gpom -Value Invoke-GitPushMaster
    Set-Alias -Scope Global -Option AllScope -Name grbi -Value Invoke-GitRebase
    Set-Alias -Scope Global -Option AllScope -Name gsb -Value Invoke-GitStatus
    Set-Alias -Scope Global -Option AllScope -Name gco -Value Invoke-GitCheckout
}
if (Test-Command docker) {
    $Format = "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
    function Invoke-DockerProcess { docker ps --format $Format }
    function Invoke-DockerProcessAll { docker ps -a --format $Format }
    function Invoke-DockerInspectAddress { docker inspect --format '{{ .NetworkSettings.IPAddress }}' $Args[0] }
    function Invoke-DockerRemoveAll { docker stop $(docker ps -a -q); docker rm --force $(docker ps -a -q) }
    function Invoke-DockerRemoveAllImage { docker rmi --force $(docker images -a -q) }
    Set-Alias -Scope Global -Option AllScope -Name dps -Value Invoke-DockerProcess
    Set-Alias -Scope Global -Option AllScope -Name dpa -Value Invoke-DockerProcessAll
    Set-Alias -Scope Global -Option AllScope -Name dip -Value Invoke-DockerInspectAddress
    Set-Alias -Scope Global -Option AllScope -Name dra -Value Invoke-DockerRemoveAll
    Set-Alias -Scope Global -Option AllScope -Name dri -Value Invoke-DockerRemoveAllImage
}
#
# Zoxide setup
#
if (Test-Command -Name zoxide) {
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell) -join "`n"
    })
}
#
# Create directory traversal shortcuts
#
for ($i = 1; $i -le 5; $i++) {
    $u =  "".PadLeft($i,"u")
    $d =  $u.Replace("u","../")
    Invoke-Expression "function $u { push-location $d }"
}
function Install-SshServer {
    <#
    .SYNOPSIS
    Install OpenSSH server
    .LINK
    https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param()
    if ($PSCmdlet.ShouldProcess('OpenSSH Server Configuration')) {
        Write-Verbose '==> Enabling OpenSSH server'
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        Write-Verbose '==> Starting sshd service'
        Start-Service sshd
        Write-Verbose '==> Setting sshd service to start automatically'
        Set-Service -Name sshd -StartupType 'Automatic'
        Write-Verbose '==> Adding firewall rule for sshd'
        New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        '==> Would have added windows OpenSSH.Server capability, started "sshd" service, and added a firewall rule for "sshd"' | Write-Color -DarkGray
    }
}
function New-DailyShutdownJob {
    <#
    .SYNOPSIS
    Create job to shutdown computer at a certain time every day
    .EXAMPLE
    New-DailyShutdownJob -At '22:00'
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $True)]
        [String] $At,
        [Switch] $PassThru
    )
    $Result = $False
    if (Test-Admin) {
        $Trigger = New-JobTrigger -Daily -At $At
        Register-ScheduledJob -Name 'DailyShutdown' -ScriptBlock { Stop-Computer -Force } -Trigger $Trigger
        $Result = $True
    } else {
        Write-Error '==> New-DailyShutdownJob requires Administrator privileges'
    }
    if ($PassThru) {
        $Result
    }
}
function Remove-DailyShutdownJob {
    <#
    .SYNOPSIS
    Remove job created with New-DailyShutdownJob
    .EXAMPLE
    Remove-DailyShutdownJob
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Switch] $PassThru
    )
    $Result = $False
    if (Test-Admin) {
        Unregister-ScheduledJob -Name 'DailyShutdown'
        $Result = $True
    } else {
        Write-Error '==> Remove-DailyShutdownJob requires Administrator privileges'
    }
    if ($PassThru) {
        $Result
    }
}