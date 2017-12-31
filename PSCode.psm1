param([parameter(Position=0, Mandatory = $false)][string]$vscodePath = $null)

$script:moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path

# Dot source functions
"$script:moduleRoot\functions\*.ps1" | Resolve-Path | %{. $_.ProviderPath}

$script:vscodePath = if ($vscodePath) {$vscodePath} else {GetVsCodePath}

if (!$script:vscodePath) {
    Write-Error "VS Code's path was not able to be determined. If this is a portable install, please use -ArgumentList to pass the path."
}

set-alias code Invoke-VSCode

# Only functions with a dash are public
Export-ModuleMember -function *-* -Alias *
