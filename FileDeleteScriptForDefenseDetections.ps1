# Import the CSV file
$csvFile = "C:\Users\chrisd\Downloads\FileList.csv"
$csvData = Import-Csv -Path $csvFile

# Specify the log file path
$logFile = "C:\Users\chrisd\Downloads\LogFile.txt"

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
