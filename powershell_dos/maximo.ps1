##############################################################################################################
##                                                                                                          ##
## IP360 IP Address Retrieval Script                                                                        ##
##                                                                                                          ##
## Step 1: Retrieve Network ID's                                                                            ##
## Step 2: Retrieve Scan Profile ID for Host Inventory                                                      ## 
## Step 3: Retrieve Audit IDs Using Each Network ID against the Scan Profile ID for Host Inventory          ##
## Step 4: Retrieve IP Addresses from Hosts using all Audit IDs found in the previous steps                 ##
##                                                                                                          ##
##############################################################################################################
 
#variables
$ip360 = "D:\Program Files\Tripwire\tw-ip360commander-2.0.0\bin\ip360cmd.exe"
$ip360directory = "D:\Program Files\Tripwire\scripts\Maximo\incoming"  # holds the temp works files and final output
 
#Step 1 - Gather list of Network ID's
& $ip360 -l Maximo network fetch -c ID -q > $ip360directory\step1.txt
get-content $ip360directory\step1.txt | select -Skip 1 | set-content $ip360directory\step1updated.txt
$networkIDs = get-content $ip360directory\step1updated.txt
 
#Step 2 - Gather ID of Host Inventory
& $ip360 -l Maximo scanprofile search query:"name like '%Host Inventory%'" -c id -q > $ip360directory\step2.txt
get-content $ip360directory\step2.txt | select -Skip 1 | set-content $ip360directory\step2updated.txt
$scanProfileID = get-content $ip360directory\step2updated.txt
 
#Step 3 - Retrieve Latest Audit ID for each Network that has a Host Inventory
ForEach ($NetworkID in $NetworkIDs) {
 
Add-Content $ip360directory\step3.txt $NetworkID 
& $ip360 -l Maximo audit search query:"network=$NetworkID and ScanProfile=$scanProfileID" -q -c id | Out-File $ip360directory\NetworkScanAudit.txt
get-content $ip360directory\NetworkScanAudit.txt | select -Skip 1 | Out-File $ip360directory\NetworkScanAudit-updated.txt
 
 
[int[]]$AuditID = Get-Content $ip360directory\NetworkScanAudit-updated.txt 
$AuditID | Sort-Object -Descending | Out-File $ip360directory\NetworkScanAudit.txt
[int[]]$auditIdArray = get-content $ip360directory\NetworkScanAudit.txt
if ($auditIdArray.count -gt 0) {
   $auditIdArray[0] | Out-File -append $ip360directory\auditID.txt
   }  
 
}
 
#Step 4 - Retrieve IP Addresses for latest Audit ID of each Network that has a Host Inventory
$AuditIdList = Get-Content $ip360directory\auditID.txt
 
ForEach ($AuditId in $AuditIdList) {
 
& $ip360 -l Maximo host search query:"audit=$AuditId" -q -c ipaddress | Out-File -append $ip360directory\ipaddresses2.txt
 
}
 
$IPs = Get-Content $ip360directory\ipaddresses2.txt
$IPs -replace('ipaddress','') -replace ('"','') | Out-File $ip360directory\ipaddresses.txt
$IPAddress = Get-Content $ip360directory\ipaddresses.txt
$IPAddress = $IPAddress | sort -uniq | Out-File $ip360directory\ipaddresses.txt
 
#Clean Up Temporary Script Files
 
Remove-Item -Path $ip360directory\step1.txt
Remove-Item -Path $ip360directory\step1updated.txt
Remove-Item -Path $ip360directory\step2.txt
Remove-Item -Path $ip360directory\step3.txt
Remove-Item -Path $ip360directory\step2updated.txt
Remove-Item -Path $ip360directory\NetworkScanAudit.txt
Remove-Item -Path $ip360directory\NetworkScanAudit-updated.txt
Remove-Item -Path $ip360directory\auditID.txt
Remove-Item -Path $ip360directory\ipaddresses2.txt 
 
