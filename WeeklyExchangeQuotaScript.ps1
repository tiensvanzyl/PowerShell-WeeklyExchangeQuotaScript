add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010 -erroraction silentlyContinue
Set-ADServerSettings -ViewEntireForest $True
###################################################################################################################################################################################### 
# Exchange 2010 Exchange Quota Report 
# Author: Tiens van Zyl
# Version 2.0
# Date 20 November 2015
# Updated by Tiens van Zyl 7 December 2015
# Updates: Changed line 1 as the batch file errored out.
# This script outputs Exchange Quota Defaults False for our weekly report 
# 1. The script exports a CSV file with the current date.
# 2. The CSV file export displays the DisplayName, IssueWarningQuota, ProhibitSendQuota and ProhibitSendReceiveQuota 
# 3. The CSV file contains raw data that needs to be formatted in Excel (looking into Python to automate this)
# 4. Enter your mailbox server/s name in place of "ServerName" or use a wildcard to query more servers. (Line 21)
# 5. Set the path to where you'd like to export the csv file. (Line 19 - edit the path for the variable $file)
# 6. The FileName will be appended with the date that the script is run. i.e. WeeklyExchangeQuotaScript 2015-05-01.csv
######################################################################################################################################################################################
$file = "C:\Exchange_AutomatedScripts\WeeklyReports\ExchangeQuotaReport\Reports\ExchangeQuota $(get-date -f yyyy-MM-dd).csv"

Get-mailboxserver mailbox0* | Get-mailbox -resultsize unlimited |Where{($_.UseDatabaseQuotaDefaults -eq $false)} | select DisplayName, IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota | export-csv "$file"

$smtpServer = "yourSMTPserver"

$att = new-object Net.Mail.Attachment($file)

$msg = new-object Net.Mail.MailMessage

$smtp = new-object Net.Mail.SmtpClient($smtpServer)

$msg.From = "MailFromAddress@mail.com"

$msg.To.Add("toAddress@mail.com, toAddress2@mail.com, toAddress3@mail.com")

$msg.Subject = "YourMailSubject"

$msg.Body = "Some body Text"

$msg.Attachments.Add($att)

$smtp.Send($msg)

$att.Dispose()