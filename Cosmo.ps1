# Load required assemblies and PowerCLI module
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.AutoSize = $true
$form.Text = "Cosmo"
$form.Size = New-Object System.Drawing.Size(800, 800)  # Fixed form size
#$form.Icon = "C:\Windows\UUS\amd64\WindowsUpdateSeeker.ico"
$form.StartPosition = 'CenterScreen'  # Center the form on the screen

# Watermark Text and Font
$watermarkText = "v0.1 - Probably Broken"
$watermarkFont = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Italic)
$watermarkColor = [System.Drawing.Color]::Gray

# Define the Paint event handler to draw the watermark
$form.Add_Paint({
    param([System.Object]$sender, [System.Windows.Forms.PaintEventArgs]$e)
    
    # Get the graphics object
    $graphics = $e.Graphics

    # Measure the watermark text size
    $textSize = $graphics.MeasureString($watermarkText, $watermarkFont)

    # Set the position to the bottom-right corner of the form
    $xPos = $form.ClientSize.Width - $textSize.Width - 10  # 10-pixel padding from the right
    $yPos = $form.ClientSize.Height - $textSize.Height - 10  # 10-pixel padding from the bottom

    # Draw the watermark text in gray color
    $graphics.DrawString($watermarkText, $watermarkFont, (New-Object System.Drawing.SolidBrush $watermarkColor), $xPos, $yPos)
})

# Create a GroupBox for ESXi Login Information
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Text = "ESXi Login Information:"
$groupBox.Size = New-Object System.Drawing.Size(450, 210)
$groupBox.Location = New-Object System.Drawing.Point(155, 20)
$form.Controls.Add($groupBox)

# Create text fields for Host IP, Username, Password, and NTP
$labelHostIP = New-Object System.Windows.Forms.Label
$labelHostIP.Text = "ESXi Host IP:"
$labelHostIP.AutoSize = $true
$labelHostIP.Top = 20
$labelHostIP.Left = 125
$groupBox.Controls.Add($labelHostIP)

$textHostIP = New-Object System.Windows.Forms.TextBox
$textHostIP.Top = 40
$textHostIP.Left = 125
$textHostIP.Width = 200
$groupBox.Controls.Add($textHostIP)

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Text = "Username:"
$labelUsername.AutoSize = $true
$labelUsername.Top = 70
$labelUsername.Left = 125
$groupBox.Controls.Add($labelUsername)

$textUsername = New-Object System.Windows.Forms.TextBox
$textUsername.Top = 90
$textUsername.Left = 125
$textUsername.Width = 200
$groupBox.Controls.Add($textUsername)

$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Text = "Password:"
$labelPassword.AutoSize = $true
$labelPassword.Top = 120
$labelPassword.Left = 125
$groupBox.Controls.Add($labelPassword)

$textPassword = New-Object System.Windows.Forms.TextBox
$textPassword.Top = 140
$textPassword.Left = 125
$textPassword.UseSystemPasswordChar = $true
$textPassword.Width = 200
$groupBox.Controls.Add($textPassword)

# Create NTP field
$labelNTP = New-Object System.Windows.Forms.Label
$labelNTP.Text = "NTP Server:"
$labelNTP.AutoSize = $true
$labelNTP.Top = $groupBox.Bottom + 20
$labelNTP.Left = 15  # Centered in the form
$form.Controls.Add($labelNTP)

$textNTP = New-Object System.Windows.Forms.TextBox
$textNTP.Top = $labelNTP.Top + 20
$textNTP.Width = 200
$textNTP.Location = New-Object System.Drawing.Point(15, $textNTP.Top)  # Centered in the form
$form.Controls.Add($textNTP)

# Create Syslog field
$labelSyslogIP = New-Object System.Windows.Forms.Label
$labelSyslogIP.Text = "Syslog Server (e.g. udp://10.0.0.1:514):"
$labelSyslogIP.AutoSize = $true
$labelSyslogIP.Top = $groupBox.Bottom + 20
$labelSyslogIP.Left = 250 # Centered in the form
$form.Controls.Add($labelSyslogIP)

$textSyslogIP = New-Object System.Windows.Forms.TextBox
$textSyslogIP.Top = $labelSyslogIP.Top + 20
$textSyslogIP.Width = 200
$textSyslogIP.Location = New-Object System.Drawing.Point(250, $textSyslogIP.Top)  # Centered in the form
$form.Controls.Add($textSyslogIP)


