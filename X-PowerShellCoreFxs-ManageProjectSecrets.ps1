[CmdletBinding(DefaultParameterSetName = "seta")]
param (
    [Parameter(ParameterSetName = "seta")]
    [switch]
    $Edit,

    [Parameter(ParameterSetName = "setb")]
    [switch]
    $Set,
    
    [string]
    [Parameter(ParameterSetName = "seta")]
    $Editor = "code"
)

$ErrorActionPreference = "Stop"
Import-Module -Name "$(Get-Item "./Z-CoreFxs*.ps1")" -Force -NoClobber
$ProjectName = "$(Get-Item -Path "./*.csproj" | Split-Path -Leaf)"
$SecretsFileName = "$(Get-UserHome)/$ProjectName.Secrets.json"

if ($Edit.IsPresent) { 
    Write-PrettyKeyValue "███ Opening secrets for project" "`"$($ProjectName)`""
    Write-PrettyKeyValue "SecretFilename" "$SecretsFileName" -LabelForegroudColor Blue

    if (!(Test-Path -Path $secretsFileName -PathType Leaf)) {
        New-Item -Path $secretsFileName -Value "{}" | Out-Null
    }
    & $editor $SecretsFileName 
    return
}

if ($Set.IsPresent) {  

    Write-PrettyKeyValue "███ Setting up secrets for project" "`"$($ProjectName)`""
    Write-PrettyKeyValue "SecretFilename" "$SecretsFileName" -LabelForegroudColor Blue

    if (!(Test-Path -Path $SecretsFileName -PathType Leaf)) {
        Write-Host
        Write-InfoBlue "█ Creating secrets file"
        Write-PrettyKeyValue "SecretsFilename" "$SecretsFileName"
        New-Item -Path $SecretsFileName -Value "{}"
    }

    Write-Host
    Write-InfoBlue "█ Adding secrets" 
    Write-PrettyKeyValue "SecretsFilename" "$SecretsFileName"
    dotnet add "$ProjectName" package "Microsoft.Extensions.Configuration.UserSecrets"
    dotnet user-secrets init
    dotnet user-secrets clear
    Get-Content "$SecretsFileName" | dotnet user-secrets set
    return   
}
    
Write-InfoBlue "█ Listing secrets"
Write-PrettyKeyValue "SecretFilename" "$SecretsFileName" -LabelForegroudColor Blue
dotnet user-secrets list

