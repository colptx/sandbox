<#
    Formats given MAC into Microsoft's format that is used in some places. E.g. Get-DhcpServerv4Lease 
#>
function ConvertTo-MsMacFormat {
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern(“^[0-9A-Fa-f]{12}|([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})|([0-9a-fA-F]{4}\.[0-9a-fA-F]{4}\.[0-9a-fA-F]{4})$”)]
        [string]$MacAddr
    )
    if ($MacAddr -match [regex]'([0-9A-Fa-f]{2}[-]){5}([0-9A-Fa-f]{2})'){Return $MacAddr}
    $MacStripped = $($MacAddress -Split {$_ -eq '.' -or $_ -eq ':'}) -join ''
    $MSMacFormat = ($MacStripped -split '([0-9A-Fa-f]{2})' | Where-Object {$_}) -join '-'
    Return $MSMacFormat
}