foreach($item in (get-adgroup -filter * | sort-object | select-object Name)){

#$item | Out-File -FilePath C:\Users\chrisle\Desktop\csvExports\DomainGroupList_New.csv
$item

}




#| export-csv "C:\Users\chrisle\Desktop\csvExports\DomainGroupList.csv"



