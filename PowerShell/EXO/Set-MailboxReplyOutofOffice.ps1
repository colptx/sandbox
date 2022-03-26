#
# Connect-ExchangeOnline
#
$email = 'charless@email.com'
$femail = 'HumanResources@email.com'
$emsg = "I will be out of the office indefinitely starting Monday, March 16th. Emails will be automatically routed to HumanResources@example.com<mailto:HumanResources@example.com> during this leave. Another HR teammate will be in contact with you."
$imsg = "I will be out of the office indefinitely starting Monday, March 16th. Emails will be automatically routed to HumanResources@example.com<mailto:HumanResources@example.com> during this leave. Another HR teammate will be in contact with you."


Set-MailboxAutoReplyConfiguration -Identity $email -AutoReplyState Enabled -ExternalMessage $emsg -InternalMessage $imsg
Set-Mailbox -Identity $email -DeliverToMailboxAndForward $true -ForwardingSMTPAddress $femail

Get-MailboxAutoReplyConfiguration -Identity $email | Format-List AutoReplyState, ExternalMessage, InternalMessage
Get-Mailbox $email | Format-List ForwardingSMTPAddress,DeliverToMailboxandForward