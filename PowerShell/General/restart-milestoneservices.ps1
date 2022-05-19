<#

    When rebooting the milestone server, it will more than likely does not
    start the services that server needs to run...

    I set it up for a scheduled task on 15minutes after startup.
#>

function Get-NotRunningMilestoneServices {
    Get-Service *milestone* | Where-Object {$_.Status -ne 'Running'}
    return
}

$result = Get-NotRunningMilestoneServices

if (($result).count -gt 0){

    $timeout = 30 #seconds
    $milestoneServices = Get-NotRunningMilestoneServices

        foreach ($service in $milestoneServices) {

            Write-host  "Attempting to restart service $service..."
            Start-Service $service | Wait-Job -Timeout $timeout

        }
}


if ((result).count -gt 0){

    $hostname = $env:COMPUTERNAME
    $body = @' 
<html>  
<body>  
    Milestone Services did not start properly after a reboot.<br>
</body>  
</html>  
'@

    $params = @{
        Body = $body 
        BodyAsHtml = $true 
        Subject = "$hostname Milestone Services Failed to Start." 
        From = "$hostname@laportetx.gov"
        To = 'email@example.com'
        SmtpServer = 'smtp.domain.local'
    } 
    
    Send-MailMessage @params
            
} else {
    Write-Host "Nothing to Report!" -ForegroundColor Green
}