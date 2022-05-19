<#
.SYNOPSIS
    Synopsis
 
.DESCRIPTION
    Description
 
.NOTES
    Notes

.LINK
    LINK

 
#>

<#
    Splatting of Vss Writers and their associated services
.EXAMPLE
    'Writer Name' = "Service Name"
#>
$vssHash = @{
    #'ADAM (<instnace_name>) Writer'    = "ADAM_<instance_name>"; # Need to work this one out
    'ASR Writer'                        = 'VSS';
    'BITS Writer'                       = 'BITS';
    'Certificate Authority'             = 'CertSvc';
    'COM+ REGDB Writer'                 = 'VSS';
    'Cluster Database'                  = 'ClusSvc';
    'Dedup Writer'                      = 'ddpvssvc';
    'DFS Replication service writer'    = 'DFSR';
    'DHCP Jet Writer'                   = 'DHCPServer';
    'FRS Writer'                        = 'NtFrs';
    'FSRM writer'                       = 'srmsvc';
    'IIS Config Writer'                 = 'AppHostSvc';
    'IIS Metabase Writer'               = 'IISADMIN';
    'Microsoft Exchange Replica Writer' = 'MSExchangeRepl';
    'Microsoft Exchange Writer'         = 'MSExchangeIS';
    'Microsoft Hyper-V VSS Writer'      = 'vmms';
    'MSMQ Writer (MSMQ)'                = 'MSMQ';
    'MSSearch Service Writer'           = 'WSearch';
    'NPS VSS Writer'                    = 'EventSystem';
    'NTDS'                              = 'TDS';
    'OSearch VSS Writer'                = 'OSearch';
    'OSearch14 VSS Writer'              = 'OSearch14';
    'OSearch15 VSS Writer'              = 'OSearch15';
    'Registry Writer'                   = 'VSS';
    'Shadow Copy Optimization Writer'   = 'VSS';
    'SharePoint Services Writer'        = 'SPWriter';
    'SMS Writer'                        = 'SMS_SITE_VSS_WRITER';
    'SPSearch VSS Writer'               = 'SPSearch';
    'SPSearch4 VSS Writer'              = 'SPSearch4';
    'SqlServerWriter'                   = 'SQLWriter';
    'System Writer'                     = 'CryptSvc';
    'TermServLicensing'                 = 'TermServLicensing';
    'WDS VSS Writer'                    = 'WDSServer';
    'WIDWriter'                         = 'WIDWriter';
    'WINS Jet Writer'                   = 'WINS';
    'WMI Writer'                        = 'Winmgmt';
}

# Cast list of of Failed Writers to variable
# [array]$vss2 = $vss | Select-String -context 0 -pattern '^Writer name:'
# $vss3 = $vss2 | ForEach-Object {$_ -replace 'Writer name:','' -replace "'",''}

# Match writer to Services and compact to unique - cast to variable

# Restart needed services
    # Work out services with dependancies and restart them as well

# Verify Writers are good 

# Report on failed writers and if failed to reset - send SMTP

[array]$ServicesToRestart = @()
[string]$retry = '0'

# Cast list of of Failed Writers to an array
function Get-FailedVSSWriters {
    $VssWriters = vssadmin.exe List Writers
    $FailedWriters = `
        $VssWriters | Select-String -Context 0,4 '^writer name:' | 
            Where-Object {
                $_.Context.PostContext[2].Trim() -ne "state: [1] stable" -or
                $_.Context.PostContext[3].Trim() -ne "last error: no error"
            }
    [array]$Script:FailedWritersList = $FailedWriters | ForEach-Object {$_ -replace 'Writer name:','' -replace "'",''}
}

# Match writer to Services and retreive service data
function Get-ServiceLookup ($Writer) {
    Remove-Variable $Srvc
    [string]$Script:Srvc = $vssHash[$Writer]
}

# Checks if the service has any dependancies and casts to variable
function Get-ServiceDependancies ($Srvc) { 
    $Srvc = Get-Service -Name $Srvc
    if ($Srvc.DependentServices.Count -gt 0){
        Remove-Variable $Dependancies
        if ($srvc.StartType -ne "Manual"){
            [array]$Script:Dependancies = $Srvc.DependentServices | Select-Object -ExpandProperty Name
        }
    }
}

Get-FailedVSSWriters # need to loop here at least once more if there are failures... 

foreach ($Vss in $FailedWritersList) {
    
    Get-ServiceLookup -Writer $Vss
    Get-ServiceDependancies -Srvc $Srvc

    $ServicesToRestart = $Dependancies + $srvc
    Write-Host "=============================="
    Write-Host "Stopping Services"
    Write-Host "=============================="
    
    foreach($s in $ServicesToRestart){
        Stop-Service -Name $s -Verbose
    }
    #$ServicesToRestart.Reverse()
    Write-Host "=============================="
    Write-Host "Starting Services"
    Write-Host "=============================="
    
    foreach($s in $ServicesToRestart){
        Start-Service -Name $s -Verbose
    }
}

#Body of Email Message
$body = @" 
<html>  
  <body>  
    Failed VSS Writers: $failedVss<br>
    Recovered VSS Writers: <br> 
  </body>  
</html>  
"@

# Email Property Splat
$params = @{
    #Attachments = $outfile
    Body = $body 
    BodyAsHtml = $true 
    Subject = "Failed VSS Writers"
    From = "$env:COMPUTERNAME@email.com"
    To = 'dept@email.com' 
    Cc = 'me@email.com', 'me@email.com'
    #BCC = 'me@email.com'
    SmtpServer = 'SMTP' 
} 

try{
    Send-MailMessage @params
}catch{
    Write-Warning "Unknown Error."
}