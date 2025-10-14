$Form = New-Object System.Windows.Forms.Form

$MaskedTextBox = New-Object System.Windows.Forms.MaskedTextBox
$MaskedTextBox.PasswordChar = '*'
$MaskedTextBox.Top = 100
$MaskedTextBox.Left = 80

$Form.Controls.Add($MaskedTextBox)

$Form.ShowDialog()