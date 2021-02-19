[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet("Major", "Minor", "Build", "Revision")]
    [String]
    $ValueType = "Build"
)

$item = Get-Item "./Z-CoreFxs.ps1"
Import-Module -Name "$item" -Force -NoClobber

$version = Get-Content "./Version.txt"

$version = Get-NextVersion $version $ValueType

Remove-Item "./release/*.ps1" -Force -ErrorAction Ignore
Remove-Item "./release/*.zip" -Force -ErrorAction Ignore
@(
    "./X-Publish-ProjectPackage.ps1",
    "./Z-CoreFxs.ps1",
    "./X-PushMe.ps1",
    "./Z-CoreValues.ps1"
) | ForEach-Object {
    
    $name = "$($_ | Split-Path -Leaf)".Replace("ps1", "$($version).ps1")
    Write-Host $name
    New-Item "./release/$name" -Value "$(Get-Content $_ -Raw)" -Force
}

Compress-Archive "./release/*.ps1" "./release/PowerShellCoreFxs.$version.zip"
Remove-Item "./release/*.ps1" -Force -ErrorAction Ignore

Set-Content "./Version.txt" -Value $version
