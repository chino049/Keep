Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
 
$Form1 = New-Object System.Windows.Forms.Form
$Form1.Text = "Data Form"
$Form1.Size = New-Object System.Drawing.Size(300,200)
$Form1.StartPosition = "CenterScreen"
# Icon
$Form1.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
 
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form1.AcceptButton = $OKButton
$Form1.Controls.Add($OKButton)
 
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form1.CancelButton = $CancelButton
$Form1.Controls.Add($CancelButton)
 
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(10,20)
$Label1.Size = New-Object System.Drawing.Size(280,20)
$Label1.Text = "Enter data here:"
$Form1.Controls.Add($Label1)
 
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$Form1.Controls.Add($textBox)
 
$Form1.Topmost = $True
 
$Form1.Add_Shown({$textBox.Select()})
$result = $Form1.ShowDialog()
 
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$x = $textBox.Text
$x
 
if ($x -eq "") {[System.Windows.Forms.MessageBox]::Show("You didn't enter anything!", "Test Title")}
else {[System.Windows.Forms.MessageBox]::Show($x, "Test Title")}}
