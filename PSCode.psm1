param([parameter(Position=0, Mandatory = $false)][string]$vscodePath = $null)

$script:moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path
$script:vscodePath = if ($vscodePath) {$vscodePath} else {join-path ${env:ProgramFiles(x86)} 'Microsoft VS Code'}

# Dot source functions
"$script:moduleRoot\functions\*.ps1" | Resolve-Path | %{. $_.ProviderPath}

set-alias code Invoke-VSCode

# Only functions with a dash are public
Export-ModuleMember -function *-* -Alias *
