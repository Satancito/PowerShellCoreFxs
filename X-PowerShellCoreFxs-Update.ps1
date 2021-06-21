[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $RemoveDeprecated
)
$ErrorActionPreference = "Stop"

$ZCoreFxsUri = "https://raw.githubusercontent.com/Satancito/PowerShellCoreFxs/main/Z-CoreFxs.ps1"
if (!(Test-Path "./Z-CoreFxs.ps1" -PathType Leaf)) {
    Invoke-WebRequest -Uri "$ZCoreFxsUri" -OutFile "Z-CoreFxs.ps1"
}

Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

Write-Host
Write-InfoMagenta "███ Update - PowerShellCoreFxs Scripts " 



$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
$Path = "$X_TEMP_DIR"
if ("$(Get-Location | Split-Path -Leaf)".Equals("$(Get-VariableName $PowerShellCoreFxs)")) {
    Write-Warning -Message "WARNING. Cannot overwrite original directory of scripts."
    exit
}

$Z_CONFIG = "Z-Config.json"
$Z_CONFIG_LAST = "Z-Config.Last.json"
$ME = "X-PowerShellCoreFxs-Update.ps1"
Set-GitRepository $PowerShellCoreFxs $Path 
Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$ME" $ME -Force

if (!(Test-Path $Z_CONFIG -PathType Leaf)) {
    Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$Z_CONFIG" $Z_CONFIG -Force
    Write-PrettyKeyValue "Creating" "$Z_CONFIG"
}

$localJsonObject = Get-JsonObject $Z_CONFIG
$lastJsonObject = Get-JsonObject "$Path/$(Get-VariableName $PowerShellCoreFxs)/$Z_CONFIG"

Add-Member -MemberType NoteProperty -Name "DeprecatedFiles" -Value $lastJsonObject.DeprecatedFiles -InputObject $localJsonObject -Force
Add-Member -MemberType NoteProperty -Name "CoreFiles" -Value $lastJsonObject.CoreFiles -InputObject $localJsonObject -Force
Add-Member -MemberType NoteProperty -Name "LastSupportedFiles" -Value $lastJsonObject.Files -InputObject $localJsonObject -Force
Add-Member -MemberType NoteProperty -Name "Version" -Value $lastJsonObject.Version -InputObject $localJsonObject -Force
$localJsonObject.Files = ($null -eq $localJsonObject.Files ? $lastJsonObject.Files : $localJsonObject.Files)
$files = ($localJsonObject.Files | Where-Object { ($_ -notin $lastJsonObject.DeprecatedFiles) -and ($_ -in $lastJsonObject.LastSupportedFiles) })
Add-Member -MemberType NoteProperty -Name "Files" -Value $files -InputObject $localJsonObject -Force

Set-JsonObject $localJsonObject $Z_CONFIG

if ($RemoveDeprecated.IsPresent) {
    $localJsonObject.DeprecatedFiles | ForEach-Object {
        if (Test-Path $_ -PathType Leaf) {
            Remove-Item $_ -Force
            Write-PrettyKeyValue "Removed" "$_"
        }
    }
}

($localJsonObject.Files + $localJsonObject.CoreFiles) | ForEach-Object {
    $file = "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_"
    if ("$_".Equals($Z_CONFIG)) {
        Copy-Item -Path $file $Z_CONFIG_LAST -Force 
        Write-PrettyKeyValue "Updating" "$_"
    }
    else {
        if(Test-Path $file -PathType Leaf)
        {
            Copy-Item -Path $file "./$_" -Force 
            Write-PrettyKeyValue "Updating" "$_"
        }
        else {
            Write-PrettyKeyValue "Ignored" "$_"
        }
    }
}

Write-InfoMagenta "███ End - Update - PowerShellCoreFxs Scripts " 