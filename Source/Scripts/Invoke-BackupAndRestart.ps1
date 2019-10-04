#region Module imports
Import-Module "$($PSScriptRoot)\..\Modules\Backup.psm1" -Force
Import-Module "$($PSScriptRoot)\..\Modules\StopStart.psm1" -Force
#endregion

# Get configuration from json file.
$conf = Get-Content "$($PSScriptRoot)\..\Config\Conf.json" | ConvertFrom-Json

try {
    Stop-Minecraft
    Backup-CurrentWorld -WorldDirectory $conf.Backup.WorldDirectory -BackupDirectory $conf.Backup.Backupdirectory
    Compress-Backups -BackupDirectory $conf.Backup.Backupdirectory -TargetDirectory $conf.Backup.ArchiveDirectory
    Start-Minecraft -ServerJar $conf.ServerJar -MBsOfRam $conf.MBsOfAllocatedRam
}
catch {
    throw "Error attempting to backup and restart the Minecraft server: $_"
}

exit 0