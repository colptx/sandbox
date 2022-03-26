<#
#   Clean up aging backups from \\server\backups\ within set limit.
#
#>
$backupLocation = "E:\Shares\Backups"

function Purge-Data {
    #[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Retention
    )

    $retentionDays = (Get-Date).AddDays($Retention)

    if (Test-Path $Path){
        Get-ChildItem $Path -Recurse | Where-Object { (
            $_.CreationTime -lt $retentionDays)
        } | Remove-Item -Force -Recurse
    }
}


# GPO
$root = "$backupLocation\GPO"
Purge-Data -Path $root -Retention 10

# DC
$root = "$backupLocation\DC"
Purge-Data -Path $root -Retention 10

# DHCP
$root  = "$backupLocation\DHCP"
Purge-Data -Path $root -Retention 10

# Darktrace ; Sec guy wants 30 days of retention
$root  = "$backupLocation\Darktrace"
Purge-Data -Path $root -Retention 30

# Group Policies
$root  = "$backupLocation\GPO"
Purge-Data -Path $root -Retention 10

# vCenter
# Retains the last 10 backups