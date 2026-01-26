# Project Dataset - SOLID Principles & Design Pattern Analysis

This repository contains a collection of open-source projects for analyzing SOLID principles violations and design pattern implementations across different programming languages.

## Quick Start

### For Students

1. Clone this repository:
   ```bash
   git clone <your-repo-url> project_dataset
   cd project_dataset
   ```

2. Run the setup script to download all required repositories:

   **On macOS/Linux:**
   ```bash
   ./setup.sh
   ```

   **On Windows (PowerShell):**
   ```powershell
   .\setup.ps1
   ```

3. Start analyzing!
   - Review `repo_structure.md` for an overview of each project
   - Read the README files in each repository
   - Begin your SOLID principles and design pattern analysis

## What's Included

This dataset includes six diverse repositories:

1. **Dark Reader** (TypeScript) - Browser extension for dark mode
2. **Jackson Dataformat XML** (Java) - XML processing library
3. **jq** (C) - Command-line JSON processor
4. **nlohmann/json** (C++) - Modern C++ JSON library
5. **Requests** (Python) - Simple HTTP library for Python
6. **Flask** (Python) - Lightweight web application framework

## Repository Structure

```
project_dataset/
├── README.md                    # This file
├── repo_structure.md            # Detailed overview of each repository
├── setup.sh                     # Setup script for macOS/Linux
├── setup.ps1                    # Setup script for Windows
├── darkreader/
│   └── darkreader/              # TypeScript project
├── fasterxml/
│   └── jackson-dataformat-xml/  # Java project
├── jqlang/
│   └── jq/                      # C project
├── nlohmann/
│   └── json/                    # C++ project
├── psf/
│   └── requests/                # Python HTTP library
└── pallets/
    └── flask/                   # Python web framework
```

## Setup Script Features

The setup script (`setup.sh` or `setup.ps1`) will:

- Check if git is installed
- Clone all six repositories from GitHub
- Handle existing repositories (asks if you want to update)
- Create necessary directories automatically
- Provide clear progress feedback

## Manual Setup (Alternative)

If you prefer to clone repositories manually:

```bash
# Create directories
mkdir -p darkreader fasterxml jqlang nlohmann psf pallets

# Clone repositories
git clone https://github.com/darkreader/darkreader.git darkreader/darkreader
git clone https://github.com/fasterxml/jackson-dataformat-xml.git fasterxml/jackson-dataformat-xml
git clone https://github.com/jqlang/jq.git jqlang/jq
git clone https://github.com/nlohmann/json.git nlohmann/json
git clone https://github.com/psf/requests.git psf/requests
git clone https://github.com/pallets/flask.git pallets/flask
```

## Requirements

- **Git** - Required for cloning repositories
  - Install: https://git-scm.com/downloads
- **Internet connection** - Required to download repositories from GitHub

## Analysis Workflow

See `repo_structure.md` for:

- Detailed project structure of each repository
- Build and test commands
- Analysis workflow recommendations
- Testing strategies

## Troubleshooting

### Setup script fails
- Ensure git is installed: `git --version`
- Check your internet connection
- Verify you have write permissions in the directory

### Repository already exists
- The script will ask if you want to update existing repositories
- Choose 'y' to update, 'n' to skip

### Permission denied on setup.sh
- Make it executable: `chmod +x setup.sh`

## Contributing

This is a learning dataset. Feel free to:

- Add your analysis notes
- Document findings
- Share improvements to the setup process

## License

Each repository maintains its own license. Please refer to individual repository LICENSE files for details.

| Repository | License |
|------------|---------|
| Dark Reader | MIT |
| Jackson Dataformat XML | Apache-2.0 |
| jq | MIT |
| nlohmann/json | MIT |
| Requests | Apache-2.0 |
| Flask | BSD 3-Clause |