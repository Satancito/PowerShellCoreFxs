[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet("Major", "Minor", "Build", "Revision")]
    [String]
    $ValueType = "Build"
)

$item = Get-Item "./Z-CoreFxs.ps1"
Import-Module -Name "$item" -Force -NoClobber

$version = Get-Content ".\Version.txt"

$version = Get-NextVersion $version $ValueType

New-Item "./Release/Z-CoreFxs.$version.ps1" -Value $(Get-Content "./Z-CoreFxs.ps1") -Force
Set-Content "./Version.txt" -Value $version
