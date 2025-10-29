$ErrorActionPreference = 'Stop'

$packageName = 'pact'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Uninstalling Pact CLI..." -ForegroundColor Yellow

# Remove from PATH
Uninstall-ChocolateyPath $toolsDir

# Clean up extensions directory (optional - ask user)
$extensionsPath = Join-Path $env:USERPROFILE '.pact'
if (Test-Path $extensionsPath) {
    $response = Read-Host "Do you want to remove the extensions directory at $extensionsPath? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host "Removing extensions directory..." -ForegroundColor Yellow
        Remove-Item -Path $extensionsPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Extensions directory removed." -ForegroundColor Green
    } else {
        Write-Host "Extensions directory preserved at: $extensionsPath" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Pact CLI uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Thank you for using Pact CLI!" -ForegroundColor Cyan
Write-Host "For feedback or issues: https://github.com/YOU54F/pact-cli/issues" -ForegroundColor Gray