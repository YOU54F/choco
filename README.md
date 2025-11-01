# Pact CLI Tools for Windows via Choco

[![Tests](https://github.com/pact-foundation/choco/actions/workflows/ci.yml/badge.svg)](https://github.com/pact-foundation/choco/actions/workflows/ci.yml)

[Pact CLI Tools](https://docs.pact.io/implementation_guides/cli) bucket for [Chocolatey](https://chocolatey.org/), the Windows command-line installer.

## Supported Platforms

| OS      | Architecture | Supported  |
| ------- | ------------ | ---------  |
| Windows | x86_64       |   ✅       |
| Windows | aarch64      |   ✅       |

## Installation

- Grab the required package from <https://github.com/pact-foundation/choco/releases>

### Unified CLI

```powershell
# Download the required package
curl https://github.com/pact-foundation/choco/releases/download/choco/pact.0.9.1.nupkg -OutFile pact.nupkg

# Install the Unified CLI
choco install -y pact --source .

# Windows on ARM - requires ForceARM64 parameter
choco install -y pact --params "'/ForceARM64:true'"  --source .
```

### Individual Packages

#### Pact Broker Client

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-broker-client.0.5.0.nupkg -OutFile pact-broker-client.nupkg
choco install -y pact-broker-client --source .
```

#### Pact Mock Server

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-mock-server.2.1.0.nupkg -OutFile pact-mock-server.nupkg
choco install -y pact-mock-server --source .
```

#### Pact Verifier

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-verifier.1.3.0.nupkg -OutFile pact-verifier.nupkg
choco install -y pact-verifier --source .
```

#### Pact Plugin

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-plugin.0.2.0.nupkg -OutFile pact-plugin.nupkg
choco install -y pact-plugin --source .
```

#### Pact Stub Server

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-stub-server.0.7.0.nupkg -OutFile pact-stub-server.nupkg
choco install -y pact-stub-server --source .
```

#### Pact Legacy

```powershell
curl https://github.com/pact-foundation/choco/releases/download/choco/pact-legacy.2.5.6.nupkg -OutFile pact-legacy.nupkg
choco install -y pact-legacy --source .
```

## Chocolatey GitHub Actions Example

```yml
- name: Install Pact via Chocolatey
  if: runner.os == 'Windows'
  shell: powershell
  run: |
    curl https://github.com/pact-foundation/choco/releases/download/choco/pact.0.9.1.nupkg -OutFile pact.nupkg
    if ("${{ runner.arch }}" -eq "ARM64") {
      choco install -y pact --source . --params "'/ForceARM64:true'"
    } else {
      choco install -y pact --source .
    }
    pact --help
```
