<#
	For CVE-2021-34527 and going forward of disabling on new server
#>

$servers = Get-ADComputer -Properties OperatingSystem -SearchBase 'OU=Servers,OU=location,DC=domain,DC=com' -filter {
    Enabled -eq $true -and 
    OperatingSystem -like '*Server*' -and 
    Name -notlike ‘printserver1’ -and
    Name -notlike 'dms1'
} | Select-Object -ExpandProperty Name
$service = 'Spooler'

try{

    foreach ($s in $servers) {
        $spooler = Get-Service -ComputerName $s -Name $service 
        if ($spooler.status -eq 'Running'){
            Write-Host "$s - Spooler is Running." -ForegroundColor Yellow
            Invoke-Command -ComputerName $s -ScriptBlock {Stop-Service -Name $using:service -Force}
            Invoke-Command -ComputerName $s -ScriptBlock {Set-Service -Name $using:service -StartupType Disabled}
        }else{
            Write-Host "$s - Spooler is Disabled." -ForegroundColor Green
        }
    }
}catch{}
