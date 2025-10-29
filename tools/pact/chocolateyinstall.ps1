$ErrorActionPreference = 'Stop'

$packageName = 'pact'
$url64 = 'https://github.com/you54f/pact-cli/releases/download/v0.9.0/pact-x86_64-windows-msvc.exe'
$urlARM64 = 'https://github.com/you54f/pact-cli/releases/download/v0.9.0/pact-aarch64-windows-msvc.exe'
$checksum64 = 'b2b80b76d099ce992a2659cb1e49d9bc8462441a48996191b4b149a4be6a0fdd'
$checksumARM64 = '7ab2a33304d8eff5299cb4556aa06c9d822ccd8124c4da3973e529a92eb5987c'


# Determine architecture (ARM64 detection is unsuppported by Choco)
$is64bit = [System.Environment]::Is64BitOperatingSystem
$isARM64 = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64'

# Get package parameters
$packageParameters = Get-PackageParameters

# Allow user to override architecture detection via package parameters
if ($packageParameters.ContainsKey('ForceARM64')) {
    $isARM64 = $true
    Write-Host "Forcing ARM64 architecture via package parameter" -ForegroundColor Yellow
} elseif ($packageParameters.ContainsKey('Forcex64')) {
    $isARM64 = $false
    Write-Host "Forcing x64 architecture via package parameter" -ForegroundColor Yellow
}

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

Write-Host "Installing Pact CLI for Windows $architecture..." -ForegroundColor Green

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$executablePath = Join-Path $toolsDir 'pact.exe'

$packageArgs = @{
  packageName   = $packageName
  fileFullPath  = $executablePath
  url64bit      = $url
  checksum64    = $checksum
  checksumType64= 'sha256'
}

Get-ChocolateyWebFile @packageArgs


Write-Host ""
Write-Host "Pact CLI with Extensions installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  pact --help                           # Show all available commands"
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  - CLI Docs: https://github.com/YOU54F/pact-cli/blob/main/README.md"
Write-Host "  - Pact Docs: https://docs.pact.io"
Write-Host ""
Write-Host ""
Write-Host "This unified CLI includes:" -ForegroundColor Yellow
Write-Host "  - Mock Server (pact mock)"
Write-Host "  - Provider Verifier (pact verifier)"
Write-Host "  - Stub Server (pact stub)"  
Write-Host "  - Broker Client (pact broker)"
Write-Host "  - PactFlow Client (pact pactflow)"
Write-Host "  - Plugin CLI (pact plugin)"
Write-Host "  - Extension System (pact extension)"
Write-Host ""
Write-Host "Ready to use! Try 'pact --help' to get started." -ForegroundColor Green