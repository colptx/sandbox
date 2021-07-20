$servers = Get-ADComputer -Properties OperatingSystem -Filter {
    OperatingSystem -like "*Server*" -and 
    Enabled -eq $true -and 
    Name -notlike '*cluster*' -and
    Name -notlike 'FS01'
} | Select-Object -ExpandProperty Name | Sort-Object
$outFile =  'D:\temp\InstalledFeatures.csv' 

New-Item -Path $outFile | Out-Null

    foreach ($server in $servers) {
        if (Test-Connection $computer -Count 1 -ErrorAction SilentlyContinue){
            $results = Get-WindowsFeature -ComputerName $server| Where-Object {$_.InstallState -eq "Installed"} 

            $data = `
            foreach ($result in $results) {
                [PSCustomObject]@{
                    Host = $server
                    DisplayName = $result.DisplayName
                    Name = $result.Name
                }
            }
            $data | Select-Object Host, DisplayName, Name | Export-Csv -Path $outFile -Delimiter "," -NoTypeInformation -Append
        }else{
            $offline = @(
                [PSCustomObject]@{
                    PSComputerName = $computer
                    Name = "Offline"
                    ObjectClass = ""
                }
            )
            $offline | Export-Csv -Path $outFile -NoTypeInformation -Append
        }
    }
