# Create some basic aliases
New-Alias -Name 'gpg' -Value 'C:\Program Files (x86)\GnuPG\bin\gpg.exe'
New-Alias -Name 'edit' -Value 'vim'
New-Alias -Name 'mono' -Value 'C:\Program Files\Mono\bin\mono.exe'
New-Alias -Name 'MpCmdRun' -Value 'C:\Program Files\Windows Defender\MpCmdRun.exe'
New-Alias -Name 'firefox' -Value 'C:\Program Files\Mozilla Firefox\firefox.exe'
New-Alias -Name 'git-bash' -Value 'C:\Program Files\git\git-bash.exe'
New-Alias -Name 'touch' -Value 'New-Item'
New-Alias -Name 'which' -Value 'Get-Command'
New-Alias -Name 'vscode' -Value 'code'
New-Alias -Name 'vi' -Value 'vim'
New-Alias -Name 'vim' -Value 'nvim'

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
    git commit
}

function commit-all() {
    git commit -a
}

function pull() {
    git pull
}

function push() {
    git push
}

function github([string]$RepoName) {
    $GithubPath = "github:" + $RepoName
    git clone --recurse-submodules -j8 $GithubPath
}

function github([string]$UserName, [string]$RepoName) {
    $GitHubPath = "github:" + $UserName + "/" + $RepoName
    git clone --recurse-submodules -j8 $GithubPath
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Enable Starship prompt
try {
    $ENV:STARSHIP_CONFIG = "$HOME\.starship"
    Invoke-Expression (&starship init powershell)
} catch {}
