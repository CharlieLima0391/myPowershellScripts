$BLV = Get-BitLockerVolume -MountPoint 'c:'
if ($BLV.volumeStatus -eq 'FullyDecrypted') {
    Add-BitLockerKeyProtector -MountPoint 'c:' -RecoveryPasswordProtector
    Enable-Bitlocker -MountPoint 'c:' -TpmProtector
}
