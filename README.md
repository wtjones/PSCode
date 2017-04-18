PSCode
=========

Overview
--------

[VS Code](https://code.visualstudio.com/) currently uses `code.cmd` for shell duties. The drawback is [this issue](https://github.com/Microsoft/vscode/issues/14529), related to the limitations of `cmd.exe` and UNC paths. 

PSCode aliases the familar `code` to run a cmdlet that launches the editor in a powershell context. The behavior of `code.cmd` is maintained (as of 1.11).


Usage
-----

### Step 1: Installation

#### Via [PowerShell Gallery](https://www.powershellgallery.com/packages/PSCode) (Powershell v5 required)

    Install-Module -Name PSCode

#### Via GitHub (PowerShell v3+ required)

Clone or download this repo to `$env:homepath\documents\WindowsPowerShell\Modules`


### Step 2: Load the module

```
Import-Module PSCode
```

I suggest putting this line in your `$PROFILE`


### Launch VS Code

Do exactly as before:

```
code somefile.txt
```

Try it from a network path:

```
code \\MyNas\docs
```