#Requires -Version '2.0'

. $PSScriptRoot\git.plugin.ps1

function glfsi() {
  git lfs install @args
}

function glfsls() {
  git lfs ls-files @args
}

function glfsmi() {
  git lfs migrate import --include= @args
}

function glfst() {
  git lfs track @args
}
