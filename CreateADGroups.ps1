Import-Module ActiveDirectory

#Set the location of the host list to be used
$HostList = Get-Content C:\Users\cleadmin\Documents\ADCleanup\testhostlist.txt

#Set the Description strings for filling in the description information
$DescriptionPrefix = "Allow users in this group RDP access to "
$DescriptionSuffix = ".tusk-watf.tuskerdirect.com"

#Set the location groups are to be created (Which OU)
$OUForRDPSecGroups = "OU=RemoteDesktop_UserAccess,OU=Security,OU=Tusker_Groups,OU=Tusker,DC=tusk-watf,DC=tuskerdirect,DC=com"

ForEach ($hostname in $HostList){

#Pre-fab the strings to be used in the group and description names
$SecurityGroupName_rdpusers = "AllowRDP_" + $hostname
$SecurityGroupName_localadmin = "LocalAdmin_" + $hostname
$SecurityGroupDescription_rdpusers = $DescriptionPrefix + $hostname.ToUpper() + $DescriptionSuffix
$SecurityGroupDescription_localadmins = $DescriptionPrefix + $hostname.ToUpper() + $DescriptionSuffix

#Create the security group
New-ADGroup -Name $SecurityGroupName_rdpusers -SamAccountName $SecurityGroupName_rdpusers -GroupCategory Security -GroupScope Global -DisplayName $SecurityGroupName_rdpusers -Path "OU=RemoteDesktop_UserAccess,OU=Security,OU=Tusker_Groups,OU=Tusker,DC=tusk-watf,DC=tuskerdirect,DC=com" -Description $SecurityGroupDescription_rdpusers

#Add domain admins to the security group (Basically making sure domain admins have RDP access by defualt)
Add-ADGroupMember $SecurityGroupName_rdpusers "domain admins"

#Add the newly crearted group to the "EnableRDPAccessOnServers" security group
Add-ADGroupMember "EnableRDPAccessOnServers" $SecurityGroupName_rdpusers

#Create a group for local system admins
New-ADGroup -Name $SecurityGroupName_localadmin -SamAccountName $SecurityGroupName_localadmin -GroupCategory Security -GroupScope Global -DisplayName $SecurityGroupName_localadmin -Path "OU=Servers_SetLocalAdmin,OU=Security,OU=Tusker_Groups,OU=Tusker,DC=tusk-watf,DC=tuskerdirect,DC=com" -Description $SecurityGroupDescription_localadmin

#Add domain admins to the security group (Basically making sure domain admins have RDP access by defualt)
Add-ADGroupMember $SecurityGroupName_localadmin "domain admins"
}

