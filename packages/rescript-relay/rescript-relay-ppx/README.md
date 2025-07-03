# ReScript Relay PPX

A preprocessor for GraphQL in ReScript Relay projects.

## Quick Start

The easiest way to work with this project is using the provided Makefile:

```bash
# First time setup (installs OCaml 4.14 + dependencies)
make dev-setup

# Build the PPX binary (same as before with esy)
make build

# Check everything is working
make check

# See all available commands
make help
```

**The binary is built at `_build/default/bin/RescriptRelayPpxApp.exe` - exactly the same location and name as before with esy.**

## Development Setup

This project uses standard OCaml tooling with opam instead of esy, but produces the exact same binary at the same location.

### Prerequisites

- OCaml 4.14.0 or later
- opam 2.0 or later
- dune 3.3.1 or later

### Available Make Commands

| Command              | Description                                                |
| -------------------- | ---------------------------------------------------------- |
| `make build`         | Build the PPX executable (default - same as `make`)        |
| `make rebuild`       | Clean and build from scratch                               |
| `make clean`         | Clean build artifacts                                      |
| `make dev-setup`     | Set up development environment (OCaml 4.14 + dependencies) |
| `make deps`          | Install project dependencies only                          |
| `make build-release` | Build with release profile                                 |
| `make check`         | Verify binary builds and works                             |
| `make env`           | Show current OCaml environment                             |
| `make help`          | Show all available commands                                |

### Manual Building (if you prefer opam directly)

```bash
# Install dependencies
opam install . --deps-only

# Build the PPX (produces _build/default/bin/RescriptRelayPpxApp.exe)
opam exec -- dune build bin/RescriptRelayPpxApp.exe

# Build for release (with static linking on Linux)
opam exec -- dune build --profile release-static bin/RescriptRelayPpxApp.exe
```

### Development Workflow

```bash
# Quick development cycle
make rebuild      # clean + build

# Build in watch mode (manual)
opam exec -- dune build --watch

# Run tests (if any)
make test
```

### Binary Location

The PPX binary is built at **`_build/default/bin/RescriptRelayPpxApp.exe`** - exactly the same location and filename as the original esy setup. No installation required.

### CI

The project uses GitHub Actions with `setup-ocaml` for reliable cross-platform builds with automatic caching. The setup supports:

- Linux (with static linking)
- macOS
- Windows

## Dependencies

- **ppxlib**: PPX framework
- **graphql_parser**: GraphQL parsing
- **dune**: Build system

## Migration from esy

This project was migrated from esy to standard opam tooling for better CI reliability and ecosystem compatibility. **The functionality and binary location remain exactly the same** - only the build tooling changed.
