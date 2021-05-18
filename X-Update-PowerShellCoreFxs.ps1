$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber


function Test-GitRepository {
    param (
        [Parameter()]
        [System.String]
        $Path
    )
    if (!(Test-Path $Path -PathType Container)) {
        return $false
    }
    try {
        Push-Location $Path
        git rev-parse --is-inside-work-tree --quiet | Out-Null
        $result = Test-LastExitCode -NoThrowError
        return $result
    }
    finally {
        Pop-Location
    }
}

function Set-GitRepository {
    param (
        [Parameter()]
        [System.String]
        $RepositoryUrl,

        [Parameter()]
        [System.String]
        $Path = [System.String]::Empty
    )
    $Path = ([System.String]::IsNullOrWhiteSpace($Path) ? "$(Get-UserHome)/$X_TEMP_DIR" : $Path)
    $folderName = ($RepositoryUrl | Split-Path -Leaf).Replace(".git", [String]::Empty)  
    New-Item "$Path" -Force -ItemType Container | Out-Null
    Remove-ItemTree "$path/$folderName" -ErrorAction Ignore
    try {
        Push-Location $Path
        git clone $RepositoryUrl
        Test-LastExitCode
    }
    finally {
        Pop-Location
    }
    
}

$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
$Path = "$X_TEMP_DIR"
Set-GitRepository $PowerShellCoreFxs $Path

$json = (Test-Path "./Z-Config.json" -PathType Leaf) ? "./Z-Config.Last.json" : "./Z-Config.json"

(Get-JsonObject "./Z-Config.json").Scripts | ForEach-Object{
    if("$_".Equals("Z-Config.json"))
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$json" -Force 
    }
    else
    {
        Copy-Item -Path "$Path/$(Get-VariableName $PowerShellCoreFxs)/$_" "./$_" -Force 
    }
    Write-Host $_
}