# DataLink Client Installation Guide

This guide explains how to install DataLink Client through various methods.

## Option 1: Package Manager Installation (Recommended)

### Debian/Ubuntu (.deb package)

1. **Install from pre-built package:**
   ```sh
   # Download the .deb package
   wget https://github.com/ga111o/datalink_client/releases/latest/download/dtlk_1.0.0_all.deb
   
   # Install the package
   sudo dpkg -i dtlk_1.0.0_all.deb
   
   # Install dependencies if needed
   sudo apt-get install -f
   ```

2. **Configure during installation:**
   - The installer will prompt you to choose server configuration
   - Option 0: Use default server (https://datalink.ga111o.com)
   - Option 1: Enter custom server URL

### Arch Linux (AUR)

1. **Install from AUR:**
   ```sh
   # Using yay AUR helper
   yay -S dtlk
   
   # Or using paru
   paru -S dtlk
   
   # Manual installation
   git clone https://aur.archlinux.org/dtlk.git
   cd dtlk
   makepkg -si
   ```

2. **Configure during installation:**
   - Same interactive configuration as Debian package

## Option 2: Manual Installation

### From Source

1. **Clone the repository:**
   ```sh
   git clone https://github.com/ga111o/datalink_client.git
   cd datalink_client
   ```

2. **Install using Makefile:**
   ```sh
   make install
   ```
   - Interactive server configuration during installation

### Direct Installation

1. **Download and install:**
   ```sh
   # Download the script
   curl -o dtlk https://raw.githubusercontent.com/ga111o/datalink_client/main/dtlk
   
   # Make executable
   chmod +x dtlk
   
   # Install to system
   sudo cp dtlk /usr/local/bin/
   ```

## Option 3: Building Packages

### Build Debian Package

```sh
# Install build dependencies
sudo apt-get install dpkg-dev

# Build package
make package-deb

# Install built package
sudo dpkg -i dtlk_1.0.0_all.deb
```

### Build Arch Package

```sh
# Install build dependencies
sudo pacman -S base-devel

# Build package
make package-arch

# Install built package
cd packaging/arch
sudo pacman -U dtlk-1.0.0-1-any.pkg.tar.xz
```

## Verification

After installation, verify that dtlk is working:

```sh
# Check if installed
which dtlk

# View help
dtlk --help

# Test basic functionality
dtlk up --help
dtlk down --help
```

## Configuration

### Server URL Configuration

The server URL is configured during installation. You can change it later by:

1. **Reinstalling:**
   ```sh
   make uninstall
   make install
   ```

2. **Manual editing:**
   ```sh
   sudo nano /usr/local/bin/dtlk
   # Find and edit the SERVER_URL variable
   ```

### Dependencies

DataLink Client requires:
- `curl` - for HTTP requests
- `tar` - for compression/decompression

These are automatically installed as dependencies when using package managers.

## Uninstallation

### Package Manager

```sh
# Debian/Ubuntu
sudo apt-get remove dtlk

# Arch Linux
sudo pacman -R dtlk
```

### Manual

```sh
# Using Makefile
make uninstall

# Or directly
sudo rm /usr/local/bin/dtlk
```

## Troubleshooting

### Common Issues

1. **Permission denied:**
   - Make sure you have sudo privileges
   - Check if the script is executable: `ls -l /usr/local/bin/dtlk`

2. **Command not found:**
   - Check if `/usr/local/bin` is in your PATH: `echo $PATH`
   - Try running with full path: `/usr/local/bin/dtlk`

3. **Missing dependencies:**
   - Install curl: `sudo apt install curl` or `sudo pacman -S curl`
   - Install tar: Usually pre-installed on most systems

4. **Server connection issues:**
   - Check your internet connection
   - Verify the server URL is correct
   - Check if the server is accessible: `curl -I https://datalink.ga111o.com`

### Getting Help

For issues and support:
- Check the [GitHub Issues](https://github.com/ga111o/datalink_client/issues)
- Read the [README](README.md) for usage information
- Contact: ga111o@proton.me 