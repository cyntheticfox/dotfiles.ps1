#Requires -Version '2.0'

. $PSScriptRoot\git.plugin.ps1

function gcd() {
  git checkout "$(git config 'gitflow.branch.develop')" @args
}

function gch() {
  git checkout "$(git config 'gitflow.prefix.hotfix')" @args
}

function gcr() {
  git checkout "$(git config 'gitflow.prefix.release')" @args
}

function gfl() {
  git flow @args
}

function gflf() {
  git flow feature @args
}

function gflff() {
  git flow feature finish @args
}

function gflffc() {
  git flow feature finish "$(git_current_branch)#feature/" @args
}

function gflfp() {
  git flow feature publish @args
}

function gflfpc() {
  git flow feature publish "$(git_current_branch)#feature/" @args
}

function gflpll() {
  git flow feature pull @args
}

function gflfs() {
  git flow feature start @args
}

function gflh() {
  git flow hotfix @args
}

function gflhf() {
  git flow hotfix finish @args
}

function gflhfc() {
  git flow hotfix finish "$(git_current_branch)#hotfix/" @args
}

function gflhp() {
  git flow hotfix publish @args
}

function gflhpc() {
  git flow hotfix publish "$(git_current_branch)#hotfix/" @args
}

function gflhs() {
  git flow hotfix start @args
}

function gfli() {
  git flow init @args
}

function gflr() {
  git flow release @args
}

function gflrf() {
  git flow release finish @args
}

function gflrfc() {
  git flow release finish "$(git_current_branch)#release/" @args
}

function gflrp() {
  git flow release publish @args
}

function gflrpc() {
  git flow release publish "$(git_current_branch)#release/" @args
}

function gflrs() {
  git flow release start @args
}
