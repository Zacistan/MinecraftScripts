function Stop-Minecraft {
    param ( )
    # RIP all Java processes
    Get-Process | Where-Object Name -eq Java | Stop-Process
}

function Start-Minecraft {
    param (
        # Path to Minecraft's server.jar file
        [Parameter(Mandatory=$true)]
        [string]
        $ServerJar,
        # Number of MBs of RAM to allocate to the Java virtual machine.
        [Parameter(Mandatory=$true)]
        [int]
        $MBsOfRam
    )
    Set-Location (Get-Item $ServerJar).Directory
    try {
        Invoke-Expression -Command "java -Xmx$($MBsOfRam)M -Xms$($MBsOfRam)M -jar `"$($ServerJar)`" nogui"
    }
    catch {
        Write-Error "Could not start Minecraft server. Error: $_"
    }
}