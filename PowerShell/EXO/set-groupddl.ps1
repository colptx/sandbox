<#
This script is intended to be used to set Users extensionAttribute1 for the Exchange admin center (EAC) and its Dynamic Distribution List (DDL) for CityUsers@example.com address.

    # used to check filter will be applied correctly - Attributes will have to wait for Azure Actived Directory Sync to complete before results will show.
    (Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup $group).recipientfilter)

    # used to get the list of departments and output to file
    $departments = Get-ADUser -Properties Department -Filter * |Sort-Object Department | select Department -Unique
    $departments | Select-Object -ExpandProperty Department | out-file D:\Temp\departmentlist.txt

#>

$dept = 'Human Resources'
$ddl = 'ddl_groupusers'


$list = Get-ADUser -Properties Department,extensionAttribute1  -Filter {Department -eq $dept} #| Select-Object Name, Department, extensionAttribute1
#Set-ADUser -Identity TAS -Clear extensionAttribute1
#Set-ADUser -Identity TAS -Add @{extensionAttribute1 = $ddl}


foreach($i in $list){

    Set-ADUser -Identity $i -Add @{extensionAttribute1 = $ddl} -Verbose

}
