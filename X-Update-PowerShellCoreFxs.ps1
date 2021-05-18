$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
if ("$(Get-Location | Split-Path -Leaf)".Equals("$(Get-VariableName $PowerShellCoreFxs)"))
{
    exit
}

$Path = "$X_TEMP_DIR"
Set-GitRepository $PowerShellCoreFxs $Path

$json = (Test-Path "./Z-Config.json" -PathType Leaf) ? "Z-Config.Last.json" : "Z-Config.json"

(Get-JsonObject "./Z-Config.json").Scripts | ForEach-Object{
    if("$_".Equals("Z-Config.json"))
    {
        Write-Host "Manejando Json $json"
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$json" -Force 
    }
    else
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$_" -Force 
    }
    Write-Host $_
}