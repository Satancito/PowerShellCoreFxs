$ErrorActionPreference = "Stop"
if(!(Test-Path "./Z-CoreFxs.ps1" -PathType Leaf))
{
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/Z-CoreFxs.ps1" -OutFile "Z-CoreFxs.ps1"
}

Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

Write-Host
Write-InfoMagenta "███ Update - PowerShellCoreFxs Scripts " 

$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
$Path = "$X_TEMP_DIR"
if ("$(Get-Location | Split-Path -Leaf)".Equals("$(Get-VariableName $PowerShellCoreFxs)"))
{
    Write-Warning -Message "WARNING. Cannot overwrite original directory of scripts."
    exit
}

Set-GitRepository $PowerShellCoreFxs $Path
$jsonDestinationFilename = (Test-Path "./Z-Config.json" -PathType Leaf) ? "Z-Config.Last.json" : "Z-Config.json"
$jsonConfigurationFile = ($jsonDestinationFilename.Equals("Z-Config.json") ? "$Path/$(Get-VariableName $PowerShellCoreFxs)/$jsonDestinationFilename" : "./Z-Config.json")

(Get-JsonObject "$jsonConfigurationFile").Files | ForEach-Object{
    if("$_".Equals("Z-Config.json"))
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$jsonDestinationFilename" -Force 
        Write-PrettyKeyValue "Updating" "$jsonDestinationFilename"
    }
    else
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$_" -Force 
        Write-PrettyKeyValue "Updating" "$_"
    }
}

Write-InfoMagenta "███ End - Update - PowerShellCoreFxs Scripts " 