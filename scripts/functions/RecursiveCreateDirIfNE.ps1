#Requires -Version '4.0'

. $PSScriptRoot\RecursiveCreateDir.ps1

function RecursiveCreateDirIfNE {
  [CmdletBinding()]
  [OutputType([System.IO.DirectoryInfo[]])]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Path
  )

  return $Path.Where({ (-not (Test-Path $_)) }).ForEach({ RecursiveCreateDir $_ })
}
