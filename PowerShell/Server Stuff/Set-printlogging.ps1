Get-WinEvent -ListLog Microsoft-Windows-PrintService/Operational -OutVariable PrinterLog |
Select-Object -Property LogName, IsClassicLog, IsEnabled
 
$PrinterLog.set_IsEnabled($true)
 
$PrinterLog.SaveChanges()
 
Get-WinEvent -ListLog Microsoft-Windows-PrintService/Operational -OutVariable PrinterLog |
Select-Object -Property LogName, IsClassicLog, IsEnabled