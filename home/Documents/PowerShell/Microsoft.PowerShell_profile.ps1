# Set Environment Variables
$env:SH = 'PS'
$env:EDITOR = 'nvim'

# Fix broken env vars
$null = (Get-ChildItem env:).Where({$_.Name -like '*(*)*'}).ForEach({$null = New-Item -Path 'env:' -Name $_.Name.Replace('(', '_').Replace(')', '_') -Value $_.Value})

# Remove built-in aliases
$null = Remove-Item alias:* -Force

# Create aliases for basic Linux commands
New-Alias 'alias' 'New-Alias'
New-Alias 'cd' 'Set-Location'
New-Alias 'cp' 'Copy-Item'
New-Alias 'history' 'Get-History'
New-Alias 'kill' 'Stop-Process'
New-Alias 'mv' 'Move-Item'
New-Alias 'popd' 'Pop-Location'
New-Alias 'poweroff' 'Stop-Computer'
New-Alias 'ps' 'Get-Process'
New-Alias 'pushd' 'Push-Location'
New-Alias 'reboot' 'Restart-Computer'
New-Alias 'rm' 'Remove-Item'
New-Alias 'touch' 'New-Item'
New-Alias 'which' 'Get-Command'

New-Alias 'gpg' "$env:ProgramFiles_x86_\GnuPG\bin\gpg.exe"
New-Alias 'ssh' "$env:SystemRoot\System32\OpenSSH\ssh.exe"
New-Alias 'ssh-keygen' "$env:SystemRoot\System32\OpenSSH\ssh-keygen.exe"
New-Alias 'sftp' "$env:SystemRoot\System32\OpenSSH\sftp.exe"
New-Alias 'firefox' "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
New-Alias 'git-bash' "$env:ProgramFiles\git\git-bash.exe"
New-Alias 'vscode' 'code'
New-Alias 'edit' "$env:EDITOR"

# Single-Character aliases
New-Alias 'g' 'git'
New-Alias 'h' 'Get-History'
New-Alias 'l' 'Get-ChildItem'
New-Alias 'v' "$env:EDITOR"

# Set up Get-ChildItemColor
if (Get-Module -ListAvailable -Name 'Get-ChildItemColor') {
  Import-Module -Name 'Get-ChildItemColor'

  Set-Alias 'ls' 'Get-ChildItemColorFormatWide'
}

function env() {
  Get-ChildItem env: @args
}

# Function for la
function ls() {
  Get-ChildItem @args | Format-Wide
}

function la() {
  Get-ChildItem -Attributes 'H,!H,S' @args
}

function pkill() {
  Get-Process @args | Stop-Process
}

# Git Functions (inspired by joseluisq/gitnow on github)
function gsb() {
  git status -sb @args
}

function ga() {
  git add @args
}

function grh() {
  git reset @args
}

function gc() {
  git commit @args
}

function gl() {
  git pull @args
}

function gp() {
  git push @args
}

# Chocolatey profile
if (Test-Path "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1") {
  Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}
