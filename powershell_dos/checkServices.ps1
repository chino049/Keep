$asset = Read-Host -Prompt "Enter server  IP"
$nu = net use z: \\$asset\admin$ /USER:administrator nCircle007
#$ipa = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Format-Table -Property IPAddress
#echo "Comm" $ipa
#echo "code" $?
$gs = get-service -computername $asset |  where-object status -eq "Running" | ft -Property name, status
#echo $gs | get-Member 
echo $gs
net use z: /d
