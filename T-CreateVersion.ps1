[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet("Major", "Minor", "Build", "Revision")]
    [String]
    $ValueType = "Build"
)

$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

$configFile = "./Z-Config.json"
$releaseFolder = "./release"
Remove-ItemTree "$releaseFolder" -ErrorAction Ignore
New-Item "$releaseFolder" -ItemType Container -Force | Out-Null
$configObj = (Get-JsonObject "$configFile")
$version = Get-NextVersion $configObj.Version $ValueType

$jsonObject = Get-JsonObject "$configFile"
($jsonObject.Files + $jsonObject.CoreFiles) | ForEach-Object {
    Copy-Item "./$_" "$releaseFolder/$_"
}

$zipFile = "$releaseFolder/PowerShellCoreFxs.$version.zip"
Compress-Archive "$releaseFolder/*.*" "$zipFile" -Force


$configObj.Version = $version
Set-Content "$configFile" -Value "$(ConvertTo-Json $configObj)"
