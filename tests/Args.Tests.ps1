$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$moduleRoot = "$here\.."

"$moduleRoot\functions\*.ps1" | Resolve-Path | %{. $_.ProviderPath; write-host $_.ProviderPath}


function SetupDrive {
    mkdir 'TestDrive:\ArgsTest'
    echo '' > 'TestDrive:\ArgsTest\a.txt'
    echo '' > 'TestDrive:\ArgsTest\b.txt'
}

$rcPath = 'RC'
$rcPathResult = '"RC"'

Describe "GetArgs" {
    $result = GetArgs $rcPath @('a.txt', 'b.txt:10', '-g')
    It "Should pass string args unmodified" {
        $result | Should Be @($rcPathResult, 'a.txt', 'b.txt:10', '-g')
        Write-host $result
    }

    $result = GetArgs $rcPath @('c:\some path to\a file.txt', 'c:\some path to\b file.txt')
    It "Should quote as needed" {
        $result | Should Be @($rcPathResult, '"c:\some path to\a file.txt"', '"c:\some path to\b file.txt"')
        Write-host $result
    }

    SetupDrive
    $files = (get-item 'TestDrive:\ArgsTest\*')
    $result = GetArgs $rcPath @('a.txt', $files)
    It "Should flatten array" {
        $result | Should Be @($rcPathResult, 'a.txt', $files[0].FullName, $files[1].FullName)
        # Posh will give equality between a file object and the file's FullName,
        # so ensure that we only have strings.
        $result[2] -is [string] -and $result[3] -is [string] | Should Be $true
        Write-host ($result | ConvertTo-Json)
    }
}
