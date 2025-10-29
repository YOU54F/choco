$ErrorActionPreference = 'Stop'

$packageName = 'pact-stub-server'
$url64 = 'https://github.com/you54f/pact-stub-server/releases/download/v0.7.0/pact-stub-server-windows-x86_64.exe.gz'
$urlARM64 = 'https://github.com/you54f/pact-stub-server/releases/download/v0.7.0/pact-stub-server-windows-aarch64.exe.gz'
$checksum64 = '45e983686b3a890026436b5b139e00471874c5cb1b8827698e66ae969882a055'
$checksumARM64 = '64d3b1b3c51eb03ca8d001e69fbcaab8aae37ba60d8b24a9a4c72afa4063a6c2'

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

Write-Host "Installing Pact Stub Server for Windows $architecture..." -ForegroundColor Green

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$gzFilePath = Join-Path $toolsDir 'pact-stub-server.exe.gz'
$executablePath = Join-Path $toolsDir 'pact-stub-server.exe'

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
Write-Host "Pact Stub Server installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  pact-stub-server --help             # Show all available commands"
Write-Host "  pact-stub-server start              # Start stub server"
Write-Host "  pact-stub-server --file <pact>      # Start with specific pact file"
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  - CLI Docs: https://github.com/pact-foundation/pact-stub-server/blob/master/README.md"
Write-Host "  - Pact Docs: https://docs.pact.io"
Write-Host ""
Write-Host "Ready to use! Try 'pact-stub-server --help' to get started." -ForegroundColor Green