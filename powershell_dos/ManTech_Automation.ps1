

.\Get-CredentialsSetup1.7.ps1

Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @(600,540)
$form.StartPosition = "CenterScreen"
#$form.BackColor = "#E58633"
$form.BackColor = "#D6EAF8"

#$lo = Get-Location  | out-string
$lo=$CurrentDir = $(get-location).Path;
#$lo = convert-path
$loc=$lo+"\1.png"
#write-host "..", $loc
#C:\Users\Administrator\MT\1.png'

$img = [System.Drawing.Image]::Fromfile($loc)
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = $img.Size.Width
$pictureBox.Height = $img.Size.Height
$pictureBox.Image = $img

$btn111 = New-Object System.Windows.Forms.Button
$btn111.Location = new-object System.Drawing.Size(270,50)
$btn111.Size = new-object System.Drawing.Size(50,20)
$btn111.Text = "VnE:"

$DropDownArray = "10.248.230.102" , "10.248.230.119" , "10.248.230.112"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$DropDown = new-object System.Windows.Forms.ComboBox
$DropDown.Location = new-object System.Drawing.Size(270,75)
#$DropDown.DropDownStyle = 2
ForEach ($Item in $DropDownArray) { $DropDown.Items.Add($Item) | Out-Null }
$DropDown.SelectedIndex='0'
$Form.Controls.Add($DropDown)

#write-host $DropDown.SelectedIndex 
#write-host $DropDown.SelectedItem

$btn = New-Object System.Windows.Forms.Button
$btn.Location = new-object System.Drawing.Size(15,120)
$btn.Size = new-object System.Drawing.Size(220,20)
$btn.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-DPStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-DPStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} ) 
$btn.Text = "Get-DPStatusReportv1.7"

$btn1 = New-Object System.Windows.Forms.Button
$btn1.Location = new-object System.Drawing.Size(15,160)
$btn1.Size = new-object System.Drawing.Size(220,20)
$btn1.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-OperationalStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-OperationalStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn1.Text = "Get-OperationalStatusReportv1.7"

$btn2 = New-Object System.Windows.Forms.Button
$btn2.Location = new-object System.Drawing.Size(15,200)
$btn2.Size = new-object System.Drawing.Size(220,20)
$btn2.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-ScanActivityAnalysisReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-ScanActivityAnalysisReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn2.Text = "Get-ScanActivityAnalysisReportv1.7"

$btn3 = New-Object System.Windows.Forms.Button
$btn3.Location = new-object System.Drawing.Size(15,240)
$btn3.Size = new-object System.Drawing.Size(220,20)
$btn3.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-ScanExceptionsReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-ScanExceptionsReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn3.Text = "Get-ScanExceptionsReportv1.7"

$btn5 = New-Object System.Windows.Forms.Button
$btn5.Location = new-object System.Drawing.Size(15,280)
$btn5.Size = new-object System.Drawing.Size(220,20)
$btn5.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-ScanScheduleReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-ScanScheduleReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn5.Text = "Get-ScanScheduleReportv1.7"

$btn6 = New-Object System.Windows.Forms.Button
$btn6.Location = new-object System.Drawing.Size(15,320)
$btn6.Size = new-object System.Drawing.Size(220,20)
$btn6.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-NetworkStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-NetworkStatusReportv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn6.Text = "Get-NetworkStatusReportv1.7"

$btn8 = New-Object System.Windows.Forms.Button
$btn8.Location = new-object System.Drawing.Size(15,360)
$btn8.Size = new-object System.Drawing.Size(220,20)
$btn8.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-UsersAuditLogv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-UsersAuditLogv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn8.Text = "Get-UsersAuditLogv1.7"

$btn4 = New-Object System.Windows.Forms.Button
$btn4.Location = new-object System.Drawing.Size(15,400)
$btn4.Size = new-object System.Drawing.Size(220,20)
$btn4.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-NetworkComparisonv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-NetworkComparisonv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn4.Text = "Get-NetworkComparisonv1.7"

$btn7 = New-Object System.Windows.Forms.Button
$btn7.Location = new-object System.Drawing.Size(15,440)
$btn7.Size = new-object System.Drawing.Size(220,20)
$btn7.add_click( { 
	if ($DropDown.SelectedIndex -eq '0') {
		.\Get-NetworkDuplicationv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass102 | Out-Host
	} elseif ($DropDown.SelectedIndex -eq '1') {
		.\Get-NetworkDuplicationv1.7.ps1 -vne $DropDown.SelectedItem -p $env:pass119 | Out-Host 
	}	
} )
$btn7.Text = "Get-NetworkDuplicationv1.7"

$form.controls.add($pictureBox)
$form.Controls.Add($btn)
$form.Controls.Add($btn1)
$form.Controls.Add($btn111)
$form.Controls.Add($btn2)
$form.Controls.Add($btn3)
$form.Controls.Add($btn4)
$form.Controls.Add($btn5)
$form.Controls.Add($btn6)
$form.Controls.Add($btn7)
$form.Controls.Add($btn8)
$form.Controls.Add($btn9)
$drc = $form.ShowDialog()
 