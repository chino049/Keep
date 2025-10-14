
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.TextBox")

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "DCPROMO AnswerFile Information"
$objForm.Size = New-Object System.Drawing.Size(455,365) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$w=$objTextBox.Text;$x=$objTextBox2.Text;$y=$objTextBox3.Text;$z=$objTextBox4.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(120,285)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$w=$objTextBox.Text;$x=$objTextBox2.Text;$y=$objTextBox3.Text;$z=$objTextBox4.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(195,285)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$FontBold = new-object System.Drawing.Font("Arial",8,[Drawing.FontStyle]'Bold' )

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(425,20)
$objLabel.Font = $fontBold
$objLabel.text = "Please enter a Username and Password that has Domain Admin Privileges"
$objForm.Controls.Add($objLabel)

$objLabel1 = New-Object System.Windows.Forms.Label
$objLabel1.Location = New-Object System.Drawing.Size(30,47) 
$objLabel1.Size = New-Object System.Drawing.Size(60,20) 
$objLabel1.Text = "UserName:"
$objForm.Controls.Add($objLabel1)

$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(30,87) 
$objLabel2.Size = New-Object System.Drawing.Size(60,20)
$objLabel2.Text = "Password:"
$objForm.Controls.Add($objLabel2)

#$objLabel3 = New-Object System.Windows.Forms.Label
#$objLabel3.Location = New-Object System.Drawing.Size(10,170) 
#$objLabel3.Size = New-Object System.Drawing.Size(425,20)
#$objLabel3.Font = $fontBold
#$objLabel3.Text = "Please enter the Directory Services Restore Mode Administrator Password"
#$objForm.Controls.Add($objLabel3)

#$objLabel4 = New-Object System.Windows.Forms.Label
#$objLabel4.Location = New-Object System.Drawing.Size(30,198) 
#$objLabel4.Size = New-Object System.Drawing.Size(60,20) 
#$objLabel4.Text = "Password:"
#$objForm.Controls.Add($objLabel4)

#$objLabel5 = New-Object System.Windows.Forms.Label
#$objLabel5.Location = New-Object System.Drawing.Size(30,238) 
#$objLabel5.Size = New-Object System.Drawing.Size(60,20) 
#$objLabel5.Text = "Password:"
#$objForm.Controls.Add($objLabel5)

$objTextBox = New-Object System.Windows.Forms.TextBox
$objTextBox.Location = New-Object System.Drawing.Size(95,45)
$objTextBox.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox)

$objTextBox2 = New-Object System.Windows.Forms.TextBox
$objTextBox2.Location = New-Object System.Drawing.Size(95,85)
$objTextBox2.PasswordChar = '*'
$objTextBox2.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox2)

#$objTextBox3 = New-Object System.Windows.Forms.TextBox
#$objTextBox3.Location = New-Object System.Drawing.Size(95,195)
#$objTextBox3.PasswordChar = '*'
#$objTextBox3.Size = New-Object System.Drawing.Size(260,20) 
#$objForm.Controls.Add($objTextBox3)

#$objTextBox4 = New-Object System.Windows.Forms.TextBox
#$objTextBox4.Location = New-Object System.Drawing.Size(95,235)
#$objTextBox4.PasswordChar = '*'
#$objTextBox4.Size = New-Object System.Drawing.Size(260,20)
#$objForm.Controls.Add($objTextBox4)

$objForm.Topmost = $True
$handler = {$objForm.ActiveControl = $objTextBox}

$objForm.add_Load($handler)
$objForm.Add_Shown({$objForm.Activate()})
[Void] $objForm.ShowDialog()

$w
$x
$y
$z