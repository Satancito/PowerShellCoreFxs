
[CmdletBinding()]
param (
    [Parameter()]
    [Switch]
    $WithCustomMessage
)

$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

Clear-Host
    
Write-Host
Write-InfoMagenta "███ Commit and push " 

Write-Host
Write-InfoBlue "█ Commit"

& "./T-CreateVersion.ps1"

if(!$WithCustomMessage.IsPresent)
{
    $message = Get-Content ".\Version.txt"
}
else {
    Write-InfoGreen "Enter a commit message: " -NoNewLine
    $message = [System.Console]::ReadLine();
}

git add -A
Test-LastExitCode
git status
git commit -m "$message"
Write-Host
Write-InfoBlue "█ Pushing to remote"
git push

Test-LastExitCode
Write-InfoBlue "█ Creating release in remote"
$zipfile = "$(Get-Item "./release/*.zip")"
$version = (Get-Content "./Version.txt").Trim()
gh release create "$version" "$zipFile" --title "$version"

Write-Host
Write-Host
Write-InfoMagenta "███ Finished all actions"