Get-WinEvent -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; ID=307; StartTime=(Get-Date -OutVariable Now).AddDays(-1)} |
Select-Object -Property TimeCreated,
                        @{label='UserName';expression={$_.properties[2].value}},
                        @{label='ComputerName';expression={$_.properties[3].value}},
                        @{label='PrinterName';expression={$_.properties[4].value}},
                        @{label='PrintSize';expression={$_.properties[6].value}},
                        @{label='Pages';expression={$_.properties[7].value}} |
Export-Csv -Path "Printing Audit - $($($Now).ToString('yyyy-MM-dd')).csv" -NoTypeInformation