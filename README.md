# PowerShellCoreFxs


# **Steps to use**

1. Run this line in Powershell.

```
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/X-Update-PowerShellCoreFxs.ps1" -OutFile "X-Update-PowerShellCoreFxs.ps1";
```

2. Edit "**Z-Config.json**", remove innecesary scripts from json and save.

3. Run "**X-Update-PowerShellCoreFxs.ps1**"
Import from you ps scripts.  
```

Import-Module -Name "$($PSCommandPath | Split-Path)/Z-CoreFxs.1.0.0.0.ps1" -Force -NoClobber #Same directory

Import-Module -Name "$($PSCommandPath | Split-Path | Split-Path | Split-Path)/PowerShellCoreFxs/Z-CoreFxs.1.0.0.0.ps1" -Force -NoClobber

Import-Module -Name "$($PSCommandPath)/../../../PowerShellCoreFxs/Z-CoreFxs.1.0.0.0.ps1" -Force -NoClobber

Import-Module -Name "path/to/script/Z-CoreValues.1.0.0.0.ps1" -Force -NoClobber
```
