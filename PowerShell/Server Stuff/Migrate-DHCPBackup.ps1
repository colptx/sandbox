<#
#   For the purpose of migrating the automatically backuping up data 
#   from default location to the fileshare for alternative recovery method.
#>

$date = Get-Date -Format yyyyMMdd
$hostname = $env:COMPUTERNAME
$dhcpSourcePath = "C:\Windows\System32\dhcp\backup"
$dhcpDestinationPath = "\\server\Backups\DHCP\$hostname\$date"

Copy-Item -Recurse -Path $dhcpSourcePath -Destination $dhcpDestinationPath -Force