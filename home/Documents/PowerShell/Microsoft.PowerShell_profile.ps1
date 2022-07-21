#Requires -Version '4.0'

# Set Environment Variables
$env:SH = 'PS'
$env:EDITOR = ''

# Remove built-in aliases
$null = Remove-Item 'alias:*' -Force

# Fix broken env vars
$null = (Get-ChildItem env:).Where({$_.Name -like '*(*)*'}).ForEach({@{ Name = $_.Name.Replace('(', '_').Replace(')', '_'); Value = $_.Value}}).Where({$_.Name -notin (Get-ChildItem 'env:*_*').Name}).ForEach({ New-Item -Path 'env:' -Name $_.Name -Value $_.Value})

# Add more drives
$null = @(@{Name = 'HKCR'; PSProvider = 'Registry'; Root = 'HKEY_CLASSES_ROOT'}).Where({$_.Name -notin (Get-PSDrive).Name}).ForEach({New-PSDrive @_})

# Set window title
$Host.UI.RawUI.WindowTitle = "PowerShell Core $($Host.Version.Major).$($Host.Version.Minor)"

# Alias certain programs
if (Test-Path "$env:ProgramFiles\Git") {
  New-Alias 'git-bash' "$env:ProgramFiles\git\git-bash.exe"

  $null = @(
    'diff',
    'dos2unix',
    'gpg'
    'grep',
    'head',
    'less',
    'od',
    'openssl',
    'patch',
    'perl',
    'scp',
    'sed',
    'sftp',
    'shred',
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
  ).ForEach({
    New-Alias $_ "$env:ProgramFiles\Git\usr\bin\$($_).exe"
  })

  $env:EDITOR = 'vim'
}

if (Test-Path "$env:ProgramFiles\NeoVim\bin\nvim.exe") {
  New-Alias 'nvim' "$env:ProgramFiles\NeoVim\bin\nvim.exe"
  $env:EDITOR = 'nvim'
}

if (Test-Path "$env:ProgramFiles_x86_\GnuPG\bin\gpg.exe") {
  Set-Alias 'gpg' "$env:ProgramFiles_x86_\GnuPG\bin\gpg.exe"
}

if ($null -eq $env:EDITOR -or '' -eq $env:EDITOR) {
  $env:EDITOR = 'notepad.exe'
}

# Create aliases for basic Linux commands
New-Alias 'alias' 'Get-Alias'
New-Alias 'cat' 'Get-Content'
New-Alias 'cd' 'Set-Location'
New-Alias 'cp' 'Copy-Item'
New-Alias 'echo' 'Write-Host'
New-Alias 'help' 'Get-Help'
New-Alias 'history' 'Get-History'
New-Alias 'kill' 'Stop-Process'
New-Alias 'mount' 'New-PSDrive'
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
New-Alias 'touch' 'New-Item'
New-Alias 'unzip' 'Expand-Archive'
New-Alias 'which' 'Get-Command'

New-Alias 'firefox' "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
New-Alias 'vscode' 'code'
New-Alias 'edit' "$env:EDITOR"

# Add back some standard short aliases I like
New-Alias '%' 'ForEach-Object'
New-Alias '?' 'Where-Object'
New-Alias 'ft' 'Format-Table'
New-Alias 'fl' 'Format-List'
New-Alias 'fw' 'Format-Wide'
New-Alias 'measure' 'Measure-Object'
New-Alias 'select' 'Select-Object'
New-Alias 'sort' 'Sort-Object'
New-Alias 'unique' 'Unique-Object'
New-Alias 'where' 'Where-Object'

# Single-Character aliases
New-Alias 'g' 'git'
New-Alias 'h' 'history'
New-Alias 'l' 'ls'
New-Alias 'v' "$env:EDITOR"

# Set up Get-ChildItemColor
if (Get-Module -ListAvailable -Name 'Get-ChildItemColor') {
  Import-Module -Name 'Get-ChildItemColor'

  New-Alias 'ls' 'Get-ChildItemColorFormatWide'
} else {
  New-Alias 'ls' 'Get-ChildItemWide'
}

function env() {
  Get-ChildItem env: @args
}

function Get-ChildItemWide() {
  Get-ChildItem @args | Format-Wide
}

# Function for la
function la() {
  Get-ChildItem -Attributes 'H,!H,S' @args
}

function pkill() {
  Get-Process @args | Stop-Process
}

# Git Functions
function ga() {
  git add @args
}

function gaa() {
  git add --all @args
}

function gb() {
  git branch @args
}

function gc() {
  git commit @args
}

function gl() {
  git pull @args
}

function gm() {
  git merge @args
}

function gp() {
  git push @args
}

function grh() {
  git reset @args
}

function grhh() {
  git reset --hard @args
}

function gsb() {
  git status -sb @args
}

function sha256sum() {
  (Get-FileHash -Algorithm SHA256 @args).Hash.ToLower()
}

function md5sum() {
  (Get-FileHash -Algorithm MD5 @args).Hash.ToLower()
}

# Chocolatey profile
if (Test-Path "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1") {
  Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}

$ErrorActionPreference = 'Stop'
$WarningPreference = 'Inquire'
$InformationPreference = 'Continue'
$VerbosePreference = 'SilentlyContinue'
$DebugPreference = 'SilentlyContinue'
