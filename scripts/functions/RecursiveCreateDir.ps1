#Requires -Version '4.0'
function RecursiveCreateDir {
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

  [System.IO.DirectoryInfo[]]$DirsCreated = @()

  $DirsCreated += $Path.Where({ -not (Test-Path (Split-Path $_ -Parent)) }).ForEach({ RecursiveCreateDir (Split-Path $_ -Parent ) })

  $DirsCreated += New-Item $Path -ItemType 'Directory'

  return $DirsCreated
}
