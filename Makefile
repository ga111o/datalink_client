# DataLink Client Makefile

PROGRAM_NAME = dtlk
INSTALL_DIR = /usr/local/bin
MAN_DIR = /usr/local/share/man/man1

.PHONY: all install uninstall clean test help package-deb package-arch package-all package-clean

all: help

help:
	@echo "DataLink Client - Installation Management"
	@echo ""
	@echo "Available targets:"
	@echo "  install      - Install dtlk to $(INSTALL_DIR)"
	@echo "  uninstall    - Remove dtlk from $(INSTALL_DIR)"
	@echo "  test         - Run basic functionality tests"
	@echo "  clean        - Clean up temporary and package files"
	@echo "  package-deb  - Build Debian (.deb) package"
	@echo "  package-arch - Build Arch Linux package"
	@echo "  package-all  - Build all packages"
	@echo "  package-clean- Clean package build artifacts"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Installation and packaging require sudo privileges."

install: $(PROGRAM_NAME)
	@echo "DataLink Client Installation"
	@echo "============================"
	@echo ""
	@echo "Server Configuration:"
	@echo "  0) Use default server (https://datalink.ga111o.com)"
	@echo "  1) Configure custom server URL"
	@echo ""
	@read -p "Please choose an option [0]: " choice; \
	choice=$${choice:-0}; \
	if [ "$$choice" = "1" ]; then \
		read -p "Enter your server URL (e.g., https://your-server.com): " server_url; \
		if [ -z "$$server_url" ]; then \
			echo "Error: Server URL cannot be empty"; \
			exit 1; \
		fi; \
		echo "Configuring $(PROGRAM_NAME) with custom server: $$server_url"; \
		sed "s|SERVER_URL=\"[^\"]*\"|SERVER_URL=\"$$server_url\"|g" $(PROGRAM_NAME) > $(PROGRAM_NAME).tmp; \
		sudo cp $(PROGRAM_NAME).tmp $(INSTALL_DIR)/$(PROGRAM_NAME); \
		rm -f $(PROGRAM_NAME).tmp; \
	elif [ "$$choice" = "0" ]; then \
		echo "Using default server configuration"; \
		sudo cp $(PROGRAM_NAME) $(INSTALL_DIR)/$(PROGRAM_NAME); \
	else \
		echo "Invalid choice. Installation cancelled."; \
		exit 1; \
	fi
	@sudo chmod 755 $(INSTALL_DIR)/$(PROGRAM_NAME)
	@echo ""
	@echo "Installation completed successfully!"
	@echo "You can now use '$(PROGRAM_NAME)' from anywhere in your system."
	@echo "Run '$(PROGRAM_NAME) --help' for usage information."
	@echo ""
	@echo ""

uninstall:
	@echo "Removing $(PROGRAM_NAME) from $(INSTALL_DIR)..."
	@sudo rm -f $(INSTALL_DIR)/$(PROGRAM_NAME)
	@echo "Uninstallation completed."

test: $(PROGRAM_NAME)
	@echo "Running basic tests for $(PROGRAM_NAME)..."
	@echo ""
	@echo "Testing help command:"
	@./$(PROGRAM_NAME) --help
	@echo ""
	@echo "Testing dependency check:"
	@./$(PROGRAM_NAME) up 2>/dev/null || echo "Dependency check working (expected error)"
	@echo ""
	@echo "Testing invalid command:"
	@./$(PROGRAM_NAME) invalid 2>/dev/null || echo "Error handling working (expected error)"
	@echo ""
	@echo "Basic tests completed successfully!"

clean: package-clean
	@echo "Cleaning up temporary files..."
	@rm -f /tmp/dtlk_*
	@echo "Cleanup completed."

dev-test: $(PROGRAM_NAME)
	@echo "Setting up development test environment..."
	@mkdir -p test_files
	@echo "Hello, DataLink!" > test_files/hello.txt
	@echo "This is a test file." > test_files/test.txt
	@mkdir -p test_files/subdir
	@echo "Subdirectory content" > test_files/subdir/nested.txt
	@echo ""
	@echo "Test files created in 'test_files' directory"
	@echo "You can now test with: ./$(PROGRAM_NAME) up test_files/"

dev-clean:
	@echo "Cleaning up development test files..."
	@rm -rf test_files
	@echo "Development cleanup completed."

# Package building targets
package-deb: $(PROGRAM_NAME)
	@echo "Building Debian package..."
	@if ! command -v dpkg-deb >/dev/null 2>&1; then \
		echo "Error: dpkg-deb not found. Please install dpkg-dev package."; \
		exit 1; \
	fi
	@mkdir -p packaging/debian/usr/local/bin
	@cp $(PROGRAM_NAME) packaging/debian/usr/local/bin/
	@chmod 755 packaging/debian/usr/local/bin/$(PROGRAM_NAME)
	@VERSION=$$(cat VERSION); \
	sed -i "s/Version: .*/Version: $$VERSION/" packaging/debian/DEBIAN/control; \
	dpkg-deb --build packaging/debian "$(PROGRAM_NAME)_$${VERSION}_all.deb"
	@echo "Debian package created: $(PROGRAM_NAME)_$$(cat VERSION)_all.deb"

package-arch: $(PROGRAM_NAME)
	@echo "Building Arch Linux package..."
	@if ! command -v makepkg >/dev/null 2>&1; then \
		echo "Error: makepkg not found. Please install base-devel package."; \
		exit 1; \
	fi
	@cd packaging/arch && \
	VERSION=$$(cat ../../VERSION); \
	sed -i "s/pkgver=.*/pkgver=$$VERSION/" PKGBUILD && \
	makepkg -f
	@echo "Arch package created in packaging/arch/"

package-all: package-deb package-arch
	@echo "All packages built successfully!"

# Clean package build artifacts
package-clean:
	@echo "Cleaning package build artifacts..."
	@rm -f *.deb
	@rm -rf packaging/debian/usr
	@cd packaging/arch && rm -f *.pkg.tar.* && rm -rf pkg/ src/
	@echo "Package cleanup completed." 