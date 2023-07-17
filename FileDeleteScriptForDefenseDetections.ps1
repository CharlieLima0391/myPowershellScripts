# Import the CSV file
$csvFile = "C:\Users\chrisd\Downloads\FileList.csv" #This will need changing to your own path.
$csvData = Import-Csv -Path $csvFile
$logDate = get-date -Format yyyy-MM-dd-hh-mm-ss

# Specify the log file path
$logFile = "C:\Users\chrisd\Downloads\LogFile_$logDate.txt" #This will need changing to your own path.

# Loop through each row in the CSV
foreach ($row in $csvData) {
    $hostname = $row.description
    $filePath = $row.malware

    # Combine the host IP and file path
    $fullPath = "\\$hostname\$filePath"
    $fullPath = $fullPath.Replace(":", "$")

    # Remove invalid characters from the file path
    $invalidChars = '[<>:"|?*]'
    $fullPath = $fullPath -replace $invalidChars

    if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
        Remove-Item -Path $fullPath -Force
        $result = "Found file ****DELETED****: $fullPath"
    } else {
        $result = "File not found: $fullPath"
    }

    # Append the result to the log file
    $result | Out-File -FilePath $logFile -Append
}
