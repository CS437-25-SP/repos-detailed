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

This dataset includes seven diverse repositories:

1. **Axios** (JavaScript) - Promise-based HTTP client
2. **Elasticsearch** (Java) - Distributed search and analytics engine
3. **Express** (JavaScript) - Fast, unopinionated web framework
4. **Day.js** (JavaScript) - Modern JavaScript date utility library
5. **cpp-httplib** (C++) - C++ HTTP library
6. **Requests** (Python) - Simple HTTP library for Python
7. **Flask** (Python) - Lightweight web application framework

## Repository Structure

```
project_dataset/
├── README.md                    # This file
├── repo_structure.md            # Detailed overview of each repository
├── setup.sh                     # Setup script for macOS/Linux
├── setup.ps1                    # Setup script for Windows
├── axios/                       # JavaScript HTTP client
├── elastic/                     # Java search engine
├── expressjs/                   # JavaScript web framework
├── iamkun/                      # JavaScript date library
├── yhirose/                     # C++ HTTP library
├── psf/
│   └── requests/                # Python HTTP library
└── pallets/
    └── flask/                   # Python web framework
```

## Setup Script Features

The setup script (`setup.sh` or `setup.ps1`) will:

- Check if git is installed
- Clone all seven repositories from GitHub
- Handle existing repositories (asks if you want to update)
- Create necessary directories automatically
- Provide clear progress feedback

## Manual Setup (Alternative)

If you prefer to clone repositories manually:

```bash
# Create directories
mkdir -p axios elastic expressjs iamkun yhirose psf pallets

# Clone repositories
git clone https://github.com/axios/axios.git axios
git clone https://github.com/elastic/elasticsearch.git elastic
git clone https://github.com/expressjs/express.git expressjs
git clone https://github.com/iamkun/dayjs.git iamkun
git clone https://github.com/yhirose/cpp-httplib.git yhirose
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


## License

Each repository maintains its own license. Please refer to individual repository LICENSE files for details.

| Repository | License |
|------------|---------|
| Axios | MIT |
| Elasticsearch | Apache-2.0 / Elastic License |
| Express | MIT |
| Day.js | MIT |
| cpp-httplib | MIT |
| Requests | Apache-2.0 |
| Flask | BSD 3-Clause |