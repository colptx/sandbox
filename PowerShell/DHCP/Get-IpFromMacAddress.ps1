<#
    I wanted a quick tool that would locate a Mac address within DHCP servers.
    Imports the format coversion I had to write to accept any normal format of a MAC address.

    .TODO
    Add functionality for multiple mac addresses
#>

Import-Module ./ConvertTo-MsMacFormat

function Get-IpFromMacAddress {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True,
        HelpMessage="Please Enter a DHCP Server to search")]
        [ValidateNotNullOrEmpty()]
        [array]$DhcpServers,
        [Parameter(Mandatory=$True,
        HelpMessage="Please Enter a Address to search for")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern(“^[0-9A-Fa-f]{12}|([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})|([0-9a-fA-F]{4}\.[0-9a-fA-F]{4}\.[0-9a-fA-F]{4})$”)]
        [string]$MacAddress
    )
    
    Begin{}
    Process{
            foreach($DhcpServer in $DhcpServers){
                $Mac = ConvertTo-MsMacFormat -MacAddr $MacAddress
                Get-DhcpServerv4Scope -ComputerName $DhcpServer | Get-DhcpServerv4Lease -ComputerName $DhcpServer | Where-Object {$_.clientid -eq $Mac}
            }            
        }
    End{}
}