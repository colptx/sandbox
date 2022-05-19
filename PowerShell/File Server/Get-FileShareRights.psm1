<#
    For use to extract used security groups within a file structure.
#>

function Get-FileShareRights {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$OutCSVFile = "$env:OneDrive\desktop\Get-FileShareRights_Report.csv"
    )
    begin{
        Write-Host "Gathering Data..." -ForegroundColor Yellow
        $dir = Get-ChildItem -Path $Path -Directory -Recurse
        $Report = @()
    }
    process{
        foreach ($d in $dir){
            Write-Host "$d" -ForegroundColor Yellow
            $acl = Get-Acl -Path $d.Fullname
            Foreach ($access in $acl.Access){
                $Properties = [ordered]@{'FolderName'=$d.FullName;'AD Group or User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
                $Report += New-Object -TypeName PSObject -Property $Properties
            }
        }
    }
    end{
        Write-Host "Writing Report to $OutCSVFile"
        $Report | Export-Csv -path $OutCSVFile -NoTypeInformation
    }
}