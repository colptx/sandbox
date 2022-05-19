<#
    For use to extract used security groups within a file structure.
#>

$root = "\\FS01\fileshares"
$path = "Utility Billing"
$dir = Get-childItem -Path "$root\$path" -Directory -Recurse
$outfile = "D:\temp\FileServerReport\FileServerReport_$path.csv"
$Report = @()

foreach ($d in $dir){
    Write-Host "$d" -ForegroundColor Yellow
    $acl = Get-Acl -Path $d.Fullname
    Foreach ($access in $acl.Access){
        $Properties = [ordered]@{'FolderName'=$d.FullName;'AD Group or User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
        $Report += New-Object -TypeName PSObject -Property $Properties
    }
}

$Report | Export-Csv -path $outfile -NoTypeInformation