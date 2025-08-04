# DataLink Client

Command line tool for file transfer

## Features

- **Upload**: Compress files/directories to tar.gz and upload to server
- **Download**: Download and automatically extract files from server

## Requirements

- `curl` - for HTTP requests
- `tar` - for compression/decompression

The tool will automatically check for dependencies and inform you if anything is missing.

## Installation

> **💡 For detailed installation instructions, see [INSTALL.md](INSTALL.md)**

### Quick Install (Recommended)

#### Debian/Ubuntu
```sh
# Download and install .deb package
wget https://github.com/ga111o/datalink_client/releases/latest/download/dtlk_1.0.3_all.deb
sudo dpkg -i dtlk_1.0.3_all.deb
```

### From Source

1. Clone or download this repository
2. Make the script executable:
   ```sh
   chmod +x dtlk
   ```
3. Install system-wide (requires sudo):
   ```sh
   make install
   ```

During installation, you'll be prompted to configure the server:
- **Option 0** (default): Use the default server (https://datalink.ga111o.com)
- **Option 1**: Enter your custom server URL

Example installation process:
```
DataLink Client Installation
============================

Server Configuration:
  0) Use default server (https://datalink.ga111o.com)
  1) Configure custom server URL

Please choose an option [0]: 1
Enter your server URL (e.g., https://your-server.com): https://my-datalink.example.com
```

### Package Building

Build your own packages:
```sh
# Build Debian package
make package-deb

# Build Arch package  
make package-arch

# Build all packages
make package-all
```

## Usage

### Upload Files

Upload one or more files or directories:

```sh
# Upload a single file
dtlk up myfile.txt

# Upload multiple files
dtlk up file1.txt file2.txt

# Upload directories
dtlk up folder1/ folder2/

# Mixed upload
dtlk up myfile.txt myfolder/ another_file.txt
```

The tool will:
1. Compress all specified files/directories into a tar.gz archive
2. Upload to the server
3. Display an 8-digit file ID for later download

### Download Files

Download files using the 8-digit ID:

```sh
# Download to current directory
dtlk down 12345678

# Download to specific directory
dtlk down 12345678 ./downloads/

# Download to non-existent directory (will be created)
dtlk down 12345678 ./new_folder/
```

The tool will:
1. Download the file from the server
2. Automatically extract the tar.gz archive
3. Handle duplicate files by adding `_dups{number}` suffix if files already exist
4. Clean up temporary files

### Help

```sh
dtlk --help
dtlk help
dtlk -h
```

### Duplicate File Handling

When downloading files, if a file or directory with the same name already exists in the destination, the tool will automatically rename the downloaded item to avoid conflicts:

- Files: `filename.txt` → `filename_dups1.txt`, `filename_dups2.txt`, etc.
- Directories: `dirname` → `dirname_dups1`, `dirname_dups2`, etc.
- Files without extensions: `filename` → `filename_dups1`, `filename_dups2`, etc.

The tool will inform you of any renamed files during the download process.

## Configuration

### Server URL Configuration

The server URL can be configured during installation using `make install`. You can choose between:
- Default server: `https://datalink.ga111o.com`
- Custom server URL of your choice

### Manual Configuration

If you need to change the server URL after installation, you can:

1. **Edit the installed script** (requires sudo):
   ```sh
   sudo nano /usr/local/bin/dtlk
   ```
   Find and modify the `SERVER_URL` variable.

2. **Reinstall with different configuration**:
   ```sh
   make uninstall
   make install
   ```

3. **Use local copy** with modified URL:
   Edit the `dtlk` script in your local directory and run it directly:
   ```sh
   ./dtlk up myfile.txt
   ```

## Development

### Testing

Run basic functionality tests:
```sh
make test
```

Create test files for development:
```sh
make dev-test
```

Clean up test files:
```sh
make dev-clean
```

### Uninstall

Remove the installed tool:
```sh
make uninstall
```

## Server API

The tool expects a server with the following endpoints:

- **Upload**: `POST /upload`
  - Accepts multipart form data with `file` field
  - Returns JSON with `id` field containing numeric file ID

- **Download**: `GET /download/{id}`
  - Returns the uploaded file
  - Should include proper headers for file download

## Examples

### Error Cases

The tool handles various error conditions:

- Missing files/directories
- Server connection issues
- Invalid file IDs
- Failed uploads/downloads
- Missing dependencies

## License

This project is licensed under the MIT License.

## Contributing

Feel free to submit issues and enhancement requests. 
