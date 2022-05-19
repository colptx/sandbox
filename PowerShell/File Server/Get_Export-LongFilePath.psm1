Function Export-LongFilePath {
<#  
.SYNOPSIS  
    To get files that are nested too deep for Windows' liking. 
.DESCRIPTION  
    This script is to get all paths that have a lenth greater than the variable within the root directory provided and export the file to csv or txt file format.
    The default length is 200.
.EXAMPLE  
    Export-LongFileName -root D:\User\ -length 50 -output C:\Temp\output.csv
.NOTES  
    File Name  : LongFilename.ps1  
    Author     : Thomas Seals  
    E-mail     : SealsT@Laportetx.gov
#>


[cmdletbinding()]
param( 

[Parameter(Mandatory=$True,
    HelpMessage="You must have a directory to search!")]
    [ValidateNotNullOrEmpty()]
    [string]$Root, 

[Parameter(Mandatory=$True,
    HelpMessage="You must have a directory to place the CSV file!")]
    [ValidateScript({
                        IF ($_ -match "\.(csv|txt)?$" ){ 
                            $True
                        }Else{
                            Throw "Must be a .csv or .txt extension!"}
        })]
    [ValidateNotNullOrEmpty()]
    [string]$Output, 

[Parameter(Mandatory=$False,
    HelpMessage="Enter a numerical value!")]
    [ValidateNotNullOrEmpty()]
    [int]$Length = "200"

    )

        Get-Childitem -path "$Root" -Recurse | 
        Select-Object -Property FullName, @{Name="FullNameLength";Expression={($_.FullName.Length)}} | 
        Where-Object {$_.FullName.Length -ge $Length} | 
        Export-Csv -Append -NoTypeInformation -Path $output

}

Function Get-LongFilePath {
<#  
.SYNOPSIS  
    To get files that are nested too deep for Windows' liking. 
.DESCRIPTION  
    This script is to get all paths that have a lenth greater than the variable within the root directory provided.
.EXAMPLE  
    Get-LongFileName -root D:\User\ -length 200
.NOTES  
    File Name  : Copy-UserData.ps1  
    Author     : Thomas Seals  
    E-mail     : SealsT@Laportetx.gov
#>


[cmdletbinding()]
param( 

[Parameter(Mandatory=$True,
    HelpMessage="You must have a directory to search!")]
    [ValidateNotNullOrEmpty()]
    [string]$Root, 

[Parameter(Mandatory=$False,
    HelpMessage="Enter a numerical value!")]
    [ValidateNotNullOrEmpty()]
    [int]$Length = "200"

    )

        Get-Childitem -path "$Root" -Recurse | 
        Select-Object -Property FullName, @{Name="FullNameLength";Expression={($_.FullName.Length)}} | 
        Where-Object {$_.FullName.Length -ge $Length}

}