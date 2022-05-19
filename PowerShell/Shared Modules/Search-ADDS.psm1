Set-alias -name san -Value Search-ADName
Set-alias -name sad -Value Search-ADDepartment
Set-Alias -name sac -Value Search-ADComputer
Set-Alias -name sae -Value Search-ADEmployeeID


function Search-ADName {
<#
.SYNOPSIS
    I was annoyed when I could not remember a person's first or last names so I created this function to search AD to help...
.DESCRIPTION
   Search's AD using the provided user first or last name within the Name Property and displays the Title and Department to help verify the user.
.PARAMETER User
    Manditory vairable to use to search for the AD user name. You may also use the alias 'u'.
.EXAMPLE
    Search-UserName -User Seals
    Search-Username -u Thomas
.NOTES
    File Name: Search-User.ps1
    Author:    Thomas Seals
    E-mail:    SealsT@Laportetx.gov
    PSVer:     4.0/5.0
    UpdNote:
        Added Department and title to results
        Added HomeDirectory to results 
        Removed HomeDirectory from results
        Added Lockedout to results
#>

[cmdletbinding()]
param(

    [Parameter(Mandatory=$true,
    HelpMessage="Please Enter a Name")]
    [Alias("u")]
    [ValidateNotNullOrEmpty()]
    [string]$User

)## End Param

Begin { }## End Begin Script Block

Process {

    get-ADuser -Properties Title,Department,Lockedout, EmployeeID -Filter "Name -like '*$user*'" | 
    Select-Object Name,SamAccountName,EmployeeID, Title,Department,Lockedout | 
    Format-Table -AutoSize

}## End Process

End { }## End End Script Block

}## End Fuction Search-UserName


function Search-ADDepartment  {

    <#
    .SYNOPSIS
        I was annoyed to not being able to quickly pull a list of users that were in a department.
    .DESCRIPTION
       Searchs AD to find all users within the department.
    .PARAMETER User
        Manditory vairable to use to search for the AD user name. You may also use the alias 'dept'.
    .EXAMPLE
        Search-UserName -department City Management
        Search-Username -dept IT
    .NOTES
        File Name: Search-User.ps1
        Author:    Thomas Seals
        E-mail:    SealsT@Laportetx.gov
        PSVer:     4.0/5.0
        UpdNote:
    #>

    [cmdletbinding()]
    param(

        [Parameter(Mandatory=$true,
        HelpMessage="Please Enter a Department")]
        [Alias("dept")]
        [ValidateNotNullOrEmpty()]
        [string]$department

    )## End Param

    Begin { }## End Begin Script Block

    Process {

        $d = get-ADuser -Properties Title,Department,Enabled,EmployeeID -Filter "(department -like '*$department*') -and (Enabled -eq 'True')" | 
        Select-Object Name,SamAccountName,EmployeeID,Title,Department | 
        Sort-Object Name |
        Format-Table -AutoSize
        $d
        #Write-Host "Total:  @($d).Count" #Displaying first but I want it last... How do???
    }## End Process

    End { }## End End Script Block

}## End Fuction Search-UserName

function Search-ADComputer {
<#
    .SYNOPSIS
     
    .DESCRIPTION
      
    .PARAMETER User
    
    .EXAMPLE
    .NOTES
        File Name: Search-User.ps1
        Author:    Thomas Seals
        E-mail:    SealsT@Laportetx.gov
        PSVer:     4.0/5.0
        UpdNote:
#>
[cmdletbinding()]
param(

    [Parameter(Mandatory=$true,
    HelpMessage="Please Enter a Description to search")]
    [Alias("desc")]
    [ValidateNotNullOrEmpty()]
    [string]$Description

)## End Param

Begin { }## End Begin Script Block

Process {

    Get-ADComputer -Properties Description, Enabled, DistinguishedName -Filter "Description -like '*$Description*'" | 
    Select-Object Name,Enabled,Description,DistinguishedName | 
    Sort-Object Name |
    Format-Table -AutoSize

}## End Process

End { }## End End Script Block

} ## End Function Search-UserComputer


function Search-ADEmployeeID  {

    <#
    .SYNOPSIS
        
    .DESCRIPTION
       
    .PARAMETER User
        Manditory vairable to use to search for the AD user name. You may also use the alias 'empid'.
    .EXAMPLE
        Search-ADEmployeeID -empid E0002077
        Search-ADEmployeeID -empid 2077
    .NOTES
        File Name: Search-User.ps1
        Author:    Thomas Seals
        E-mail:    SealsT@Laportetx.gov
        PSVer:     4.0/5.0
        UpdNote:
    #>

    [cmdletbinding()]
    param(

        [Parameter(Mandatory=$true,
        HelpMessage="Please Enter a EmployeeID")]
        [Alias("Empid")]
        [ValidateNotNullOrEmpty()]
        [string]$EmployeeID

    )## End Param

    Begin { }## End Begin Script Block

    Process {

        $d = get-ADuser -Properties Title,Department,Enabled,EmployeeID -Filter * | Where-Object {$_.EmployeeID -like "*$EmployeeID*"} |
        Select-Object Enabled,Name,SamAccountName,EmployeeID,Title,Department | 
        Sort-Object Name |
        Format-Table -AutoSize
        $d
    }## End Process

    End { }## End End Script Block

}## End Fuction Search-UserName