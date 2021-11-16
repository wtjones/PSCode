<#
    Match behavior of code.cmd
#>
function Invoke-VSCode() {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true)]
        [object]$inputObject,
        [Parameter(
            Mandatory=$false,
            Position=0,
            ValueFromRemainingArguments=$true)]
        [object[]]$allArgs=@()
    )
    BEGIN {
        $inputObjects = @()

        $codePath = join-path $script:vscodePath 'code.exe'
        $resourcePath = join-path $script:vscodePath 'resources\app\out\cli.js'
        $allArgs = $allArgs + "--ms-enable-electron-run-as-node"
        $codeArgs = GetArgs $resourcePath $allArgs
        Write-Verbose ("Launching VSCode with args:`n{0}" -f ($codeArgs | convertTo-json))
    }
    PROCESS {
        if ($inputObject) {
            $inputObjects += $inputObject
        }
    }
    END {
        $prior1 = $env:ELECTRON_RUN_AS_NODE
        $prior2 = $env:VSCODE_DEV
        $env:ELECTRON_RUN_AS_NODE=1
        $env:VSCODE_DEV = $null

        if ($inputObject) {
            $pipeTempPath = (join-path $env:TEMP ("pscode-stdin-{0}.txt" -f [System.GUID]::NewGuid().ToString()))
            Write-Verbose "Writing out piped input to file $pipeTempPath"
            $inputObjects | out-file $pipeTempPath -Encoding ascii
            Start-Process -FilePath $codePath -ArgumentList $codeArgs -RedirectStandardInput $pipeTempPath
        } else {
            Start-Process -FilePath $codePath -ArgumentList $codeArgs
        }

        $env:ELECTRON_RUN_AS_NODE = $prior1
        $env:VSCODE_DEV = $prior2
    }
}
