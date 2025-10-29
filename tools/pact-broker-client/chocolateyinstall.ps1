$ErrorActionPreference = 'Stop'

$packageName = 'pact-broker-client'
$url64 = 'https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.4.1/pact-broker-cli-x86_64-windows-msvc.exe'
$urlARM64 = 'https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.4.1/pact-broker-cli-aarch64-windows-msvc.exe'
$checksum64 = 'af0c20a438b9e88b368b21f1e1551e8df524094af8e582a9462b8cf022a43e52'
$checksumARM64 = '199a8a2c810d3b167812ad3c30beb43da7877b7fc330dec344948ff183d76fb4'

# Determine architecture
$is64bit = [System.Environment]::Is64BitOperatingSystem
$isARM64 = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64'

if ($isARM64) {
    $url = $urlARM64
    $checksum = $checksumARM64
    $architecture = 'ARM64'
} elseif ($is64bit) {
    $url = $url64
    $checksum = $checksum64
    $architecture = 'x64'
} else {
    throw "32-bit Windows is not supported. Please use a 64-bit or ARM64 system."
}

Write-Host "Installing Pact Broker Client for Windows $architecture..." -ForegroundColor Green

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$executablePath = Join-Path $toolsDir 'pact-broker-client.exe'

$packageArgs = @{
  packageName   = $packageName
  url64bit      = $url
  fileFullPath  = $executablePath
  checksum64    = $checksum
  checksumType64= 'sha256'
}

Get-ChocolateyWebFile @packageArgs

Write-Host ""
Write-Host "Pact Broker Client installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  pact-broker-client --help           # Show all available commands"
Write-Host "  pact-broker-client publish          # Publish pacts to broker"
Write-Host "  pact-broker-client can-i-deploy     # Check deployment safety"
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  - CLI Docs: https://github.com/pact-foundation/pact-broker-cli/blob/main/README.md"
Write-Host "  - Pact Docs: https://docs.pact.io"
Write-Host ""
Write-Host "Ready to use! Try 'pact-broker-client --help' to get started." -ForegroundColor Green