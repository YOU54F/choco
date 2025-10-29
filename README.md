# Pact CLI Tools for Windows

[![Tests](https://github.com/you54f/pact/actions/workflows/ci.yml/badge.svg)](https://github.com/you54f/pact/actions/workflows/ci.yml)

[Pact CLI tools](https://docs.pact.io/implementation_guides/cli) distributed with [Chocolatey](https://chocolatey.org/), the Windows command-line installer.

## 📦 Available Packages

### Unified CLI (Recommended)

- **[pact](https://community.chocolatey.org/packages/pact)** - All-in-one Pact CLI with extensions support

### Individual Tools

- **[pact-broker-client](#pact-broker-client)** - Interact with Pact Broker (publish, retrieve, deploy checks)
- **[pact-mock-server](#pact-mock-server)** - HTTP mock server for consumer testing
- **[pact-verifier](#pact-verifier)** - Provider verification tool
- **[pact-plugin](#pact-plugin)** - Plugin management for protocol extensions
- **[pact-stub-server](#pact-stub-server)** - HTTP stub server for integration testing
- **[pact-legacy](#pact-legacy)** - Legacy Ruby-based Pact tools

## 🚀 Quick Start

### Install All Tools (Recommended)

```powershell
choco install pact
```

Windows on ARM users, require a `ForceARM64:true` parameter, as choco does support native architecture detection on WoA.

```powershell
choco install pact --params "'/ForceARM64:true'"
```

### Install Individual Tools

```powershell
# Install specific tools as needed
choco install pact-broker-client
choco install pact-mock-server
choco install pact-verifier
choco install pact-plugin
choco install pact-stub-server
```

## 🔧 Individual Package Details

### pact-broker-client

**Version:** 0.4.1 | **Executable:** `pact-broker-client.exe`

Command line tool for interacting with the [Pact Broker](https://github.com/pact-foundation/pact_broker).

```powershell
choco install pact-broker-client
```

**Key Features:**

- Publish pacts to Pact Broker
- Check deployment safety with `can-i-deploy`
- Record deployment events
- Manage pacticipant versions and tags

**Quick Commands:**

```powershell
pact-broker-client --help
pact-broker-client publish ./pacts --broker-base-url http://localhost:9292 --auto-detect-version-properties
pact-broker-client can-i-deploy --pacticipant MyApp --version 1.0.0 --to production  --broker-base-url http://localhost:9292
```

**Links:** [GitHub](https://github.com/pact-foundation/pact-broker-cli) | [Documentation](https://docs.pact.io/pact_broker)

---

### pact-mock-server

**Version:** 2.1.0 | **Executable:** `pact-mock-server.exe`

Standalone HTTP mock server for consumer testing built with Rust.

```powershell
choco install pact-mock-server
```

**Key Features:**

- Create mock services from Pact files
- Real-time request validation
- Support for Pact V2, V3, V4 specifications
- Plugin support for custom protocols

**Quick Commands:**

```powershell
pact-mock-server --help
pact-mock-server start --port 1234
pact-mock-server create --pact consumer-provider.json --port 1234
```

**Links:** [GitHub](https://github.com/pact-foundation/pact-reference) | [Documentation](https://docs.pact.io/implementation_guides/rust/pact_mock_server_cli)

---

### pact-verifier

**Version:** 1.3.0 | **Executable:** `pact-verifier.exe`

Provider verification tool built with Rust for high performance.

```powershell
choco install pact-verifier
```

**Key Features:**

- Verify providers against consumer contracts
- Support for provider states and state changes
- Verify from files, URLs, or Pact Broker
- Flexible interaction filtering

**Quick Commands:**

```powershell
pact-verifier --help
pact-verifier --file ./pact.json --host localhost --port 8080
```

**Links:** [GitHub](https://github.com/pact-foundation/pact-reference) | [Documentation](https://docs.pact.io/provider/using_pact_verifier_cli)

---

### pact-plugin

**Version:** 0.2.0 | **Executable:** `pact-plugin.exe`

Plugin management CLI for extending Pact with custom protocol support.

```powershell
choco install pact-plugin
```

**Key Features:**

- Install and manage Pact plugins
- Support for gRPC, GraphQL, Avro, and custom protocols
- Plugin discovery from repositories
- Version management

**Quick Commands:**

```powershell
pact-plugin --help
pact-plugin list
pact-plugin install protobuf
```

**Links:** [GitHub](https://github.com/pact-foundation/pact-plugins) | [Documentation](https://docs.pact.io/plugins)

---

### pact-stub-server

**Version:** 0.7.0 | **Executable:** `pact-stub-server.exe`

HTTP server that generates responses from Pact files without request validation.

```powershell
choco install pact-stub-server
```

**Key Features:**

- Generate predictable responses from Pact files
- Perfect for integration testing and development
- CORS and TLS support
- Load multiple Pact files simultaneously

**Quick Commands:**

```powershell
pact-stub-server --help
pact-stub-server --dir ./pacts --port 8080
```

**Links:** [GitHub](https://github.com/pact-foundation/pact-stub-server) | [Documentation](https://docs.pact.io/getting_started/stubs)

---

### pact-legacy

**Version:** 2.5.6 | **Executables:** Multiple `.bat` files

Legacy Ruby-based Pact tools for backwards compatibility.

```powershell
choco install pact-legacy
```

**Included Tools:**

- `pact-broker.bat` - Legacy broker client
- `pact-mock-service.bat` - Legacy mock service
- `pact-provider-verifier.bat` - Legacy provider verifier
- `pact-stub-service.bat` - Legacy stub service
- `pact-message.bat` - Message pact support
- `pactflow.bat` - PactFlow CLI

**Links:** [GitHub](https://github.com/pact-foundation/ruby-standalone) | [Documentation](https://docs.pact.io)

## 🏗️ Supported Platforms

| OS      | Architecture | Supported |
|---------|-------------|-----------|
| Windows | x86_64      | ✅        |
| Windows | ARM64       | ✅        |
| Windows | x86 (32-bit)| ❌        |

## 📚 Additional Resources

- **[Pact Documentation](https://docs.pact.io)** - Comprehensive guides and tutorials
- **[Getting Started](https://docs.pact.io/getting_started/)** - New to Pact? Start here
- **[Implementation Guides](https://docs.pact.io/implementation_guides/)** - Language-specific guides
- **[Pact Broker](https://docs.pact.io/pact_broker/)** - Contract repository and workflow
- **[Plugins](https://docs.pact.io/plugins/)** - Extend Pact with custom protocols

## 🤝 Contributing

Issues and contributions welcome! Please visit the individual tool repositories for specific issues, or the [main repository](https://github.com/YOU54F/choco) for packaging-related issues.

## Known Issues

- Running the Pact-Ruby-Standalone based tools will fail if run from outside of Chocos install directory (usually C:) - see [workflow](https://github.com/YOU54F/choco/blob/013efb54cbef6f37c111b7849293a3f847d9064f/.github/workflows/ci.yml)
