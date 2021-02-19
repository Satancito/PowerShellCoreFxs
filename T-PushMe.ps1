
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

if(!$WithCustomMessage.IsPresent)
{
    & "./T-CreateVersion.ps1"
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
Write-InfoBlue "█ Push to remote"
git push

Write-Host
Write-Host
Write-InfoMagenta "███ Finished all actions"