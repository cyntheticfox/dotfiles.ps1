# install.ps1

param([switch]$Force, [switch]$Verbose)

# Find all files
$ParentPath = Resolve-Path -Path '.'
$DestPath = Resolve-Path -Path '~'
$Excludes = @('LICENSE', 'README.md', 'install.ps1', '.gitattributes', '.git','.pre-commit-config.yaml')

foreach ($file in ((Get-ChildItem -Path $ParentPath -Recurse -File -Exclude $Excludes) +
                   (Get-ChildItem -Path $ParentPath -Recurse -File -Exclude $Excludes -Hidden))) {
    $RelativePath = Resolve-Path -Path $file.FullName -Relative
    $DestinationPath = Join-Path -Path $DestPath -ChildPath $RelativePath

    # If the file exists, and verbose is set, then inform the user
    if ((Test-Path -Path $DestinationPath) -and $Verbose) {
        Write-Host ('File exists: ' + $DestinationPath)
    }

    # Don't overwrite files unless forced to
    if ((-not (Test-Path -Path $DestinationPath)) -or $Force) {
        if ($Verbose) {
            Write-Host ('Writing: ' + $DestinationPath)
        }

        # Create parent directories if they don't exist
        $ParentDir = (Split-Path -Path $DestinationPath -Parent)
        If (-not (Test-Path -Path $ParentDir)) {
            New-Item -Path $ParentDir -ItemType 'Directory'
        }

        # Write files forcefully
        Copy-Item -Path $file -Destination $DestinationPath -Force
    }
}
