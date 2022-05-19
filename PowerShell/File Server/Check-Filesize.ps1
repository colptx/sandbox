#$userlist = Get-ChildItem \\laporte\user\userdata\ -Directory | Select-Object -ExpandProperty Name
$userlist = 'user'


foreach ($u in $userlist) {
    

    $foldersize = "{0:N2} GB" -f ((Get-ChildItem \\laporte\user\userdata\$u -Recurse | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB)
    Add-Content 'C:\temp\foldersize.csv' "User: $u, folder size: $foldersize"