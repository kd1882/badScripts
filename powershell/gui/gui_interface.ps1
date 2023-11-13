Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Simple GUI'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Enter something:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,70)
$button.Size = New-Object System.Drawing.Size(100,20)
$button.Text = 'Click me'
$button.Add_Click({
    $msg = $textBox.Text
    [System.Windows.Forms.MessageBox]::Show("You entered: $msg")
})
$form.Controls.Add($button)

$form.ShowDialog()