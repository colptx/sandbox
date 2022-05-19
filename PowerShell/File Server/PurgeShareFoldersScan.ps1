<#
    Below process will delete all files within that are older than the set limit variable. 
#>

$date = Get-Date
$root  = 'E:\Shares\Scans'
$limit = (Get-Date).AddDays(-2)

if (Test-Path $root){
    Get-ChildItem $root -Recurse | Where-Object { (
        $_.CreationTime -lt $limit) -and ( -not $_.PSIsContainer)
    } | Remove-Item -Force -Recurse
}
