

[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $IsNewContext,

    [Parameter()]
    [switch]
    $Reset,

    [Parameter()]
    [ValidateSet("Major", "Minor", "Build", "Revision")]
    [String]
    $BuildValueType = "Build"
)
    
$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-Values*.ps1")" -Force -NoClobber

if (-not $IsNewContext.IsPresent) {
    $resetParam = $Reset.IsPresent ? "-Reset" : ""
    Start-Process -FilePath pwsh -ArgumentList "-File ""$($PSCommandPath)""", "-IsNewContext $resetParam -BuildValueType $BuildValueType" -NoNewWindow -Wait -UseNewEnvironment
    exit
}

if($Reset.IsPresent)
{
    [System.Environment]::SetEnvironmentVariable($XSourceName, "", [System.EnvironmentVariableTarget]::User)
}
    
Clear-Host
    
Write-Host
[System.String] $project = Get-Item "./*.csproj"
Write-PrettyKeyValue "███ Publish NugetPackage for project" "`"$project`""
Write-InfoBlue "█ Checking - `"XSource`" environment variable"
$sourcePath = [System.Environment]::GetEnvironmentVariable($XSourceName, [System.EnvironmentVariableTarget]::User)
Write-Host "XSource: $sourcePath"

if ([String]::IsNullOrWhiteSpace($sourcePath)) {
    $folder = $(Split-Path $XSourceGitRemoteUrl -Leaf)
    $sourcePath = "$(Get-UserHome)/$XSourceName/$folder"
    Write-InfoDarkGray "XSource environment variable is empty or not exists. Now setting default value."
    [System.Environment]::SetEnvironmentVariable($XSourceName, $sourcePath, [System.EnvironmentVariableTarget]::User)
    Write-Host "XSource: $sourcePath"
    try {
        New-Item -Path $sourcePath -Force -ItemType "directory"
        Push-Location $("$sourcePath" | Split-Path)
        Remove-Item $folder -Force -Recurse
        git clone $XSourceGitRemoteUrl   
        Test-LastExitCode 
        Get-Item $sourcePath
    }
    catch {
    }
    finally {
        Pop-Location
    }
}

if (-not (Test-Path $sourcePath -PathType Container)) {
    throw "Environment variable `"XSource`"'s path `"$env:XSource`" is invalid or not exists. Check value and run this script again. You can run with -Reset parameter to set the default value."
    exit
}


Write-Host
Write-InfoBlue "█ Update - Project Version"
Update-Version -ProjectFileName $project -ValueType $BuildValueType
Write-InfoWhite $project 

Write-Host
Write-InfoBlue "█ Build - Project"
dotnet build --configuration Release

Write-Host
Write-InfoBlue "█ Build - Project Pack"
Remove-Item "./bin/Release/*.nupkg"
dotnet pack --configuration Release
$item = (Get-Item "./bin/Release/*.nupkg")

Write-Host
Write-InfoBlue "█ Copy - Project Pack"
Write-PrettyKeyValue "From" "$($item.FullName)"
Write-PrettyKeyValue  "To" "$($sourcePath)"
Copy-Item $item.FullName  -Destination $sourcePath

Write-Host
Write-Host
Write-InfoMagenta "███ Finished all actions"

