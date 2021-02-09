# For correct operation with X-Scripts, this script needs to be located in the C# project(*.csproj) directory. 

$ErrorActionPreference = "Stop"
#region Const
#endregion Consts
#region Vars
#Warning!!! Only change with correct value.
Set-Variable -Name "XSourceName" -Value "XSource" -Scope Global 
Set-Variable -Name "XSourceGitRemoteUrl" -Value "https://github.com/ValkyriaSoft/Valkyria.Nuget" -Scope Global 
#endregion Vars

$XCoreFxs = Get-Item "./Z-CoreFxs*.ps1"
{
    if (-not (Test-Path $XCoreFxs -PathType Leaf)) {
        Throw "File `"$($PSScriptRoot)/Z-CoreFxs*.ps1`" not found."
        exit
    }
}
Import-Module -Name "$XCoreFxs" -Force -NoClobber
    


