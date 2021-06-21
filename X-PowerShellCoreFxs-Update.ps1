[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $RemoveDeprecated
)
$ErrorActionPreference = "Stop"

$ZCoreFxsUri = "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/Z-CoreFxs.ps1"
if(!(Test-Path "./Z-CoreFxs.ps1" -PathType Leaf))
{
    Invoke-WebRequest -Uri "$ZCoreFxsUri" -OutFile "Z-CoreFxs.ps1"
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
$newInstall = $false
if(!(Test-Path "./Z-Config.json" -PathType Leaf)) {
    Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/Z-Config.json" "./$jsonDestinationFilename" -Force
    Write-PrettyKeyValue "Creating" "$jsonDestinationFilename"
    $newInstall = $true
}

$jsonObject = Get-JsonObject "$jsonConfigurationFile"
if($RemoveDeprecated.IsPresent)
{
    $jsonObject.DeprecatedFiles | ForEach-Object {
        if(Test-Path $_ -PathType Leaf)
        {
            Remove-Item $_ -Force
            Write-PrettyKeyValue "Removed" "$_"
        }
    }
}

($jsonObject.Files + $jsonObject.CoreFiles) | ForEach-Object{
    if("$_".Equals("Z-Config.json"))
    {
        if(!($newInstall))
        {
            Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$jsonDestinationFilename" -Force 
            Write-PrettyKeyValue "Updating" "$jsonDestinationFilename"
        }
    }
    else
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$_" -Force 
        Write-PrettyKeyValue "Updating" "$_"
    }
}

Write-InfoMagenta "███ End - Update - PowerShellCoreFxs Scripts " 