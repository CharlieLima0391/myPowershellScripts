## Chris Dominguez - 05/06/2023
# DefenseAgentCheckInstall.ps1 - This script is inteded for use in Endpoint Central, and should check each node for the presence of
# the Defense agents, and if not found, installs them.
# NOTE: Do not use this script on user endpoints, BEFORE removing the Auditbeat and Winlogbeat installs. 
# ALSO NOTE: that the individual scripts for install are provided by Defense.


# Script must be re-codeSigned if edited

#Auditbeat Location: "C:\Users\cdadmin\Desktop\tusker-direct\tusker-direct\auditbeat-windows\install-service-auditbeat.ps1"
#WinlogBeatLocation: "C:\Users\cdadmin\Desktop\tusker-direct\tusker-direct\winlogbeat\install-service-winlogbeat.ps1"

$servicesToCheck = @(
    "EPIntegrationService",
    "EPProtectedService",
    "EPRedline",
    "EPSecurityService",
    "EPUpdateService",
    "Auditbeat",
    "WinlogBeat"
)

# Loop over each service and check if it exists
foreach ($service in $servicesToCheck) {
    # Get the service
    $serviceInstance = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($null -eq $serviceInstance) {
        # Service not found
        Write-Output "Service '$service' not found."

        # Check which script to run
        if ($service -like "EP*") {
            #------------------------------------AV Install SCRIPT---------------------------------------------------
            Write-Output "Run the AV install script for service '$service' (to be added)"
            #--------------------------------------------------------------------------------------------------------

        } elseif ($service -eq "Auditbeat") {
            #------------------------------------AUDITBEAT SCRIPT-(Provided by Defense)------------------------------
            # Using $PSScriptRoot
            $scriptPath = Join-Path $PSScriptRoot "auditbeat-windows\install-service-auditbeat.ps1"
            & $scriptPath
            start-service auditbeat
            write-host "Waiting 10 seconds for service to start before continuing..."
            Start-Sleep -seconds 10
            Get-Service auditbeat
            #--------------------------------------------------------------------------------------------------------

        } elseif ($service -eq "WinlogBeat") {
            #------------------------------------WINLOGBEAT SCRIPT-(Provided by Defense)-----------------------------
            # Using $PSScriptRoot
            $scriptPath = Join-Path $PSScriptRoot "winlogbeat\install-service-winlogbeat.ps1"
            & $scriptPath
            start-service winlogbeat
            write-host "Waiting 10 seconds for service to start before continuing..."
            Start-Sleep -seconds 10
            Get-Service winlogbeat
            #--------------------------------------------------------------------------------------------------------
        }
    } else {
        Write-Output "Service '$service' found."
    }
}