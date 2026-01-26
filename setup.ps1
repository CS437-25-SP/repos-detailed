# Setup script for project_dataset (PowerShell version)
# This script downloads/clones all required repositories for the SOLID principles analysis project
# Usage: .\setup.ps1

$ErrorActionPreference = "Stop"

# Repository configurations
# Format: @{Url="github_org/repo_name"; Path="local_directory"}
$Repos = @(
    @{Url="darkreader/darkreader"; Path="darkreader\darkreader"},
    @{Url="fasterxml/jackson-dataformat-xml"; Path="fasterxml\jackson-dataformat-xml"},
    @{Url="jqlang/jq"; Path="jqlang\jq"},
    @{Url="nlohmann/json"; Path="nlohmann\json"},
    @{Url="psf/requests"; Path="psf\requests"},
    @{Url="pallets/flask"; Path="pallets\flask"}
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Project Dataset Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will clone the following repositories:" -ForegroundColor White
Write-Host "  1. Dark Reader (TypeScript)" -ForegroundColor White
Write-Host "  2. Jackson Dataformat XML (Java)" -ForegroundColor White
Write-Host "  3. jq (C)" -ForegroundColor White
Write-Host "  4. nlohmann/json (C++)" -ForegroundColor White
Write-Host "  5. Requests (Python)" -ForegroundColor White
Write-Host "  6. Flask (Python)" -ForegroundColor White
Write-Host ""

# Check if git is installed
try {
    $null = Get-Command git -ErrorAction Stop
    Write-Host "✓ Git is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Error: git is not installed" -ForegroundColor Red
    Write-Host "Please install git first: https://git-scm.com/downloads" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Function to clone or update a repository
function Clone-Repo {
    param(
        [string]$RepoUrl,
        [string]$LocalPath,
        [string]$RepoName
    )
    
    $fullPath = Join-Path $PSScriptRoot $LocalPath
    
    if (Test-Path $fullPath) {
        $gitPath = Join-Path $fullPath ".git"
        if (Test-Path $gitPath) {
            Write-Host "→ Repository $RepoName already exists" -ForegroundColor Yellow
            $response = Read-Host "  Update it? (y/n) [y]"
            if ($response -eq "" -or $response -eq "y" -or $response -eq "Y") {
                Write-Host "  Updating $RepoName..." -ForegroundColor Cyan
                Push-Location $fullPath
                try {
                    git pull --rebase
                    Write-Host "  ✓ $RepoName updated" -ForegroundColor Green
                } catch {
                    Write-Host "  Warning: Could not update (may have local changes)" -ForegroundColor Yellow
                }
                Pop-Location
            } else {
                Write-Host "  Skipping $RepoName" -ForegroundColor Yellow
            }
        } else {
            Write-Host "→ Directory $LocalPath exists but is not a git repository" -ForegroundColor Yellow
            $response = Read-Host "  Remove it and clone fresh? (y/n) [n]"
            if ($response -eq "y" -or $response -eq "Y") {
                Remove-Item -Recurse -Force $fullPath
                Write-Host "  Cloning $RepoName..." -ForegroundColor Cyan
                git clone "https://github.com/$RepoUrl.git" $fullPath
                Write-Host "  ✓ $RepoName cloned" -ForegroundColor Green
            } else {
                Write-Host "  Skipping $RepoName" -ForegroundColor Yellow
            }
        }
    } else {
        # Create parent directory if it doesn't exist
        $parentDir = Split-Path $fullPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        Write-Host "→ Cloning $RepoName..." -ForegroundColor Cyan
        git clone "https://github.com/$RepoUrl.git" $fullPath
        Write-Host "  ✓ $RepoName cloned successfully" -ForegroundColor Green
    }
}

# Clone all repositories
foreach ($repo in $Repos) {
    $repoName = Split-Path $repo.Path -Leaf
    Clone-Repo -RepoUrl $repo.Url -LocalPath $repo.Path -RepoName $repoName
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "All repositories have been downloaded to:" -ForegroundColor White
foreach ($repo in $Repos) {
    Write-Host "  • $($repo.Path)" -ForegroundColor White
}
Write-Host ""
Write-Host "You can now start analyzing the codebases for SOLID principles violations." -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Read the README.md files in each repository" -ForegroundColor White
Write-Host "  2. Review repo_structure.md for project overview" -ForegroundColor White
Write-Host "  3. Start your analysis!" -ForegroundColor White
Write-Host ""