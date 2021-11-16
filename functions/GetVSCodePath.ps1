<#
.SYNOPSIS
Obtains VS Code's install path via 32 and 64 bit hives.
#>
function GetVSCodePath() {
    $result = $null
    $registryViews = @([Microsoft.Win32.RegistryView]::Registry32, [Microsoft.Win32.RegistryView]::Registry64)

    foreach ($view in $registryViews) {
        $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)
        $subKey = $key.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")

        $subKeyName = $subKey.GetSubKeyNames() | ?{
            $subKey.OpenSubKey($_).GetValue("DisplayName") -eq 'Microsoft Visual Studio Code'
        } | Select -First 1

        if ($subKeyName) {
            $result = $subKey.OpenSubKey($subKeyName).GetValue("InstallLocation")
        }
    }
    if ($null -eq $result) {
      $userPath =  (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code")
      if (Test-Path $userPath ){
        $result = $userPath
      }
    }
    $result
}
