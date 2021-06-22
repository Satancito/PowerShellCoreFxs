# **PowerShellCoreFxs**


# ***Steps to use***

# Install

**1.** Run this line in Powershell.

```
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/X-PowerShellCoreFxs-Update.ps1" -OutFile "X-PowerShellCoreFxs-Update.ps1";
```

**2.** Edit "**Z-Config.json**", in the "Files" key's value remove from array the innecesary scripts and save. Or skip to step 3 if you need all.

**3.** Run "**X-PowerShellCoreFxs-Update.ps1**"

```
./X-PowerShellCoreFxs-Update.ps1
```

**4.** Import the downloaded script from your ps scripts.  
```
Import-Module -Name "$($PSCommandPath | Split-Path)/Z-CoreFxs.ps1" -Force -NoClobber #Same directory

Import-Module -Name "$($PSCommandPath | Split-Path | Split-Path | Split-Path)/PowerShellCoreFxs/Z-CoreFxs.ps1" -Force -NoClobber

Import-Module -Name "$($PSCommandPath)/../../../PowerShellCoreFxs/Z-CoreFxs.ps1" -Force -NoClobber

Import-Module -Name "path/to/script/Z-CoreFxs.ps1" -Force -NoClobber
```

Or run the downloaded scripts

```
./X-PowerShellCoreFxs-Update.ps1
./X-PowerShellCoreFxs-ManageProjectSecrets.ps1 -Set -Project "J:\Projects\MyProject.csproj"
./X-PowerShellCoreFxs-ManageProjectSecrets.ps1 -List
```

# Update

**1.** Run "**X-PowerShellCoreFxs-Update.ps1**" 

```
./X-PowerShellCoreFxs-Update.ps1
```

# Get all scripts files 

**1.** Remove "**Z-Config.json**"   
 
**2.** Run "**X-PowerShellCoreFxs-Update.ps1**" 

```
./X-PowerShellCoreFxs-Update.ps1
```

# Get specific script files
**1.** Edit "**Z-Config.json**" in the "Files" key's value add inside of array desired/removed script and finally save. "CoreFiles", "DeprecatedFiles" keys's values don't be modified.

*Original file*
```
{
  "Files": [
    "X-PowerShellCoreFxs-ManageProjectSecrets.ps1"
  ],
  "CoreFiles": [
    "Z-CoreFxs.ps1",
    "Z-Config.json"
  ],
  ...
}
```

*Updated file*
```
{
  "Files": [
    "X-PowerShellCoreFxs-ManageProjectSecrets.ps1",
    "X-PowerShellCoreFxs-PushProjectToRemote.ps1"
  ],
  "CoreFiles": [
    "Z-CoreFxs.ps1",
    "Z-Config.json"
  ],
  ...
}
```

**2.** Run "**X-PowerShellCoreFxs-Update.ps1**" 
```
./X-PowerShellCoreFxs-Update.ps1
```

# Update "Z-Config.json"
if "**Z-Config.json**" exists the script "**X-PowerShellCoreFxs-Update.ps1**" don't replace the file, it creates the file "**Z-Config.Last.json**" it contains the latest configuration values.

If you need any latest configuration from new versions you need to copy manually the content from "**Z-Config.Last.json**" to "**Z-Config.json**".

# Files Prefixes

"**Z-**" prefix is a not runnable script(library). It can be imported from your scripts.
"**X-**" prefix is a runnable script. It can be called by your scripts with [pwsh](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.1) command 