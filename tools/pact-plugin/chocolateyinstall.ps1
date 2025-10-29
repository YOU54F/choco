$ErrorActionPreference = 'Stop'

$packageName = 'pact-plugin'
$url64 = 'https://github.com/you54f/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-windows-x86_64.exe.gz'
$urlARM64 = 'https://github.com/you54f/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-windows-aarch64.exe.gz'
$checksum64 = '87feb40428bb65217da9a46b5734d5d4223742d87c85c4001dc1d1c5752f55a1'
$checksumARM64 = '3bc675462b7eb784d6b84a45d7f123a7f96ba0ca3e08bb74886fb5bae4ce4f30'

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

Write-Host "Installing Pact Plugin CLI for Windows $architecture..." -ForegroundColor Green

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$gzFilePath = Join-Path $toolsDir 'pact-plugin.exe.gz'
$executablePath = Join-Path $toolsDir 'pact-plugin.exe'

$packageArgs = @{
  packageName   = $packageName
  url64bit      = $url
  fileFullPath  = $gzFilePath
  checksum64    = $checksum
  checksumType64= 'sha256'
}

# Download the gz file
Get-ChocolateyWebFile @packageArgs

# Decompress the gz file
if (Test-Path $gzFilePath) {
    Write-Host "Decompressing $gzFilePath..." -ForegroundColor Yellow
    
    # Use .NET System.IO.Compression.GzipStream to decompress
    Add-Type -AssemblyName System.IO.Compression
    $gzStream = New-Object System.IO.FileStream($gzFilePath, [System.IO.FileMode]::Open)
    $decompressStream = New-Object System.IO.Compression.GzipStream($gzStream, [System.IO.Compression.CompressionMode]::Decompress)
    $outputStream = New-Object System.IO.FileStream($executablePath, [System.IO.FileMode]::Create)
    
    $decompressStream.CopyTo($outputStream)
    
    $outputStream.Close()
    $decompressStream.Close()
    $gzStream.Close()
    
    # Remove the gz file
    Remove-Item -Path $gzFilePath -Force
    
    Write-Host "Decompressed to: $executablePath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Pact Plugin CLI installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  pact-plugin --help                  # Show all available commands"
Write-Host "  pact-plugin list                    # List installed plugins"
Write-Host "  pact-plugin install <plugin>        # Install a plugin"
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  - CLI Docs: https://github.com/pact-foundation/pact-plugins/blob/main/cli/README.md"
Write-Host "  - Pact Docs: https://docs.pact.io"
Write-Host ""
Write-Host "Plugin Directory:" -ForegroundColor Yellow
Write-Host "  Default: %USERPROFILE%\.pact\plugins\"
Write-Host ""
Write-Host "Ready to use! Try 'pact-plugin --help' to get started." -ForegroundColor Green