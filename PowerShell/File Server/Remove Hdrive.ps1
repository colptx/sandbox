<#
## Get User Lists for Content import

get-ADuser -filter {Enabled -eq $true} -Properties Title,Department | 
        Where-Object { $_.Department -like "*IT*"} | 
        Select-Object -ExpandProperty SamAccountName
        
#>

Import-Module 'ActiveDirectory'

# User Import lists
#$group = 'Medic'
#$users = Get-Content -Path "C:\Users\user\$group.txt"
$users = 'GordonB'



Foreach ($U in $users) {

# Set the User into a variable just in case you need more properties later.
$UNP = Get-aduser $u -Properties HomeDirectory

Write-Host "Processing" $UNP.SamAccountName -ForegroundColor Cyan

# Set the User's HomeDrive and HomeDirectory to $nul forcing it to "Local Path"
Set-ADUser $u -HomeDrive $null -HomeDirectory $null

Write-Host "HomeDrive and HomeDirectory removed from User" -ForegroundColor Cyan
Write-Host "Changing HomeDirectory NTFS Permissions to ReadOnly On Target" $unp.HomeDirectory -ForegroundColor Cyan


# Changing file permissions with PowerShell is not too difficult but not straight forward. 
    $path = $UNP.HomeDirectory # user Account HomeDirectory
    $user = $UNP.SamAccountName #user Account to grant permissions to.
    $Rights = "Read, ReadAndExecute, ListDirectory" #Comma seperated list.
    $InheritSettings = "Containerinherit, ObjectInherit" #Controls how permissions are inherited by children
    $PropogationSettings = "None" #Usually set to none but can setup rules that only apply to children.
    $RuleType = "Allow" #Allow or Deny.

    $acl = Get-Acl $path
    $perm = $user, $Rights, $InheritSettings, $PropogationSettings, $RuleType
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
    $acl.SetAccessRule($rule)
    $acl | Set-Acl -Path $path

Write-Host "Process Complete for" $UNP.SamAccountName -ForegroundColor Green
}