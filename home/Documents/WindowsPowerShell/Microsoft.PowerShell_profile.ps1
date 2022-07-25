# Set Environment Variables
$ENV:SH = 'PS'

# Create some basic aliases
New-Alias -Name 'gpg' -Value 'C:\Program Files (x86)\GnuPG\bin\gpg.exe'
New-Alias -Name 'edit' -Value 'Code'
New-Alias -Name 'firefox' -Value 'C:\Program Files\Mozilla Firefox\firefox.exe'
New-Alias -Name 'git-bash' -Value 'C:\Program Files\git\git-bash.exe'
New-Alias -Name 'touch' -Value 'New-Item'
New-Alias -Name 'which' -Value 'Get-Command'
New-Alias -Name 'vscode' -Value 'code'
New-Alias -Name 'vi' -Value 'vim'
New-Alias -Name 'vim' -Value 'nvim'

Set-Alias -Name 'l' -Value 'Get-ChildItem'

# Set up Get-ChildItemColor
if (Get-Module -ListAvailable -Name get-childitemcolor) {
  Import-Module Get-ChildItemColor

  Set-Alias -Name 'ls' -Value 'Get-ChildItemColorFormatWide' -Option AllScope
}

# Function for la
function la() {
    (Get-ChildItem) + (Get-ChildItem -Hidden) + (Get-ChildItem -System)
}

# Git Functions (inspired by joseluisq/gitnow on github)
function state() {
  git status -s
}

function stage() {
  git add .
}

function unstage() {
  git reset .
}

function commit() {
  git commit @args
}

function pull() {
  git pull @args
}

function push() {
  git push @args
}

function github([string]$RepoName) {
  $GithubPath = 'github:' + $RepoName
  git clone --recurse-submodules -j8 $GithubPath
}

function github([string]$UserName, [string]$RepoName) {
  $GitHubPath = 'github:' + $UserName + '/' + $RepoName
  git clone --recurse-submodules -j8 $GithubPath
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
