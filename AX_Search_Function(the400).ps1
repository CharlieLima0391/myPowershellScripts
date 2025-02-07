Import-Module ExchangeOnlineManagement

'''
The exchange module is not installed, it will need to be installed with the details that can be found here
https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps
and a connection established to the exchange
'''
 

#$EmailList = Get-Content C:\Users\WDAGUtilityAccount\Desktop\MailBoxList.txt


$emailList = @(

"email01@email.com",
"email02@email.com"

)



# Generate a time stamp in a friendly format, e.g. "20250207_134522"
$TimeStamp = Get-Date -Format 'yyyyMMdd_HHmmss'

# Define the log file path
$LogFile = "C:\Logs\AXRules_$TimeStamp.txt"

ForEach ($email in $EmailList) {

    # Write mailbox being checked
    "Checking Mailbox: $email" | Out-File -FilePath $LogFile -Append
    
    # Retrieve any inbox rules that contain "AX" in the Name
    $axRules = Get-InboxRule -Mailbox $email | Where-Object { $_.Name -like "*AX*" }

    if ($axRules) {
        "Rules Containing 'AX' in the name:" | Out-File -FilePath $LogFile -Append
        
        # Print each rule’s details to the log file
        $axRules | Out-String | Out-File -FilePath $LogFile -Append
    }
    else {
        "No Rules Match" | Out-File -FilePath $LogFile -Append
    }

    "----- Next -----" | Out-File -FilePath $LogFile -Append
}

