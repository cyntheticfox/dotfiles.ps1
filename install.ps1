# install.ps1
#Requires -Version '4.0'
[CmdletBinding()]
[OutputType([System.Io.DirectoryInfo[]])]
param(
  [Parameter(
    Position = 0
  )]
  [ValidateNotNullOrEmpty()]
  [ValidateScript({
      $_.ForEach({
          $item = Get-Item $_
          $item -Is [System.IO.DirectoryInfo]
        })
    })]
  [String[]]
  $Path = (Resolve-Path ".\home"),

  [Parameter(
    Position = 1
  )]
  [ValidateNotNullOrEmpty()]
  [ValidateScript({
      $_.ForEach({
          $item = Get-Item $_
          $item -Is [System.IO.DirectoryInfo]
        })
    })]
  [String[]]
  $DestinationPath = (Resolve-Path $env:USERPROFILE),

  [Parameter()]
  [ValidateNotNull()]
  [Switch]
  $Force
)

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

  $DirsCreated += $Path.Where({-not (Test-Path (Split-Path $_ -Parent))}).ForEach({ RecursiveCreateDir (Split-Path $_ -Parent )})

  $DirsCreated += New-Item $Path -ItemType 'Directory'

  return $DirsCreated
}

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

  return $Path.Where({(-not (Test-Path $_))}).ForEach({ RecursiveCreateDir $_ })
}

# Find all files
[System.Collections.Hashtable[]]$PathArr = @()

$null = $Path.ForEach({
    foreach ($File in (Get-ChildItem -Attributes 'H,!H' $_ -Recurse -File)) {
      $PathArr += @{ OrigPath = $File.FullName; ChildPath = $File.FullName.Replace($_, '')}
    }
  })

foreach ($DestPath in $DestinationPath) {
  $null = $PathArr.ForEach({
      [String]$DestFilePath = "$DestPath\$($_.ChildPath)"

      # If the file exists, and verbose is set, then inform the user
      if (Test-Path $DestFilePath) {
        Write-Information "File exists: $DestFilePath"
      }

      # Don't overwrite files unless forced to
      if ((-not (Test-Path $DestFilePath)) -or $Force) {
        # Create parent directories if they don't exist
        $null = RecursiveCreateDirIfNE (Split-Path $DestFilePath -Parent)

        # Write files forcefully
        Write-Verbose "Writing: $DestFilePath"
        $null = Copy-Item $_.OrigPath $DestFilePath -Force
      }
    })
}

return Get-Item $DestinationPath
