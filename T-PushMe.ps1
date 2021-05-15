
[CmdletBinding()]
param (
    [Parameter()]
    [Switch]
    $WithCustomMessage,

    [Parameter()]
    [Switch]
    $CreateRelease
    )
    
    $ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber

Clear-Host

Write-Host
Write-InfoMagenta "███ Commit and push " 

Write-Host
Write-InfoBlue "█ Commit"

& "./T-CreateVersion.ps1"
$versionFile = "./Z-Version.json"
$version = (Get-JsonObject "$versionFile").Version

if (!$WithCustomMessage.IsPresent) {
    $message = $version
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


if ($CreateRelease.IsPresent) {
    Write-InfoBlue "█ Creating release in remote"
    $zipfile = "$(Get-Item "./release/*.zip")"

    gh auth status
    if (!(Test-LastExitCode -NoThrowError)) {
        gh auth login
    }

    # gh release list | ForEach-Object { 
    #     $tag = "$_".Split("`t")[2] 
    #     gh release delete "$tag" --yes
    #     git push --delete origin "$tag"
    # }

    Test-LastExitCode
    gh release create "$version-Release" "$zipFile" --title "$([System.IO.Path]::GetFileNameWithoutExtension("$(Split-Path $zipfile -Leaf)"))" --notes "$version"
}

Write-Host
Write-Host
Write-InfoMagenta "███ Finished all actions"