# Create a ComboBox for presets
$dropdown = New-Object System.Windows.Forms.ComboBox
$dropdown.Text = "Select Profile"
$dropdown.Top = $textNTP.Bottom + 20
$dropdown.Width = 200
$dropdown.Location = New-Object System.Drawing.Point(250, $dropdown.Top)  # Centered in the form
$dropdown.Items.AddRange(@("CIS L1", "CIS L2"))
$form.Controls.Add($dropdown)

$checkboxes = @{}
$checkboxLabels = @(
    "Disable SSH",
    "VIB Acceptance Level",
    "Enable Lockdown Mode",
    "Disable Unused Services", 
    "Set Default value of salt per VM",
    "Disable MOB",
    "Disable SNMP",
    "Disable VDS Health Check",
    "Enable Password Complexity",
    "5 Login Attempt Limit",
    "15 Minute Lockout",
    "Prohibit Past Passwords",
    "DCUI 10 Minute Timeout",
    "Disable ESXi Shell",
    "Shell 3 Min Timeout",
    "Shell Service 1 Hour Timeout",
    "Add Root to DCUI",
    "Reject Forged Transmits (vSwitch)",
    "Reject MAC Address Change (vSwitch)",
    "Reject Promiscuous (vSwitch)",
    "One Remote Console (VM)",
    "Disconnect Floppy (VM)",
    "Disconnect CD/DVD (VM)",
    "Disconnect USB Devs (VM)",
    "Authorised Disconnection Only (VM)",
    "Authorised Connection Only (VM)",
    "Disable PCI Passthrough (VM)",
    "Disable Autologin (VM)",
    "Disable BIOS BBS (VM)",
    "Disable Guest Host Interaction (VM)",
    "Disable Unity Taskbar (VM)",
    "Disable Unity Active (VM)" ,
    "Disable Unity Windows Contents (VM)",
    "Disable Unity Push updates (VM)",
    "Disable Disk Topology (VM)",
    "Disable Drag and Drop (VM)",
    "Disable Shell Action (VM)",
    "Disable Trash Folder State (VM)",
    "Disable GHI Tray Icon (VM)",
    "Disable Unity (VM)",
    "Disable Unity Interlock (VM)",
    "Disable GetCreds (VM)",
    "Disable Host Guest File System (VM)",
    "Disable GHI Launch Menu (VM)",
    "Disable memSchedFakeSampleStats (VM)",
    "Disable Clipboard into console (VM)",
    "Disable Console Drag and Drop (VM)",
    "Disable VM Console GUI (VM)",
    "Disable Paste Clipboard into console (VM)", 
    "Disable Hardware 3D Acceleration (VM)",
    "Disable Disk Shrinking (VM)",
    "Disable Disk Wiping (VM)",
    "Keep Old Logs (VM)",
    "Do not send host info to guest (VM)",
    "Set and limit Log Filesize (VM)"
)

# Initialize positions
$checkboxTop = $dropdown.Bottom + 20
$maxPerColumn = 20
$checkboxWidth = 200  # Width of each checkbox
$checkboxSpacing = 15 # Vertical spacing between checkboxes
$columnOffset = 25     # Horizontal spacing between columns

$columnIndex = 0  # Track the current column

foreach ($label in $checkboxLabels) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $label
    $checkbox.AutoSize = $true

    # Calculate the position
    $checkbox.Top = $checkboxTop + ($checkboxSpacing * ($checkboxes.Count % $maxPerColumn))
    $checkbox.Left = 10 + ($columnIndex * ($checkboxWidth + $columnOffset))  # Increment left position for new column

    $form.Controls.Add($checkbox)
    $checkboxes[$label] = $checkbox

    # Move to the next column after reaching maxPerColumn
    if (($checkboxes.Count % $maxPerColumn) -eq ($maxPerColumn - 1)) {
        $columnIndex++  # Increment column index for the next checkbox
    }
}

# Create a panel to hold action buttons
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Size = New-Object System.Drawing.Size(450, 50)
$buttonPanel.Location = New-Object System.Drawing.Point(05, 700)  # Fixed position from the top
$form.Controls.Add($buttonPanel)

# Create a output panel to hold action buttons
$outputButtonPanel = New-Object System.Windows.Forms.Panel
$outputButtonPanel.Size = New-Object System.Drawing.Size(450, 50)
$OutputButtonPanel.Location = New-Object System.Drawing.Point(05, 750)  # Fixed position from the top
$form.Controls.Add($OutputButtonPanel)

