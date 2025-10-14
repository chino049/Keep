$cn = Get-WmiObject -Class Win32_ComputerSystem
echo $cn

$bn = Get-WmiObject -Class Win32_BIOS -ComputerName .
echo $bn

$usern = Get-WmiObject -Class Win32_ComputerSystem -Property UserName -ComputerName .
echo $usern

$na = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*
echo $na