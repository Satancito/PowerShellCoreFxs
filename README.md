# PowerShellCoreFxs

Import from you ps scripts.  

*Example*

```
Import-Module -Name "$($PSCommandPath | Split-Path)/Z-CoreValues.ps1" -Force -NoClobber
Import-Module -Name "path/to/script/Z-CoreValues.ps1" -Force -NoClobber
```
