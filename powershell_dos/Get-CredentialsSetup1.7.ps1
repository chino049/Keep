

if (!(Test-Path -Path .\10.248.230.102.txt))  {
	#(Get-Credential -credential 'readonly' -Message "VnE").password | convertfrom-SecureString  | set-content 10.248.230.102.txt 
	(Get-Credential -credential 'readonly').password | convertfrom-SecureString  | set-content 10.248.230.102.txt 
}
$p = get-content "c:\Users\Administrator\MT\10.248.230.102.txt" | convertto-securestring
$credential_102 = New-Object System.Management.Automation.PsCredential("readonly",$p)
$p = $credential_102.GetNetworkCredential().Password
[System.Environment]::SetEnvironmentVariable('pass102', $p)
get-ChildItem Env:pass102 | out-null


if (!(Test-Path -Path .\10.248.230.119.txt))  {
	(Get-Credential -credential 'readonly').password | convertfrom-SecureString | set-content 10.248.230.119.txt
}
$p1 = get-content "c:\Users\Administrator\MT\10.248.230.119.txt" | convertto-securestring
$credential_119 = New-Object System.Management.Automation.PsCredential("readonly",$p1)
$p1 = $credential_119.GetNetworkCredential().Password
[System.Environment]::SetEnvironmentVariable('pass119', $p1)
get-ChildItem Env:pass119 | out-null

#write-host "Done..." 

#.\Get-DPStatusReportv1.5.4.ps1 -vne 10.248.230.102 -password $pass

