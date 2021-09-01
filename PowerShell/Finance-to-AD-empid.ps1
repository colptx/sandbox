<#

Select id, e_mail, lname, fname, name
from hr_empmstr 
where hr_status = 'A'

Get-ADUser -properties employeeID, emailaddress, givenname, surname ,samaccountname -filter {Enabled -eq $true} | FT | Out-Gridview

#>

$fpath = "C:\temp"
$osempid = Import-Csv -Path $fpath\osempid.csv -Header 'empid','email', 'lname', 'fname', 'name', 'samaccountname'
$wempid = $adempid
$adempid = Import-Csv -Path $fpath\adempid.csv -Header 'email','empid', 'lname', 'fname', 'name', 'samaccountname'

foreach ($user in $wempid) {
    Write-Host $user.lname","$user.fname
    $hardMatch = $($osempid | Where-Object {($_.lname -imatch $user.lname) -and ($_.fname -imatch $user.fname)}).empid
    $softMatch = $($osempid | Where-Object {($_.lname -imatch $user.lname)}).empid
    if ($hardMatch){
        Write-Host Hard Match on $user -ForegroundColor Green
        $user.empid = $hardMatch
    }elseif($softMatch){
        Write-Host Soft Match on $user -ForegroundColor Cyan
        $user.empid = $softMatch
    }else{
        Write-Host No Match on $user -ForegroundColor Yellow
    }
}

$wempid | Out-GridView
$wempid | Export-Csv -Path $fpath\wempid.csv -NoTypeInformation

$userimport = Import-Csv -path "$fpath\wempid.csv" -Header 'email','empid', 'lname', 'fname', 'name', 'samaccountname'

foreach ($user in $userimport) {
    Write-Host $user.samaccountname -ForegroundColor Cyan
    Set-ADUser $user.samaccountname -EmployeeID  $user.empid
}