# Create a button to connect to the host
$connectButton = New-Object System.Windows.Forms.Button
$connectButton.Text = "Connect to ESXi"
$connectButton.Width = 100
$connectButton.AutoSize = $true
$connectButton.Top = 172
$connectButton.Left = 172
#$connectButton.Location = New-Object System.Drawing.Point(50, 10)  # Centered in the panel
$connectButton.Add_Click({
    # Gather credentials
    $hostIP = $textHostIP.Text
    $username = $textUsername.Text
    $password = $textPassword.Text

    # Connect to ESXi host using PowerCLI
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

    try {
        Connect-VIServer -Server $hostIP -Credential $credential -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Connected to ESXi host successfully.")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error connecting to ESXi host: $_")
    }
})
$groupBox.Controls.Add($connectButton)

# Create an action button to apply settings
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Text = "Apply Hardening"
$applyButton.Width = 100
$applyButton.Location = New-Object System.Drawing.Point(200, 10)  # Centered in the panel
$applyButton.Add_Click({
    try {
        # Apply NTP settings if provided
        $ntpServer = $textNTP.Text
        if (-not [string]::IsNullOrWhiteSpace($ntpServer)) {
            Write-Host "Setting NTP Server to $ntpServer."
            Get-VMHost $textHostIP.Text | Add-VMHostNTPServer -NtpServer $ntpServer -Confirm:$false
        }

        # Apply Syslog settings if provided
        $syslogServer = $textSyslogIP.Text
        if (-not [string]::IsNullOrWhiteSpace($syslogServer)) {
            Write-Host "Setting Syslog Server to $syslogServer."
            Get-VMHost | Get-AdvancedSetting -Name Syslog.global.logHost | Set-AdvancedSetting -Value $syslogServer -Confirm:$false
        }

        # Apply selected hardening settings
        foreach ($label in $checkboxes.Keys) {
            if ($checkboxes[$label].Checked) {
                Write-Host "$label is selected for application."
                # Replace with actual commands to harden ESXi
                switch ($label) {
                    "Disable SSH" {
                        #5.3(L1) Ensure SSH is disabled
                        Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM-SSH" } | Set-VMHostService -Policy Off -Confirm:$false

                    }
                    "VIB Acceptance Level" {
                        Foreach ($VMHost in Get-VMHost ) {
                            $ESXCli = Get-EsxCli -VMHost $textHostIP.Text
                            $ESXCli.software.acceptance.Set("PartnerSupported")
                           } 
                    }
                    "Enable Lockdown Mode" {
                        #5.5(L1) Ensure Normal Lockdown mode is enabled
                        (Get-VMHost | Get-View).EnterLockdownMode()
                    }
                    "Set Default value of salt per VM" {
                        #1.4(L2) Ensure the default alue of individual salt per vm is configured
                        Get-VMHost | Get-AdvancedSetting -Name Mem.ShareForceSalting | Set-AdvancedSetting -Value 2 -Confirm:$false
                    }
                    "Disable Unused Services" {
                        Get-VMHost | Get-VMHostService | Where-Object { $_.Key -notin @("SSH", "vpxa") } | Stop-VMHostService -Confirm:$false
                    }
                    "Disable MOB" {
                        #2.3(L1) Ensure Managed Object Browser (MOB) is disabled 
                        Get-VMHost | Get-AdvancedSetting -Name Config.HostAgent.plugins.solo.enableMob | Set-AdvancedSetting -value "false" -Confirm:$false
                    }
                    "Disable SNMP" {
                        #2.5(L1) Ensure SNMP is configured properly
                        Get-VmHostSNMP | Set-VMHostSNMP -Enabled:$false -Confirm:$false
                    }
                    "Disable VDS Health Check" {
                    #2.9(L2) Ensure VDS Health check is disabled
                    Get-View -ViewType DistributedVirtualSwitch | ?{($_.config.HealthCheckConfig | ?{$_.enable -notmatch "False"})}| %{$_.UpdateDVSHealthCheckConfig(@((New-Object Vmware.Vim.VMwareDVSVlanMtuHealthCheckConfig -property @{enable=0}),(New-Object Vmware.Vim.VMwareDVSTeamingHealthCheckConfig -property @{enable=0})))}
                    }
                    "Enable Password Complexity" {
                        #4.2(L1) Ensure passwords are required to be complex
                        Get-VMHost | Get-AdvancedSetting -Name Security.PasswordQualityControl | Set-AdvancedSetting -Value "retry=3 min=disabled,disabled,disabled,disabled,14" -Confirm:$false
                    }
                    "5 Login Attempt Limit" {
                        #4.3(L1) Ensure the maximum failed login attempts is set to 5
                        Get-VMHost | Get-AdvancedSetting -Name Security.AccountLockFailures | Set-AdvancedSetting -Value 5 -Confirm:$false
                    }
                    "15 Minute Lockout" {
                        #4.4(L1) Ensure account lockout is set to 15 minutes
                        Get-VMHost | Get-AdvancedSetting -Name Security.AccountUnlockTime | Set-AdvancedSetting -Value 900 -Confirm:$false
                    }
                    "Prohibit Past Passwords" {
                        # 4.5(L1) Ensure previous 5 passwords are prohibited 
                        Get-VMHost | Get-AdvancedSetting Security.PasswordHistory | Set-AdvancedSetting -Value 5 -Confirm:$false
                    }
                    "DCUI 10 Minute Timeout" {
                        #5.1(L1) Ensure the DCUI timeout is set to 600 seconds or less
                        Get-VMHost | Get-AdvancedSetting -Name UserVars.DcuiTimeOut | Set-AdvancedSetting -Value 600 -Confirm:$false
                    }
                    "Disable ESXi Shell" {
                        #5.2(L1) Ensure the ESXi Shell is disabled
                        Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM" } | Set-VMHostService -Policy Off -Confirm:$false
                    }
                    "Shell 3 Min Timeout" {
                        #5.8(L1) Ensure idle ESXi shell and SSH sessions time out after 300 seconds or less
                        Get-VMHost | Get-AdvancedSetting -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value "300" -Confirm:$false
                    }
                    "Shell Service 1 Hour Timeout" {
                        #5.9(L1) Ensure the shell services timeout is set to 1 hour or less
                        Get-VMHost | Get-AdvancedSetting -Name 'UserVars.ESXiShellTimeOut' | Set-AdvancedSetting -Value "3600" -Confirm:$false
                    }
                    "Add Root to DCUI" {
                        #5.10(L1) Ensure DCUI has a trusted users list for lockdown mode
                        Get-VMHost | Get-AdvancedSetting -Name 'DCUI.Access' | Set-AdvancedSetting -Value "root" -Confirm:$false
                    }
                    "Reject Forged Transmits (vSwitch)" {
                        #7.1(L1) Ensure the vSwitch Forged Transmits policy is set to reject
                        Get-VirtualSwitch | Get-SecurityPolicy | Set-SecurityPolicy -ForgedTransmits $false -Confirm:$false
                        Get-VirtualPortGroup | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuousInherited $true -Confirm:$false
                    }
                    "Reject MAC Address Change (vSwitch)" {
                        #7.2(L1) Ensure the vSwitch MAC Address Change policy is set to reject
                        Get-VirtualSwitch | Get-SecurityPolicy | Set-SecurityPolicy -MacChanges $false -Confirm:$false
                        Get-VirtualPortGroup | Get-SecurityPolicy | Set-SecurityPolicy -MacChangesInherited $true -Confirm:$false
                    }
                    "Reject Promiscuous (vSwitch)" {
                        #7.3(L1) Ensure the vSwitch Promiscuous Mode policy is set to reject
                        Get-VirtualSwitch | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $false -Confirm:$false
                        Get-VirtualPortGroup | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuousInherited $true -Confirm:$false
                    }
                    "One Remote Console (VM)" {
                        #8.1.1(L2) Ensure only one remote console connection is permitted to a VM at any time 
                        Get-VM | New-AdvancedSetting -Name "RemoteDisplay.maxConnections" -value 1 -Force -Confirm:$false
                    }
                    "Disconnect Floppy (VM)" {
                        # 8.2.1(L1) Ensure unnecessary floppy devices are disconnected
                        Get-VM | Get-FloppyDrive | Remove-FloppyDrive -Confirm:$false
                    }
                    "Disconnect CD/DVD (VM)" {
                        # 8.2.2(L2) Ensure unnecessary CD/DVD devices are disconnected
                        Get-VM | Get-CDDrive | Remove-CDDrive -Confirm:$false
                    }
                    "Disconnect USB Devs (VM)" {
                        # 8.2.5 (L1) Ensure unnecessary USB devices are disconnected
                        Get-VM | Get-USBDevice | Remove-USBDevice -Confirm:$false
                    }
                    "Authorised Disconnection Only (VM)" {
                        # 8.2.6 (L1) Ensure unauthorized modification and disconnection of devices is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.device.edit.disable" -value $true -Force -Confirm:$false
                    }
                    "Authorised Connection Only (VM)" {
                        # 8.2.7 (L1) Ensure unauthorized connection of devices is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.device.connectable.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable PCI Passthrough (VM)" {
                        # 8.2.8 (L1) Ensure PCI and PCIe device passthrough is disabled
                        Get-VM | New-AdvancedSetting -Name "pciPassthru*.present" -value "" -Force -Confirm:$false
                    }
                    "Disable Autologin (VM)" {
                        # 8.4.2 (L2) Ensure Autologon is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.ghi.autologon.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable BIOS BBS (VM)" {
                        # 8.4.3 (L2) Ensure BIOS BBS is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.bios.bbs.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Guest Host Interaction (VM)" {
                        # 8.4.4 (L2) Ensure Guest Host Interaction Protocol Handler is set to disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.ghi.protocolhandler.info.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Unity Taskbar (VM)" {
                        # 8.4.5 (L2) Ensure Unity Taskbar is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unity.taskbar.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Unity Active (VM)" {
                        # 8.4.6 (L2) Ensure Unity Active is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unityActive.disable" -value $True -Force -Confirm:$false
                    }
                    "Disable Unity Windows Contents (VM)" {
                        # 8.4.7 (L2) Ensure Unity Window Contents is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unity.windowContents.disable" -value $True -Force -Confirm:$false
                    }
                    "Disable Unity Push updates (VM)" {
                        # 8.4.8 (L2) Ensure Unity Push Update is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unity.push.update.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Drag and Drop (VM)" {
                        # 8.4.9 (L2) Ensure Drag and Drop Version Get is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.vmxDnDVersionGet.disable" -value $true -Force -Confirm:$false
                        # 8.4.10 (L2) Ensure Drag and Drop Version Set is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.guestDnDVersionSet.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Shell Action (VM)" {
                        # 8.4.11 (L2) Ensure Shell Action is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.ghi.host.shellAction.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Disk Topology (VM)" {
                        # 8.4.12 (L2) Ensure Request Disk Topology is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.dispTopoRequest.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Trash Folder State (VM)" {
                        # 8.4.13 (L2) Ensure Trash Folder State is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.trashFolderState.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable GHI Tray Icon (VM)" {
                        # 8.4.14 (L2) Ensure Guest Host Interaction Tray Icon is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.ghi.trayicon.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Unity (VM)" {
                        # 8.4.15 (L2) Ensure Unity is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unity.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Unity Interlock (VM)" {
                        # 8.4.16 (L2) Ensure Unity Interlock is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.unityInterlockOperation.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable GetCreds (VM)" {
                        # 8.4.17 (L2) Ensure GetCreds is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.getCreds.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Host Guest File System (VM)" {
                        # 8.4.18 (L2) Ensure Host Guest File System Server is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.hgfsServerSet.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable GHI Launch Menu (VM)" {
                        # 8.4.19 (L2) Ensure Guest Host Interaction Launch Menu is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.ghi.launchmenu.change" -value $true -Force -Confirm:$false
                    }
                    "Disable memSchedFakeSampleStats (VM)" {
                        # 8.4.20 (L2) Ensure memSchedFakeSampleStats is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.memSchedFakeSampleStats.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Clipboard into console (VM)" {
                        # 8.4.21 (L1) Ensure VM Console Copy operations are disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.copy.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Console Drag and Drop (VM)" {
                        # 8.4.22 (L1) Ensure VM Console Drag and Drop operations is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.dnd.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable VM Console GUI (VM)" {
                        # 8.4.23 (L1) Ensure VM Console GUI Options is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.setGUIOptions.enable" -value $false -Force -Confirm:$false
                    }
                    "Disable Paste Clipboard into console (VM)" {
                        # 8.4.24 (L1) Ensure VM Console Paste operations are disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.paste.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Hardware 3D Acceleration (VM)" {
                        # 8.5.2 (L2) Ensure hardware-based 3D acceleration is disabled
                        Get-VM | New-AdvancedSetting -Name "mks.enable3d" -value $false -Force -Confirm:$false
                    }
                    "Disable Disk Shrinking (VM)" {
                        # 8.6.2 (L1) Ensure virtual disk shrinking is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.diskShrink.disable" -value $true -Force -Confirm:$false
                    }
                    "Disable Disk Wiping (VM)" {
                        # 8.6.3 (L1) Ensure virtual disk wiping is disabled
                        Get-VM | New-AdvancedSetting -Name "isolation.tools.diskWiper.disable" -value $true -Force -Confirm:$false
                    }
                    "Keep Old Logs (VM)" {
                        # 8.7.1 (L1) Ensure the number of VM log files is configured properly
                        Get-VM | New-AdvancedSetting -Name "log.keepOld" -value "10" -Force -Confirm:$false
                    }
                    "Do not send host info to guest (VM)" {
                        # 8.7.2 (L2) Ensure host information is not sent to guests
                        Get-VM | New-AdvancedSetting -Name "tools.guestlib.enableHostInfo" -value $false -Force -Confirm:$false
                    }
                    "Set and limit Log Filesize (VM)" {
                        # 8.7.3 (L1) Ensure VM log file size is limited
                        Get-VM | New-AdvancedSetting -Name "log.rotateSize" -value "1024000" -Force -Confirm:$false
                    }
                }
            }
        }
        [System.Windows.Forms.MessageBox]::Show("Hardening settings applied successfully.")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error applying hardening settings: $_")
    }
})
$buttonPanel.Controls.Add($applyButton)

