# Prompt the user for input method
$choice = Read-Host "Do you want to check a single email (S) or a list from a file (F)? [S/F]"

# Function to get mailbox type, handling ResultSize issue
function Get-MailboxType {
    param ([string]$email)

    # Get mailbox with unlimited results
    $mailbox = Get-Mailbox -Identity $email -ResultSize Unlimited -ErrorAction SilentlyContinue

    if ($mailbox) {
        return $mailbox.RecipientTypeDetails
    } else {
        return "Not Found"
    }
}

# Single Email Check
if ($choice -eq "S" -or $choice -eq "s") {
    $email = Read-Host "Enter the email address to check"
    $mailboxType = Get-MailboxType -email $email
    Write-Output "Email: $email | Mailbox Type: $mailboxType"
}

# CSV File Check (List of Emails Without a Header)
elseif ($choice -eq "F" -or $choice -eq "f") {
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "Text Files (*.txt, *.csv)|*.txt;*.csv"
    $OpenFileDialog.Title = "Select the File with Email Addresses"

    if ($OpenFileDialog.ShowDialog() -eq "OK") {
        $filePath = $OpenFileDialog.FileName

        # Read emails from file (one per line)
        $emailList = Get-Content -Path $filePath | Where-Object { $_ -match "^[\w\.-]+@[\w\.-]+\.\w+$" }

        # Check if file is empty or has invalid data
        if ($emailList.Count -eq 0) {
            Write-Output "Error: The file is empty or does not contain valid email addresses."
            exit
        }

        Write-Output "Processing $($emailList.Count) email addresses..."

        $results = @()
        $totalEmails = $emailList.Count
        $counter = 0

        # Start processing emails with a progress bar
        foreach ($email in $emailList) {
            $counter++

            # Update progress bar
            $percentComplete = [math]::Round(($counter / $totalEmails) * 100, 2)
            Write-Progress -Activity "Checking Mailboxes..." -Status "Processing: $email ($counter of $totalEmails)" -PercentComplete $percentComplete

            # Fetch mailbox type
            $mailboxType = Get-MailboxType -email $email

            # Store results
            $results += [PSCustomObject]@{
                EmailAddress = $email
                MailboxType  = $mailboxType
            }

            # Display progress live (not scrolling)
            Write-Output "[$counter/$totalEmails] $email -> $mailboxType"
        }

        # Clear progress bar
        Write-Progress -Activity "Checking Mailboxes..." -Completed

        # Ensure results are stored
        if ($results.Count -eq 0) {
            Write-Output "Error: No results found. Check if the file contains valid email addresses."
            exit
        }

        # Show a summary of results
        Write-Output "Processing complete. Example output:"
        $results | Select-Object -First 5 | Format-Table -AutoSize
        Write-Output "..."
        Write-Output "Total records processed: $($results.Count)"

        # Ask user whether to output to screen or save to file
        $outputChoice = Read-Host "Do you want the results on-screen (S) or save to CSV (C)? [S/C]"

        if ($outputChoice -eq "S" -or $outputChoice -eq "s") {
            $results | Format-Table -AutoSize
        }
        elseif ($outputChoice -eq "C" -or $outputChoice -eq "c") {
            $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
            $SaveFileDialog.Filter = "CSV Files (*.csv)|*.csv"
            $SaveFileDialog.Title = "Choose Save Location"
            $SaveFileDialog.FileName = "MailboxTypeResults.csv"

            if ($SaveFileDialog.ShowDialog() -eq "OK") {
                $outputFilePath = $SaveFileDialog.FileName
                $results | Export-Csv -Path $outputFilePath -NoTypeInformation
                Write-Output "Results saved to: $outputFilePath"
            } else {
                Write-Output "No save location chosen. Exiting."
            }
        }
        else {
            Write-Output "Invalid selection. Exiting."
        }
    } else {
        Write-Output "No file selected. Exiting."
    }
}

# Invalid input handling
else {
    Write-Output "Invalid selection. Please run the script again and choose 'S' or 'F'."
}
