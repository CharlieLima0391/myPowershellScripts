Import-Module ExchangeOnlineManagement

'''
The exchange module is not installed, it will need to be installed with the details that can be found here
https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps
and a connection established to the exchange
'''
 

#$EmailList = Get-Content C:\Users\WDAGUtilityAccount\Desktop\MailBoxList.txt


$emailList = @(

"email1@mail.com",
"email2@mail.com",
"email3@mail.com"

)



ForEach ($email in $EmailList){
    
    Write-Host "`nChecking Mailbox:" $email

    $axRules = Get-InboxRule -Mailbox $email | Where-Object { $_.Name -like "*AX*"}

    if ($axRules) {

        Write-Host "Rules Containing 'AX' in the name:"
        $axRules
    }
    else {
    Write-Host "No Rules Match"
    }

    write-host " ----- Next ----- "

}
