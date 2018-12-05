<#
.SYNOPSIS
Return an argument list for code.exe

.PARAMETER resourcePath
Path to the electron resource used by code.exe. See file code.cmd

.PARAMETER allArgs
Input arguments as an array of objects
#>
function GetArgs($resourcePath, [object[]]$allArgs) {

    # Array-type elements should be pulled up and flattened to allow for Get-Item inputs
    $flattenedArgs = @()

    $allArgs | %{
        if ($_ -is [Array]) {
            $_ | %{ $flattenedArgs += [string]$_}
        } else {
            $flattenedArgs += [string]$_
        }
    }

    $allArgsQuoted = $flattenedArgs | %{
        if ($_ -like '* *') {'"{0}"' -f $_ } else {$_}
    }

    # Prepend the resource path to match behavior of code.cmd
    $codeArgs = @(('"{0}"' -f $resourcePath)) + $allArgsQuoted | select -uniq

    $codeArgs
}
