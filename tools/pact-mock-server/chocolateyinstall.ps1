$ErrorActionPreference = 'Stop'

$packageName = 'pact-mock-server'
$url64 = 'https://github.com/you54f/pact-core-mock-server/releases/download/pact_mock_server_cli-v2.1.0/pact-mock-server-windows-x86_64.exe.gz'
$urlARM64 = 'https://github.com/you54f/pact-core-mock-server/releases/download/pact_mock_server_cli-v2.1.0/pact-mock-server-windows-aarch64.exe.gz'
$checksum64 = '58cba036160515b8f4fc29349b446fa93e9464414d35541cc97ace3c5b39e2b1'
$checksumARM64 = '9311194927b634569ca7936bf9820024050d42e74c458847eda7c59794dff92c'

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

Write-Host "Installing Pact Mock Server for Windows $architecture..." -ForegroundColor Green

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$gzFilePath = Join-Path $toolsDir 'pact-mock-server.exe.gz'
$executablePath = Join-Path $toolsDir 'pact-mock-server.exe'

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
Write-Host "Pact Mock Server installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  pact-mock-server --help             # Show all available commands"
Write-Host "  pact-mock-server start              # Start mock server"
Write-Host "  pact-mock-server create             # Create mock from pact file"
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  - CLI Docs: https://github.com/pact-foundation/pact-reference/blob/master/rust/pact_mock_server_cli/README.md"
Write-Host "  - Pact Docs: https://docs.pact.io"
Write-Host ""
Write-Host "Ready to use! Try 'pact-mock-server --help' to get started." -ForegroundColor Green