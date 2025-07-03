# ReScript Relay PPX Makefile

.PHONY: help deps build clean rebuild test dev-setup build-release check env

# Default target - just build the binary like before
all: build

# Show help
help:
	@echo "ReScript Relay PPX Build Commands:"
	@echo ""
	@echo "Main Commands:"
	@echo "  build         - Build the PPX executable (default)"
	@echo "  rebuild       - Clean and build from scratch"
	@echo "  clean         - Clean build artifacts"
	@echo ""
	@echo "Setup:"
	@echo "  dev-setup     - Set up development environment (OCaml 4.14 + dependencies)"
	@echo "  deps          - Install project dependencies only"
	@echo ""
	@echo "Release:"
	@echo "  build-release - Build with release profile"
	@echo ""
	@echo "Utilities:"
	@echo "  check         - Check if binary builds and works"
	@echo "  env           - Show current OCaml environment"
	@echo "  test          - Run tests (if any)"
	@echo ""

# Development setup - ensures we have the right OCaml version and dependencies
dev-setup:
	@echo "Setting up development environment..."
	@if ! opam switch list | grep -q "4.14"; then \
		echo "Installing OCaml 4.14.0..."; \
		opam switch create 4.14.0 4.14.0; \
	fi
	@echo "Switching to OCaml 4.14.0..."
	@opam switch 4.14.0
	@eval $$(opam env)
	@echo "Installing dependencies..."
	@opam install . --deps-only --yes
	@echo "Development environment ready!"

# Install dependencies only
deps:
	@echo "Installing project dependencies..."
	@opam install . --deps-only --yes

# Build the project - produces binary at _build/default/bin/RescriptRelayPpxApp.exe
build:
	@echo "Building PPX..."
	@opam exec -- dune build bin/RescriptRelayPpxApp.exe
	@echo "✓ PPX binary built at: _build/default/bin/RescriptRelayPpxApp.exe"

# Build release version
build-release:
	@echo "Building PPX in release mode..."
	@opam exec -- dune build --profile release bin/RescriptRelayPpxApp.exe
	@echo "✓ Release binary built at: _build/default/bin/RescriptRelayPpxApp.exe"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@opam exec -- dune clean
	@echo "Clean complete!"

# Clean and rebuild
rebuild: clean build

# Run tests (placeholder for when tests are added)
test:
	@echo "Running tests..."
	@if [ -d "__tests__" ]; then \
		echo "No test runner configured yet"; \
	else \
		echo "No tests found"; \
	fi

# Check if the binary builds and works
check:
	@echo "Checking PPX build..."
	@opam exec -- dune build bin/RescriptRelayPpxApp.exe
	@echo "✓ Build successful"
	@if [ -f "_build/default/bin/RescriptRelayPpxApp.exe" ]; then \
		echo "✓ Binary available at: _build/default/bin/RescriptRelayPpxApp.exe"; \
		_build/default/bin/RescriptRelayPpxApp.exe --help | head -1; \
	else \
		echo "✗ Binary not found"; \
		exit 1; \
	fi

# Show current OCaml environment
env:
	@echo "Current OCaml environment:"
	@echo "OCaml version: $$(ocaml --version)"
	@echo "Opam switch: $$(opam switch show)"
	@echo "Dune version: $$(opam exec -- dune --version)" 