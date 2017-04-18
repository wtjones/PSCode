param()

$script:moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path

# Dot source functions
"$script:moduleRoot\functions\*.ps1" | Resolve-Path | %{. $_.ProviderPath}

set-alias code Invoke-VSCode

# Only functions with a dash are public
Export-ModuleMember -function *-* -Alias *
