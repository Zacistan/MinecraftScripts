function Compress-Backups {
    param (
        # How old (in days) does a backup have to be before it's compressed.
        [Parameter()]
        [int]
        $NumberOfDaysOld = 0,
        # Directory where each uncompressed backup folder is stored.
        [Parameter(Mandatory=$true)]
        [string]
        $BackupDirectory,
        # Target directory where the compressed backup will go
        [Parameter(Mandatory=$true)]
        [string]
        $TargetDirectory
    )
    $cutOffDate = (Get-Date).AddDays(-$NumberOfDaysOld)

    try {
        $backupsToBeCompressed = Get-ChildItem -Path $BackupDirectory -Attributes Directory | Where-Object CreationTime -le $cutOffDate
    }
    catch {
        Write-Error "Could not access backups. Error: $_"
        return
    }

    if ($backupsToBeCompressed) {
        foreach ($backup in $backupsToBeCompressed) {
            Write-Host "Compressing backup $($backup.FullName)"
            $fullTargetPath = "$($TargetDirectory)\$($backup.name).zip" 

            try {
                Compress-Archive -Path $backup.FullName -DestinationPath $fullTargetPath -Force
                if (Test-Path $fullTargetPath) {x
                    Remove-Item -Path $backup.FullName -Force -Confirm:$false
                }
                else {
                    Write-Warning "Archive was not successfully created! Backup: $($backup.FullName) | Target: $($fullTargetPath)"
                }
            }
            catch {
                Write-Error "Unable to compress or move archive. Error: $_"
                return
            }
        }
    }
    else {
        Write-Warning "There were no backups to compress."
        return
    }
}

function Backup-CurrentWorld {
    param (
        # Path of the folder containing the world.
        [Parameter(Mandatory=$true)]
        [string]
        $WorldDirectory,
        # Path where the backups are stored.
        [Parameter()]
        [string]
        $BackupDirectory
    )
    $currentDateTime = Get-Date -Format "yyyy.MM.dd.HH.mm.ss"
    try {
        Copy-Item -Path $WorldDirectory -Destination "$($BackupDirectory)/$($currentDateTime)" -Recurse
    }
    catch {
        Write-Error "Unable to copy world directory. Error: $_"
        return
    }
}
