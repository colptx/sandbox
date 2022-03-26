<#
#   For the purpose of backing up and migrating GPO data 
#   to the fileshare for alternative recovery method.
#>
$date = Get-Date -Format yyyyMMdd
$backupLocation = "\\server\Backups\DC\GPO\$date"

Backup-GPO -All -Path $backupLocation