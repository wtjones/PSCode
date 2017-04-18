<#
    Match behavior of code.cmd
#>
function Invoke-VSCode() {
    [CmdletBinding()]
    param ($args)
    PROCESS {
        $prior1 = $env:ELECTRON_RUN_AS_NODE
        $prior2 = $env:VSCODE_DEV 
        $env:ELECTRON_RUN_AS_NODE=1
        $env:VSCODE_DEV = $null

        $codePath = join-path ${env:ProgramFiles(x86)} 'Microsoft VS Code\code.exe'
        $resourcePath = join-path ${env:ProgramFiles(x86)} 'Microsoft VS Code\resources\app\out\cli.js'
        Start-Process $codePath ('"{0}" "{1}"' -f $resourcePath, $args)
        $env:ELECTRON_RUN_AS_NODE = $prior1
        $env:VSCODE_DEV = $prior2
    }
}
