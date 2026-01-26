#!/bin/bash
# Setup script for project_dataset
# This script downloads/clones all required repositories for the SOLID principles analysis project
# Usage: ./setup.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository configurations
# Format: "github_org/repo_name:local_directory"
REPOS=(
    "axios/axios:axios"
    "elastic/elasticsearch:elastic"
    "expressjs/express:expressjs"
    "iamkun/dayjs:iamkun"
    "yhirose/cpp-httplib:yhirose"
    "psf/requests:psf/requests"
    "pallets/flask:pallets/flask"
)

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Project Dataset Setup Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "This script will clone the following repositories:"
echo "  1. Axios (JavaScript) - Promise-based HTTP client"
echo "  2. Elasticsearch (Java) - Distributed search and analytics engine"
echo "  3. Express (JavaScript) - Fast, unopinionated web framework"
echo "  4. Day.js (JavaScript) - Modern JavaScript date utility library"
echo "  5. cpp-httplib (C++) - C++ HTTP library"
echo "  6. Requests (Python) - Simple HTTP library for Python"
echo "  7. Flask (Python) - Lightweight web application framework"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Error: git is not installed${NC}"
    echo "Please install git first: https://git-scm.com/downloads"
    exit 1
fi

echo -e "${GREEN}✓ Git is installed${NC}"
echo ""

# Function to clone or update a repository
clone_repo() {
    local repo_url=$1
    local local_path=$2
    local repo_name=$(basename "$local_path")

    if [ -d "$local_path" ]; then
        if [ -d "$local_path/.git" ]; then
            echo -e "${YELLOW}→ Repository $repo_name already exists${NC}"
            read -p "  Update it? (y/n) [y]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                echo -e "${BLUE}  Updating $repo_name...${NC}"
                cd "$local_path"
                git pull --rebase || echo -e "${YELLOW}  Warning: Could not update (may have local changes)${NC}"
                cd - > /dev/null
                echo -e "${GREEN}  ✓ $repo_name updated${NC}"
            else
                echo -e "${YELLOW}  Skipping $repo_name${NC}"
            fi
        else
            echo -e "${YELLOW}→ Directory $local_path exists but is not a git repository${NC}"
            read -p "  Remove it and clone fresh? (y/n) [n]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$local_path"
                echo -e "${BLUE}  Cloning $repo_name...${NC}"
                git clone "https://github.com/$repo_url.git" "$local_path"
                echo -e "${GREEN}  ✓ $repo_name cloned${NC}"
            else
                echo -e "${YELLOW}  Skipping $repo_name${NC}"
            fi
        fi
    else
        # Create parent directory if it doesn't exist
        mkdir -p "$(dirname "$local_path")"
        echo -e "${BLUE}→ Cloning $repo_name...${NC}"
        git clone "https://github.com/$repo_url.git" "$local_path"
        echo -e "${GREEN}  ✓ $repo_name cloned successfully${NC}"
    fi
}

# Clone all repositories
SUCCESS_COUNT=0
TOTAL_COUNT=${#REPOS[@]}

for repo_config in "${REPOS[@]}"; do
    IFS=':' read -r repo_url local_path <<< "$repo_config"
    clone_repo "$repo_url" "$local_path"
    ((SUCCESS_COUNT++)) || true
    echo ""
done

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "All repositories have been downloaded to:"
for repo_config in "${REPOS[@]}"; do
    IFS=':' read -r repo_url local_path <<< "$repo_config"
    echo "  • $local_path"
done
echo ""
echo "You can now start analyzing the codebases for SOLID principles violations."
echo ""
echo "Next steps:"
echo "  1. Read the README.md files in each repository"
echo "  2. Review repo_structure.md for project overview"
echo "  3. Start your analysis!"
echo ""