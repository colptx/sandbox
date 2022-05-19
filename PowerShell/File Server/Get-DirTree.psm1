Function Get-DirTree {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({if (Test-Path $_ -PathType 'Container'){$true}else{throw "Invalid Path: '$_'.  You must provide a valid directory."}})]
        [String]$Path
    )
    Write-Host "Walking Directories..." -ForegroundColor Yellow
    Get-Item -Path $Path
    Get-ChildItem -Path $Path -Recurse -Directory
}