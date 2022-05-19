Function Send-TestEmail {

<#
    <img src="cid:image1"><br> 
    <img src="cid:image2"> 
$images = @{ 
    image1 = 'c:\temp\test.jpg' 
    image2 = 'C:\temp\test2.png' 
} #>

[cmdletbinding()]
param(
    
[Parameter(Mandatory=$false,
    Position=1)]
    [String]$EmailTo = 'example@example.com',
[Parameter(Mandatory=$false,
    Position=2)]
    [String]$SMTP = 'SMTP01'
)

$body = @' 
<html>  
  <body>  
    Hello world.<br>
  </body>  
</html>  
'@  

$params = @{
    #InlineAttachments = $images
    #Attachments = 'C:\Temp\approved20.csv'
    Body = $body 
    BodyAsHtml = $true 
    Subject = 'Test email' 
    From = 'test@example.com' 
    To = $emailTo
    #Cc = 'recipient2@domain.com', 'recipient3@domain.com' 
    #SmtpServer = 'server.outlook.com' 
    #smtpServer = 'smtp.office365.com'
    SmtpServer = $smtp
    #Port = 587 
    #Credential = (Get-Credential) 
    #UseSsl = $true 
} 

        Send-MailMessage @params
        
}