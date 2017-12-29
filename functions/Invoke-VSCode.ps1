<#
    Match behavior of code.cmd
#>
function Invoke-VSCode() {
    [CmdletBinding()]
    param (        
        [Parameter(         
            mandatory=$false,               
            Position=0,     
            ValueFromRemainingArguments=$true)]
        [String[]]$allArgs
    )
    PROCESS {
                    
        $codePath = join-path $script:vscodePath 'code.exe'
        $resourcePath = join-path $script:vscodePath 'resources\app\out\cli.js'

        $codeArgs = @(('"{0}"' -f $resourcePath)) + $allArgs | select -uniq
        
        Write-Verbose ($codeArgs | convertTo-json)
              
        $prior1 = $env:ELECTRON_RUN_AS_NODE
        $prior2 = $env:VSCODE_DEV 
        $env:ELECTRON_RUN_AS_NODE=1
        $env:VSCODE_DEV = $null

        Start-Process -FilePath $codePath -ArgumentList $codeArgs

        $env:ELECTRON_RUN_AS_NODE = $prior1
        $env:VSCODE_DEV = $prior2
    }
}
