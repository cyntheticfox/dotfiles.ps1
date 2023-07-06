### Remove built-in alisases
Get-ChildItem 'alias:' | Remove-Item -Force

### Make actually readable env vars
$unreadableVars = Get-ChildItem 'env:*(*)*'

foreach ($var in $unreadableVars) {
  $newName = $var.Name.Replace('(', '_').Replace(')', '')

  if (-not (Test-Path "env:$newName")) {
    $null = New-Item "$env:$newName" -Value $var.Value
  }
}

# Set PATH var
$newPaths = @("$env:AppData\Python\**\Scripts")

foreach ($newPath in $newPaths) {
  if (Test-Path $newPath) {
    $null = Set-Item 'env:Path' -Value "$env:Path;$(Resolve-Path $newPath)"
  }
}

$drivesToAdd = @(
  @{
    Name = 'HKCR'
    PSProvider = 'Registry'
    Root = 'HKEY_CLASSES_ROOT'
  }
)

$driveNames = (Get-PSDrive).Name

foreach ($driveToAdd in $drivesToAdd) {
  if ($driveToAdd.Name -notin $driveNames) {
    $null = New-PSDrive @driveToAdd
  }
}

# Add local module dir
$moduleDir = "$env:UserProfile\Documents\WindowsPowerShell\Modules"

if ($PSModulePath -notcontains $moduleDir) {
  $null = Set-Item 'env:PSModulePath' -Value "$moduleDir;$env:PSModulePath"
}

# Set Window Title
$Host.UI.RawUI.WindowTitle = "WindowsPowerShell $($Host.Version.Major)`.$($Host.Version.Minor)"

function Prompt {
  # Check if running as Admin
  $principal = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $userModule = "$env:USERDOMAIN\$env:USERNAME "
  $hostModule = "on <$($env:COMPUTERNAME)> "
  $pathModule = "in $(Get-Location)"
  $promptChar = ''

  if (Test-Path 'variable:/PSDebugContext' ) {
    $promptChar = '?'
  } elseif ($principal.IsInRole($adminRole)) {
    $promptChar = '#'
  } else {
    $promptChar = '>'
  }

  $promptModule = "`r`nPS $promptChar"

  return "`r`n$userModule$hostModule$pathModule$promptModule"
}

if (Test-Path "$env:ProgramFiles\Git") {
  $env:EDITOR = "$env:ProgramFiles\Git\usr\bin\vim.exe"

  . $PSScriptRoot\functions\git.plugin.ps1

  New-Alias 'git-bash' "$env:ProgramFiles\Git\git-bash.exe"
  New-Alias 'git-cmd' "$env:ProgramFiles\Git\git-cmd.exe"

  $null = @(
    'diff',
    'dos2unix',
    'gpg',
    'grep',
    'head',
    'less',
    'od',
    'patch',
    'perl',
    'scp',
    'sed',
    'sftp',
    'ssh',
    'ssh-keygen',
    'tr',
    'tail',
    'tar',
    'tig',
    'uniq',
    'unix2dos',
    'vim',
    'vimdiff',
    'wc',
    'xxd'
  ).ForEach({ New-Alias $_ "$env:ProgramFiles\Git\usr\bin\$($_).exe"})
} else {
  $env:EDITOR = 'nodepad.exe'
}

New-Alias -Name 'edit' -Value 'Code'

# Alias common linux commands
New-Alias 'cat' 'Get-Content'
New-Alias 'cd' 'Set-Location'
New-Alias 'cp' 'Copy-Item'
New-Alias 'echo' 'Write-Host'
New-Alias 'env' 'Get-Variable'
New-Alias 'help' 'Get-Help'
New-Alias 'history' 'Get-History'
New-Alias 'kill' 'Stop-Process'
New-Alias 'll' 'Get-ChildItem'
New-Alias 'man' 'Get-Help'
New-Alias 'mv' 'Move-Item'
New-Alias 'popd' 'Pop-Location'
New-Alias 'poweroff' 'Stop-Computer'
New-Alias 'ps' 'Get-Process'
New-Alias 'pushd' 'Push-Location'
New-Alias 'pwd' 'Get-Location'
New-Alias 'reboot' 'Restart-Computer'
New-Alias 'rm' 'Remove-Item'
New-Alias 'rmdir' 'Remove-Item'
New-Alias 'set' 'Set-Variable'
New-Alias 'sleep' 'Start-Sleep'
New-Alias 'tee' 'Tee-Object'
New-Alias 'touch' 'New-Item'
New-Alias 'unzip' 'Expand-Archive'
New-Alias 'which' 'Get-Command'

# Add back some good standard aliases
New-Alias '%' 'ForEach-Object'
New-Alisa '?' 'Where-Object'
New-Alias 'ft' 'Format-Table'
New-Alias 'fl' 'Format-List'
New-Alias 'fw' 'Format-Wide'
New-Alias 'gm' 'Get-Member'
New-Alias 'measure' 'Measure-Object'
New-Alias 'select' 'Select-Object'
New-Alias 'sort' 'Sort-Object'
New-Alias 'unique' 'Unique-Object'
New-Alias 'where' 'Where-Object'

New-Alias 'nvim' 'vim'
New-Alias 'vi' 'vim'

New-Alias 'h' 'history'
New-Alias 'l' 'ls'
New-Alias 'v' 'vim'
New-Alias '~' '_cd_home'

function ls() {
  Get-ChildItem @args | Format-Wide -AutoSize
}

function la() {
  Get-ChildItem -Attributes '!H,H,S' @args
}

function acs() {
  Get-Alias @args
}

function sha256sum() {
  (Get-FileHash -Algorithm 'SHA256' @args).Hash.ToLower()
}

function md5sum() {
  (Get-FileHash -Algorithm 'MD5' @args).Hash.ToLower()
}

function pkill() {
  Get-Process @args | Stop-Process
}

function path() {
  $env:PATH.Replace(';', "`r`n")
}

function _cd_home() {
  Set-Location $env:USERPROFILE @args
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
