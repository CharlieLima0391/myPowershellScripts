Import-module grouppolicy

$gpos= get-gpo -all

foreach ($object in $gpos){

    $gpoSetting = get-gporeport -guid $object.id -ReportType xml | select-string -Pattern "cmd" #change the pattern to edit the search crieria
    

    if ($gpoSetting){
        Write-output "GPO Name: $($object.displayname)"
        Write-Output "GPO ID: $($object.id)"
        Write-Output "------------------------------------------------------"

        }

    }