# Create a button to clear selections
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Clear Selections"
$clearButton.Width = 100
$clearButton.Location = New-Object System.Drawing.Point(350, 10)  # Centered in the panel
$clearButton.Add_Click({
    # Clear all checkboxes and NTP field
    foreach ($checkbox in $checkboxes.Values) {
        $checkbox.Checked = $false
    }
    $textNTP.Clear()
    [System.Windows.Forms.MessageBox]::Show("All selections cleared.")
})
$buttonPanel.Controls.Add($clearButton)

# Event to handle dropdown selection changes
$dropdown.Add_SelectedIndexChanged({
    switch ($dropdown.SelectedItem) {
        "CIS L1" {
            $checkboxes["Disable SSH"].Checked = $true
            $checkboxes["VIB Acceptance Level"].Checked = $true
            $checkboxes["Enable Lockdown Mode"].Checked = $false
            $checkboxes["Disable Unused Services"].Checked = $true 
            $checkboxes["Set Default value of salt per VM"].Checked = $false
            $checkboxes["Disable MOB"].Checked = $true
            $checkboxes["Disable SNMP"].Checked = $false
            $checkboxes["Disable VDS Health Check"].Checked = $false
            $checkboxes["Enable Password Complexity"].Checked = $true
            $checkboxes["5 Login Attempt Limit"].Checked = $true
            $checkboxes["15 Minute Lockout"].Checked = $true
            $checkboxes["Prohibit Past Passwords"].Checked = $true
            $checkboxes["DCUI 10 Minute Timeout"].Checked = $true
            $checkboxes["Disable ESXi Shell"].Checked = $true
            $checkboxes["Shell 3 Min Timeout"].Checked = $true
            $checkboxes["Shell Service 1 Hour Timeout"].Checked = $true
            $checkboxes["Add Root to DCUI"].Checked = $true
            $checkboxes["Reject Forged Transmits (vSwitch)"].Checked = $true
            $checkboxes["Reject MAC Address Change (vSwitch)"].Checked = $true
            $checkboxes["Reject Promiscuous (vSwitch)"].Checked = $true
            $checkboxes["One Remote Console (VM)"].Checked = $false
            $checkboxes["Disconnect Floppy (VM)"].Checked = $true
            $checkboxes["Disconnect CD/DVD (VM)"].Checked = $false
            $checkboxes["Disconnect USB Devs (VM)"].Checked = $true
            $checkboxes["Authorised Disconnection Only (VM)"].Checked = $true
            $checkboxes["Authorised Connection Only (VM)"].Checked = $true
            $checkboxes["Disable PCI Passthrough (VM)"].Checked = $true
            $checkboxes["Disable Autologin (VM)"].Checked = $false
            $checkboxes["Disable BIOS BBS (VM)"].Checked = $false
            $checkboxes["Disable Guest Host Interaction (VM)"].Checked = $false
            $checkboxes["Disable Unity Taskbar (VM)"].Checked = $false
            $checkboxes["Disable Unity Active (VM)" ].Checked = $false
            $checkboxes["Disable Unity Windows Contents (VM)"].Checked = $false
            $checkboxes["Disable Unity Push updates (VM)"].Checked = $false
            $checkboxes["Disable Disk Topology (VM)"].Checked = $false
            $checkboxes["Disable Drag and Drop (VM)"].Checked = $false
            $checkboxes["Disable Shell Action (VM)"].Checked = $false
            $checkboxes["Disable Trash Folder State (VM)"].Checked = $false
            $checkboxes["Disable GHI Tray Icon (VM)"].Checked = $false
            $checkboxes["Disable Unity (VM)"].Checked = $false
            $checkboxes["Disable Unity Interlock (VM)"].Checked = $false
            $checkboxes["Disable GetCreds (VM)"].Checked = $false
            $checkboxes["Disable Host Guest File System (VM)"].Checked = $false
            $checkboxes["Disable GHI Launch Menu (VM)"].Checked = $false
            $checkboxes["Disable memSchedFakeSampleStats (VM)"].Checked = $false
            $checkboxes["Disable Clipboard into console (VM)"].Checked = $true
            $checkboxes["Disable Console Drag and Drop (VM)"].Checked = $true
            $checkboxes["Disable VM Console GUI (VM)"].Checked = $true
            $checkboxes["Disable Paste Clipboard into console (VM)"].Checked = $true
            $checkboxes["Disable Hardware 3D Acceleration (VM)"].Checked = $false
            $checkboxes["Disable Disk Shrinking (VM)"].Checked = $true
            $checkboxes["Disable Disk Wiping (VM)"].Checked = $true
            $checkboxes["Keep Old Logs (VM)"].Checked = $true
            $checkboxes["Do not send host info to guest (VM)"].Checked = $false
            $checkboxes["Set and limit Log Filesize (VM)"].Checked = $true
        }
        "CIS L2" {
            $checkboxes["Disable SSH"].Checked = $true
            $checkboxes["VIB Acceptance Level"].Checked = $true
            $checkboxes["Enable Lockdown Mode"].Checked = $false
            $checkboxes["Disable Unused Services"].Checked = $true 
            $checkboxes["Set Default value of salt per VM"].Checked = $true
            $checkboxes["Disable MOB"].Checked = $true
            $checkboxes["Disable SNMP"].Checked = $true
            $checkboxes["Disable VDS Health Check"].Checked = $true
            $checkboxes["Enable Password Complexity"].Checked = $true
            $checkboxes["5 Login Attempt Limit"].Checked = $true
            $checkboxes["15 Minute Lockout"].Checked = $true
            $checkboxes["Prohibit Past Passwords"].Checked = $true
            $checkboxes["DCUI 10 Minute Timeout"].Checked = $true
            $checkboxes["Disable ESXi Shell"].Checked = $true
            $checkboxes["Shell 3 Min Timeout"].Checked = $true
            $checkboxes["Shell Service 1 Hour Timeout"].Checked = $true
            $checkboxes["Add Root to DCUI"].Checked = $true
            $checkboxes["Reject Forged Transmits (vSwitch)"].Checked = $true
            $checkboxes["Reject MAC Address Change (vSwitch)"].Checked = $true
            $checkboxes["Reject Promiscuous (vSwitch)"].Checked = $true
            $checkboxes["One Remote Console (VM)"].Checked = $true
            $checkboxes["Disconnect Floppy (VM)"].Checked = $true
            $checkboxes["Disconnect CD/DVD (VM)"].Checked = $true
            $checkboxes["Disconnect USB Devs (VM)"].Checked = $true
            $checkboxes["Authorised Disconnection Only (VM)"].Checked = $true
            $checkboxes["Authorised Connection Only (VM)"].Checked = $true
            $checkboxes["Disable PCI Passthrough (VM)"].Checked = $true
            $checkboxes["Disable Autologin (VM)"].Checked = $true
            $checkboxes["Disable BIOS BBS (VM)"].Checked = $true
            $checkboxes["Disable Guest Host Interaction (VM)"].Checked = $true
            $checkboxes["Disable Unity Taskbar (VM)"].Checked = $true
            $checkboxes["Disable Unity Active (VM)" ].Checked = $true
            $checkboxes["Disable Unity Windows Contents (VM)"].Checked = $true
            $checkboxes["Disable Unity Push updates (VM)"].Checked = $true
            $checkboxes["Disable Disk Topology (VM)"].Checked = $true
            $checkboxes["Disable Drag and Drop (VM)"].Checked = $true
            $checkboxes["Disable Shell Action (VM)"].Checked = $true
            $checkboxes["Disable Trash Folder State (VM)"].Checked = $true
            $checkboxes["Disable GHI Tray Icon (VM)"].Checked = $true
            $checkboxes["Disable Unity (VM)"].Checked = $true
            $checkboxes["Disable Unity Interlock (VM)"].Checked = $true
            $checkboxes["Disable GetCreds (VM)"].Checked = $true
            $checkboxes["Disable Host Guest File System (VM)"].Checked = $true
            $checkboxes["Disable GHI Launch Menu (VM)"].Checked = $true
            $checkboxes["Disable memSchedFakeSampleStats (VM)"].Checked = $true
            $checkboxes["Disable Clipboard into console (VM)"].Checked = $true
            $checkboxes["Disable Console Drag and Drop (VM)"].Checked = $true
            $checkboxes["Disable VM Console GUI (VM)"].Checked = $true
            $checkboxes["Disable Paste Clipboard into console (VM)"].Checked = $true
            $checkboxes["Disable Hardware 3D Acceleration (VM)"].Checked = $true
            $checkboxes["Disable Disk Shrinking (VM)"].Checked = $true
            $checkboxes["Disable Disk Wiping (VM)"].Checked = $true
            $checkboxes["Keep Old Logs (VM)"].Checked = $true
            $checkboxes["Do not send host info to guest (VM)"].Checked = $true
            $checkboxes["Set and limit Log Filesize (VM)"].Checked = $true
        }
        default {
            # Clear checkboxes if "Select Profile" is chosen
            foreach ($checkbox in $checkboxes.Values) {
                $checkbox.Checked = $false
            }
        }
    }
})


