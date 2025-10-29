$ErrorActionPreference = 'Stop'

$packageName = 'pact-legacy'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Write-Host "Uninstalling Pact Legacy..." -ForegroundColor Yellow
# Remove shims
Uninstall-BinFile -Name 'pact-publish.bat'
Uninstall-BinFile -Name 'pact-broker.bat'
Uninstall-BinFile -Name 'pact-stub-service.bat'
Uninstall-BinFile -Name 'pactflow.bat'
Uninstall-BinFile -Name 'pact-mock-service.bat'
Uninstall-BinFile -Name 'pact-message.bat'
Uninstall-BinFile -Name 'pact-provider-verifier.bat'
Write-Host ""
Write-Host "Pact Legacy uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Thank you for using Pact Legacy!" -ForegroundColor Cyan
Write-Host "For feedback or issues: https://github.com/pact-foundation/pact-ruby-standalone/issues" -ForegroundColor Cyan