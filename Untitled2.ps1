$DomainGroups = Get-Content -path "C:\Users\chrisle\Desktop\csvExports\DomainGroupList.csv"

foreach($DomainGroup in $DomainGroups){

    $RQ_DomainGroup = $DomainGroup.Replace("`"","") | export-csv "C:\Users\chrisle\Desktop\csvExports\NoQuotesDomainGroupList.csv"
    #Get-ADGroupMember $RQ_DomainGroup
    $RQ_DomainGroup

    
    }