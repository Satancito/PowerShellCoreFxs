# **PowerShellCoreFxs**


# ***Steps to use***

# Install

**1.** Run this line in Powershell.

```
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/X-PowerShellCoreFxs-Update.ps1" -OutFile "X-Update-PowerShellCoreFxs.ps1"; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/Z-Config.json" -OutFile "Z-Config.json"
```

**2.** Edit "**Z-Config.json**", in the "Files" key's value remove from array the innecesary scripts and save. Or skip to step 3 if you need all.

**3.** Run "**X-Update-PowerShellCoreFxs.ps1**"

```
./X-Update-PowerShellCoreFxs.ps1
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
./X-Update-PowerShellCoreFxs.ps1
```
```
./X-Edit-ProjectSecrets.ps1.ps1
```

## Prefixes
"**Z-**" prefix is a not runnable script(library)   
"**X-**" prefix is a runnable script.

# Update

**1.** Run "**X-Update-PowerShellCoreFxs.ps1**" 

```
./X-Update-PowerShellCoreFxs.ps1
```

# Get all scripts files 
**1.** Remove "**Z-Config.json**"

**2.** Run "**X-Update-PowerShellCoreFxs.ps1**" 

```
./X-Update-PowerShellCoreFxs.ps1
```

# Get specific script file
**1.** Edit "**Z-Config.json**" in the "Files" key's value add inside of array desired/removed script and finally save. "CoreFiles" key's value don't be modified.

*Original file*
```
{
  "Files": [
    "X-Edit-ProjectSecrets.ps1"
  ],
  "CoreFiles": [
    "X-Update-PowerShellCoreFxs.ps1",
    "Z-CoreFxs.ps1",
    "Z-Config.json"
  ],
  "Version": "1.0.62"
}
```

*Updated file*
```
{
  "Files": [
    "X-Edit-ProjectSecrets.ps1",
    "X-Set-ProjectSecrets.ps1",
    "X-Push-ProjectToRemote.ps1"
  ],
  "CoreFiles": [
    "X-Update-PowerShellCoreFxs.ps1",
    "Z-CoreFxs.ps1",
    "Z-Config.json"
  ],
  "Version": "1.0.62"
}
```

**2.** Run "**X-Update-PowerShellCoreFxs.ps1**" 
```
./X-Update-PowerShellCoreFxs.ps1
```

# Update "Z-Config.json"
if "**Z-Config.json**" exists the script "**X-Update-PowerShellCoreFxs.ps1**" don't replace the file, it creates the file "**Z-Config.Last.json**" it contains the latest configuration values.

If you need any latest script you need to copy manually the script name from "**Z-Config.Last.json**" to "**Z-Config.json**"