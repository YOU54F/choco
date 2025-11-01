# Package Update Scripts

This directory contains scripts to automatically update Chocolatey packages from JSON manifest files in the `bucket/` directory taken from <https://github.com/pact-foundation/scoop>

- **File**: `update-packages.py`
- **Requirements**: Python 3.6+
- **Platforms**: Cross-platform (Linux, macOS, Windows)
- **Usage**: `python3 update-packages.py`

## What This Script Does

1. **Read JSON manifests** from the `bucket/` directory
2. **Extract version, URLs, and checksums** for each tool
3. **Update .nuspec files** with the latest version numbers
4. **Update chocolateyinstall.ps1 files** with new URLs and checksums
5. **Provide detailed feedback** on success/failure of each update

## Supported Tools

The scripts automatically process these tools based on their JSON manifests:

- `pact-broker-client.json` → Updates `pact-broker-client.nuspec` and `tools/pact-broker-client/chocolateyinstall.ps1`
- `pact-mock-server.json` → Updates `pact-mock-server.nuspec` and `tools/pact-mock-server/chocolateyinstall.ps1`
- `pact-verifier.json` → Updates `pact-verifier.nuspec` and `tools/pact-verifier/chocolateyinstall.ps1`
- `pact-plugin.json` → Updates `pact-plugin.nuspec` and `tools/pact-plugin/chocolateyinstall.ps1`
- `pact-stub-server.json` → Updates `pact-stub-server.nuspec` and `tools/pact-stub-server/chocolateyinstall.ps1`
- `pact-legacy.json` → Updates `pact-legacy.nuspec` and `tools/pact-legacy/chocolateyinstall.ps1`

## JSON Manifest Format

The scripts expect JSON manifests in this format:

```json
{
    "version": "1.0.0",
    "description": "Tool description",
    "architecture": {
        "64bit": {
            "url": ["https://example.com/tool-x64.exe"],
            "hash": ["sha256checksum"]
        },
        "arm64": {
            "url": ["https://example.com/tool-arm64.exe"],
            "hash": ["sha256checksum"]
        }
    }
}
```