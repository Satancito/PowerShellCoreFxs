$PowerShellCoreFxs = "https://github.com/Satancito/PowerShellCoreFxs.git"
try {
    Remove-Item -Path "./temp" -Force -Recurse 
    New-Item "./temp" -Force -ItemType Container
    Push-Location "./temp"   
    git clone "$PowerShellCoreFxs"
}
catch {
}
finally
{
    Pop-Location
}