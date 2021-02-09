# PowerShellCoreFxs

Import from you ps scripts.  

*Example*

```
Import-Module -Name "$($PSCommandPath | Split-Path)/Z-CoreValues.ps1" -Force -NoClobber #Same directory
Import-Module -Name "$($PSCommandPath | Split-Path | Split-Path | Split-Path)/PowerShellCoreFxs/Z-CoreFxs.ps1" -Force -NoClobber
Import-Module -Name "$($PSCommandPath)/../../../PowerShellCoreFxs/Z-CoreFxs.ps1" -Force -NoClobber
Import-Module -Name "path/to/script/Z-CoreValues.ps1" -Force -NoClobber
```
