function Purge-Data {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int]$Retention
    )

    $retentionDays = (Get-Date).AddDays(-($Retention))

    if (Test-Path $Path){
        Get-ChildItem $Path -Recurse | Where-Object { (
            $_.CreationTime -lt $retentionDays)
        } | Remove-Item -Force -Recurse
    }
}