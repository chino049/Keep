$reg = Read-Host -Prompt "Enter registry string to search for or Enter to display all"
cd hkcu:
echo $reg
if ($reg) {
    dir –r | select-string $reg
} else {
    dir -r 
}    
