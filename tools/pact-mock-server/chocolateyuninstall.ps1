$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Uninstalling Pact Mock Server..." -ForegroundColor Yellow

# Remove executable
$executablePath = Join-Path $toolsDir 'pact-mock-server.exe'
if (Test-Path $executablePath) {
    Remove-Item -Path $executablePath -Force -ErrorAction SilentlyContinue
    Write-Host "Removed executable: $executablePath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Pact Mock Server uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Thank you for using Pact Mock Server!" -ForegroundColor Cyan
Write-Host "For feedback or issues: https://github.com/pact-foundation/pact-reference/issues" -ForegroundColor Gray