# pact-cli

Pact CLI Tools

## Choco

[![Tests](https://github.com/you54f/pact/actions/workflows/ci.yml/badge.svg)](https://github.com/you54f/pact/actions/workflows/ci.yml)

[Pact CLI tools](https://docs.pact.io/implementation_guides/cli) distributed with [Choco](https://chocolatey.org/), the Windows command-line installer.

[Chocolatey Package Page](https://community.chocolatey.org/packages/pact)

### Supported Platforms

| OS           | Architecture | Supported |
| ------- | ------------ | --------- |
| Windows| x86_64       | ✅        |
| Windows | aarch64 (via x86 emulation) |  ✅        |

### Installation

`choco install pact --version=0.0.1`

Contains a bundle with

- Pact-Ruby-Standalone
  - pact.bat
  - pact-broker.bat
  - pact-message.bat
  - pact-mock-service.bat
  - pact-provider-verifier.bat
  - pact-stub-service.bat
  - pactflow.bat

You can also install the following tools separately

- pact-plugin-cli.exe
- pact_verifier_cli.exe
- pact_mock_server_cli.exe

## Known Issues

- Running the Pact-Ruby-Standalone based tools will fail if run from outside of Chocos install directory (usually C:) - see [workflow](https://github.com/YOU54F/choco/blob/013efb54cbef6f37c111b7849293a3f847d9064f/.github/workflows/ci.yml)