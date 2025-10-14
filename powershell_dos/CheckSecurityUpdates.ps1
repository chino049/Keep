$sa = Read-Host -Prompt "Enter security update or Enter to display all"
 
If ($sa) {
   #$hf = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName . | select-string $sa
   
   echo $hf
} else {
   #$hf = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName . 
   $hf = Get-HotFix
   echo $hf
}