<#
#>

Import-Module '.\File Server\Get-DirTree.psm1'
#Import-Module '.\Get-FileShareRights.psm1'

$rootpath = "\\FS01\fileshares"
$subpath = "Human Resources"

$directories = Get-DirTree -Path "$rootpath\$subpath"

# Set Inner ACL if not Inherited 
foreach ($directory in $directories){
    Write-Host "Writing new ACLs to Directories..." -ForegroundColor Yellow
    Write-Host "$directory" -ForegroundColor Cyan
    $acls = (Get-Acl -Path $directory).Access
    $acllist = $acls | Where-Object {-not($_.IdentityReference -eq 'LAPORTE\Domain Admins' -or $_.IdentityReference -eq 'BUILTIN\Administrators' -or  $_.IdentityReference -eq 'NT AUTHORITY\SYSTEM' -or  $_.IdentityReference -eq 'SVC_IAPro' -or  $_.IdentityReference -eq 'CHPaymentKiosk')}

    foreach ($right in $acllist){
        if ($right.IsInherited){Continue}
        
        $acl_path = $directory
        $acl_group = $right.IdentityReference
        $rights = "Read, ReadAndExecute, ListDirectory"
        $RuleType = "Allow"
        $PropogationSettings = "None"
        $InheritSettings = "Containerinherit, ObjectInherit"

        $acl_policy = Get-Acl $acl_path
        $perm = $acl_group, $rights, $InheritSettings, $PropogationSettings, $RuleType
        $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
        $acl_policy.SetAccessRule($rule)
        $acl_policy | Set-Acl -Path $acl_path
    }
}