$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
$Path = "$X_TEMP_DIR"
if ("$(Get-Location | Split-Path -Leaf)".Equals("$(Get-VariableName $PowerShellCoreFxs)"))
{
    Write-Debug -Message "Cannot overwrite original directory of scripts." -Debug
    exit
}

Set-GitRepository $PowerShellCoreFxs $Path

$json = (Test-Path "./Z-Config.json" -PathType Leaf) ? "Z-Config.Last.json" : "Z-Config.json"

(Get-JsonObject "./Z-Config.json").Files | ForEach-Object{
    if("$_".Equals("Z-Config.json"))
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$json" -Force 
        Write-PrettyKeyValue "Updating" "$json"
    }
    else
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$_" -Force 
        Write-PrettyKeyValue "Updating" "$_"
    }
}