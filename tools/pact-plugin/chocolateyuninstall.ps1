$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Uninstalling Pact Plugin CLI..." -ForegroundColor Yellow

# Remove executable
$executablePath = Join-Path $toolsDir 'pact-plugin.exe'
if (Test-Path $executablePath) {
    Remove-Item -Path $executablePath -Force -ErrorAction SilentlyContinue
    Write-Host "Removed executable: $executablePath" -ForegroundColor Green
}

# Clean up plugins directory (optional - ask user)
$pluginsPath = Join-Path $env:USERPROFILE '.pact\plugins'
if (Test-Path $pluginsPath) {
    $response = Read-Host "Do you want to remove the plugins directory at $pluginsPath? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host "Removing plugins directory..." -ForegroundColor Yellow
        Remove-Item -Path $pluginsPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Plugins directory removed." -ForegroundColor Green
    } else {
        Write-Host "Plugins directory preserved at: $pluginsPath" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Pact Plugin CLI uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Thank you for using Pact Plugin CLI!" -ForegroundColor Cyan
Write-Host "For feedback or issues: https://github.com/pact-foundation/pact-plugins/issues" -ForegroundColor Gray