#########################################
#                                       #
#          Excel Output Section         #
#                                       #
#########################################
# Create an action button to apply settings
$dumpButton = New-Object System.Windows.Forms.Button
$dumpButton.Text = "Dump Adv Settings"
$dumpButton.Width = 125
$dumpButton.Location = New-Object System.Drawing.Point(20, 10)  # Centered in the panel
$dumpButton.Add_Click({
    try {
        $OutputButtonPanel.Controls.Add($dumpButton)
        # Define the output CSV path
        $timeOutput = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $outputPath = "C:\ESXi_Log_Archive\ESXi_Advanced_Settings-$timeOutput.csv"  # Change path as needed
        
        #create folder if not already there
        $outputfoldercheck = "C:\ESXi_Log_Archive"
        if (-not(Test-Path $outputFolderCheck -PathType Container)) {
            New-Item -path $outputFolderCheck -ItemType Directory
        }

        # Create a list to store the advanced settings
        $settingsList = @()

        # Retrieve advanced settings for the ESXi host
        $hostSettings = Get-AdvancedSetting -Entity $textHostIP.Text
        foreach ($setting in $hostSettings) {
            $settingsList += [PSCustomObject]@{
                Entity      = "ESXi Host"
                Name        = $setting.Name
                Value       = $setting.Value
                Description = $setting.Description
            }
        }

        # Retrieve all virtual machines on the ESXi host
        $vms = Get-VM -Location $textHostIP.Text
        foreach ($vm in $vms) {
            # Retrieve advanced settings for each virtual machine
            $vmSettings = Get-AdvancedSetting -Entity $vm
            foreach ($setting in $vmSettings) {
                $settingsList += [PSCustomObject]@{
                    Entity      = $vm.Name
                    Name        = $setting.Name
                    Value       = $setting.Value
                    Description = $setting.Description
                }
            }
        }

        # Export the settings to CSV
        $settingsList | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8
        
        # Disconnect from the ESXi host
        #Disconnect-VIServer -Server $esxiHost -Confirm:$false
        
        [System.Windows.Forms.MessageBox]::Show("Advanced settings exported to $outputPath")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error dumping advanced settings: $_")
    }
})

$OutputButtonPanel.Controls.Add($dumpButton)

# Create the Exit button
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Exit"
$exitButton.Size = New-Object System.Drawing.Size(80, 30)
$exitButton.Location = New-Object System.Drawing.Point(10, 900)  # Adjust position based on your form size

# event handler for when the Exit button is clicked
$exitButton.Add_Click({
    try {
        # Disconnect from the ESXi host
        Disconnect-VIServer -Confirm:$false
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error disconnecting: $_")
    }
    # Close the form
    $form.Close()
})
# Add the Exit button to the form
$form.Controls.Add($exitButton)

# Show the form
[void]$form.ShowDialog()
