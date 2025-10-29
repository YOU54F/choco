$ErrorActionPreference = 'Stop'

$packageName = 'pact-broker-client'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Uninstalling Pact Broker Client..." -ForegroundColor Yellow

# Remove executable
$executablePath = Join-Path $toolsDir 'pact-broker-client.exe'
if (Test-Path $executablePath) {
    Remove-Item -Path $executablePath -Force -ErrorAction SilentlyContinue
    Write-Host "Removed executable: $executablePath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Pact Broker Client uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Thank you for using Pact Broker Client!" -ForegroundColor Cyan
Write-Host "For feedback or issues: https://github.com/pact-foundation/pact-broker-cli/issues" -ForegroundColor Gray