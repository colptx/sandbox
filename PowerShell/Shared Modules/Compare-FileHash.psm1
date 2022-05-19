function Compare-FileHash {
<#
.SYNOPSIS
    I wanted to easily compare two files and their hashes with common algorithms for a desktop or cli enviroment. I did this by utilizing Powershell's already impressive Get-FileHash command.
 
.DESCRIPTION
    Compare-FileHash takes CLI or Dialogbox selection of two files on the local host or network and hashes them with the selected algorithm and displays the results and outcome to the shell. Please allow time for the calculation on larger files.
    
.EXAMPLE
    Compare-FileHash -Mode CLI 
        This is the default selection and it will prompt for your Algorithm selection, File1, and finally File2.
.EXAMPLE
    Compare-FIleHash -Mode Interactive 
        It will prompt for your Algorithm selection and this time a DialogBox will popup for the First file, and then the second file. 

.NOTES
    FileName:   Compare-FileHash.ps1
    Author:     Thomas Seals
    E-mail:     
    PSVer:      5.1
    Updates:

#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("CLI", "Interactive")]
    [String]$Mode = 'CLI'
)
begin{
    function Show-Menu{
        param (
            [string]$Title = 'Algorithm'
        )
        Clear-Host
        Write-Host "================ $Title ================"
        
        Write-Host "1: Press '1' for MD5"
        Write-Host "2: Press '2' for SHA1"
        Write-Host "3: Press '3' for SHA256"
        Write-Host "4: Press '4' for SHA512"
    }

    function Select-File {
        Add-Type -AssemblyName System.Windows.Forms
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    #   $FileBrowser.filter = "Txt (*.txt)| *.txt"
        $FileBrowser.Title = "Select a file for comparison"
        [void]$FileBrowser.ShowDialog()
        $FileBrowser.FileName
    } #End of Function Select-File
} #End of begin block

process {

    do {
        Show-Menu
        $Selection = Read-Host -Prompt "Please select an Algorithm"
        switch($Selection){
        '1' {$Alg = 'MD5'} 
        '2' {$Alg = 'SHA1'}
        '3' {$Alg = 'SHA256'}
        '4' {$Alg = 'SHA512'}
        #default {$Alg = 'SHA1'}
        }
    } until (($null -ne $Alg) -or ($Alg -eq 1..4))

    if ($mode -eq 'Interactive'){
        $FirstFile = Get-FileHash -Path $(Select-File) -Algorithm $Alg
        $SecondFile = Get-FileHash -Path $(Select-File) -Algorithm $Alg
    }else{       
        [string]$FirstInput = Read-Host -Prompt "Path to First File:"
        [string]$SecondInput = Read-Host -Prompt "Path to Second File:"
        if (($null -eq $FirstInput) -or ($null -eq $SecondInput )){
        }else{
            $FirstFile = Get-FileHash -Path $FirstInput
            $SecondFile = Get-FileHash -Path $SecondInput
        }
    }
} #End Of Process block

end {
    $FirstFile, $SecondFile
    Write-Host "Match: $($FirstFile.Hash -match $SecondFile.Hash)" -ForegroundColor Cyan
} #End of End Block
} #End of Compare-FileHash function
