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
$versionFile = "./Z-Version.json"
$releaseFolder = "./release"
Remove-Item "$releaseFolder" -Force -Recurse -ErrorAction Ignore
New-Item "$releaseFolder" -ItemType Container -Force
$versionObj = (Get-JsonObject "$versionFile")
$version = Get-NextVersion $versionObj.Version $ValueType


(Get-JsonObject "$configFile").Scripts | ForEach-Object {
    
    $name = "$($_ | Split-Path -Leaf)".Replace("ps1", "$($version).ps1")
    Write-Host "Creating: $name"
    Copy-Item "./$_" "$releaseFolder/$name"
    #New-Item "./release/$name" -Value "$(Get-Content $_ -Raw)" -Force
}

$zipFile = "$releaseFolder/PowerShellCoreFxs.$version.zip"
Compress-Archive "$releaseFolder/*.ps1" "$zipFile"
Remove-Item "$releaseFolder/*.ps1" -Force -ErrorAction Ignore

$versionObj.Version = $version
Set-Content "$versionFile" -Value "$(ConvertTo-Json $versionObj)"
