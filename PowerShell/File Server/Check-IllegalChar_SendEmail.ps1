Import-Module .\Check-IllegalCharacters.ps1

# Create User Lists
#$userlist = Get-ADUser -Filter {(Enabled -eq $true)} -Properties HomeDirectory,UserPrincipalName | Where-Object {$_.HomeDirectory -ne $null -and $_.UserPrincipalName -ne $null} |Select-Object -ExpandProperty SamAccountName
#$dept = 'HR'
#$userlist = Get-Content "C:\Users\SealsT\OneDrive - LaPorteTX\~Projects\1. In Process\O365 - OneDrive\Setup\Migration Templets\Dept\$dept.txt"
$Userlist = @('user')

foreach ($u in $userlist){
    
    $user = Get-ADUser -Identity $u -Properties HomeDirectory,UserPrincipalName
    $USN = $user.SamAccountName
    $UPN = $user.UserPrincipalName
    $UHD = $user.HomeDirectory
    $UGN = $user.GivenName
    $outputdir = "C:\Temp\FolderCheck"

[string]$body = @" 
Dear $UGN,`r
You have received this email because some of your files cannot be synchronized to OneDrive. There are several steps you can take to resolve this issue. By opening the attachment within this email, you will see each file, its location, and the associated error at the end of each line. Below is a breakdown of each type of file error, and how to resolve it.
Error: [File type] is not a valid file type for file sync.
The file listed cannot be migrated to OneDrive because of its extension type. Instead, move the file to your (S:) drive.
Error: Illegal string '[symbol]' found
The symbol mentioned in the error cannot be used in the file name. To resolve this, remove that symbol from the file name. If necessary, it can be replaced with a dash (-) or underscore (_).
Error: File [file name] is [number of MB in size] (max is 2048) and cannot be synchronized.
The file is too large to be stored on OneDrive. Instead, move the file to your (S:\) drive.
As always, please contact helpdesk at x5032 if you need assistance. 
Thank you,
The Information Technology Team
"@  

$params = @{
    Attachments = "C:\Temp\FolderCheck\$USN.csv"
    Body = $body 
    Priority = 'High'
    #BodyAsHtml = $true 
    Subject = 'OneDrive Migration File Validation' 
    From = 'IT@laportetx.gov'
    To = $UPN
    #BCC = 'SealsT@laportetx.gov'
    SmtpServer = 'LPSMTP' 

} 

    Check-IllegalCharacters -path "$UHD\" -OutputFile "$outputdir\$USN.csv" -Verbose
    if((Get-Content $outputdir\$USN.csv -Raw) -match '\S'){Send-MailMessage @params}
}


<#
#>