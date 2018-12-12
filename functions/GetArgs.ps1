<#
.SYNOPSIS
Return an argument list for code.exe

.PARAMETER resourcePath
Path to the electron resource used by code.exe. See file code.cmd

.PARAMETER allArgs
Input arguments as an array of objects
#>
function GetArgs($resourcePath, [object[]]$allArgs) {

    # Attempt to flatten array and object type elements by resolving
    $flattenedArgs = @()

    foreach ($curArg in $allArgs) {
        $resolved = (Resolve-Path $curArg -ea si | Convert-Path)
        if ($resolved) {
            $flattenedArgs += $resolved
        }
        else {
            $flattenedArgs += [string]$curArg
        }
    }

    $allArgsQuoted = $flattenedArgs | % {
        if ($_ -like '* *') {'"{0}"' -f $_ } else {$_}
    }

    # Prepend the resource path to match behavior of code.cmd
    $codeArgs = @(('"{0}"' -f $resourcePath)) + $allArgsQuoted | select -uniq

    $codeArgs
}
