Import-Module ExchangeOnlineManagement

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