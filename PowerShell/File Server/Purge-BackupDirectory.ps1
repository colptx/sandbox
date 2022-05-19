<#
#   Clean up aging backups from \\fs01\backups\ within set limit.
#
#>
$backupLocation = "E:\Shares\Backups"

Import-Module '.\File Server\Purge-Data.psm1'

# DC GPO
$root = "$backupLocation\DC\GPO"
Purge-Data -Path $root -Retention 10

# DC AD
$root = "$backupLocation\DC\AD"
Purge-Data -Path $root -Retention 10

# DC DNS
$root = "$backupLocation\DC\DNS"
Purge-Data -Path $root -Retention 10

# DHCP
$root  = "$backupLocation\DHCP"
Purge-Data -Path $root -Retention 10

# Darktrace ; Robert wants 30 days of retention
$root  = "$backupLocation\Darktrace"
Purge-Data -Path $root -Retention 30

# Group Policies
$root  = "$backupLocation\DC\GPO"
Purge-Data -Path $root -Retention 10

# vCenter
# Retains the last 10 backups