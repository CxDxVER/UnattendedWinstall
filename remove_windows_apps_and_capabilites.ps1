# Define Windows Apps to Remove
$appList = @(
    'Microsoft.Microsoft3DViewer',
    'Microsoft.BingSearch',
    'Microsoft.WindowsCamera',
    'Clipchamp.Clipchamp',
    'Microsoft.WindowsAlarms',
    'Microsoft.549981C3F5F10',
    'Microsoft.Windows.DevHome',
    'MicrosoftCorporationII.MicrosoftFamily',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.GetHelp',
    'microsoft.windowscommunicationsapps',
    'Microsoft.WindowsMaps',
    'Microsoft.MixedReality.Portal',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.Office.OneNote',
    'Microsoft.Paint',
    'Microsoft.People',
    'Microsoft.PowerAutomateDesktop',
    'MicrosoftCorporationII.QuickAssist',
    'Microsoft.SkypeApp',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'MicrosoftTeams',
    'MSTeams',
    'Microsoft.Getstarted',
    'Microsoft.Todos',
    'Microsoft.Wallet',
    'Microsoft.OneDrive',
    'Microsoft.WindowsMeetNow'
)

# Define Windows Capabilities to Remove
$capabilities = @(
    'Language.Handwriting',
    'Browser.InternetExplorer',
    'MathRecognizer',
    'OneCoreUAP.OneSync',
    'Microsoft.Windows.MSPaint',
    'App.Support.QuickAssist',
    'Language.Speech',
    'Language.TextToSpeech',
    'App.StepsRecorder',
    'Media.WindowsMediaPlayer',
    'Microsoft.Windows.WordPad'
)

# Remove Windows Apps
Write-Host "Removing Windows Apps..."
foreach ($app in $appList) {
    Get-AppxPackage -Name $app | Remove-AppxPackage
    Write-Host "Removed app: $app"
}

# Remove Windows Capabilities
Write-Host "Removing Windows Capabilities..."
foreach ($capability in $capabilities) {
    Write-Host "Removing capability: $capability"
    Remove-WindowsCapability -Online -Name $capability
}

# Function to Remove OneDrive during Windows Setup
function Remove-OneDrive {
    Write-Host "Removing OneDrive..."
    Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction SilentlyContinue
    Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.exe" -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\System32\OneDriveSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\SysWOW64\OneDriveSetup.exe" -ErrorAction SilentlyContinue
}

# Function to Uninstall OneDrive in Existing Windows Installation
function Uninstall-OneDrive {
    Write-Host "Uninstalling OneDrive..."
    
    # Stop OneDrive process if running
    Stop-Process -Force -Name OneDrive -ErrorAction SilentlyContinue | Out-Null
    
    # Uninstall OneDrive for Windows 10
    cmd /c "C:\Windows\SysWOW64\OneDriveSetup.exe -uninstall >nul 2>&1"
    
    # Clean up OneDrive scheduled tasks
    Get-ScheduledTask | Where-Object { $_.Taskname -match 'OneDrive' } | Unregister-ScheduledTask -Confirm:$false
    
    # Uninstall OneDrive for Windows 11
    cmd /c "C:\Windows\System32\OneDriveSetup.exe -uninstall >nul 2>&1"
}

# Call the Remove-OneDrive function during Windows setup (if needed)
Remove-OneDrive

# Call the Uninstall-OneDrive function for existing Windows installations
Uninstall-OneDrive
