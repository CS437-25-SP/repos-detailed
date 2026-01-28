# Run test suites for all downloaded repositories (PowerShell).
# Usage: .\run_tests.ps1 [repo1] [repo2] ...
#   Examples:
#     .\run_tests.ps1              # Run all repos
#     .\run_tests.ps1 axios flask  # Run only axios and flask
#     .\run_tests.ps1 expressjs    # Run only expressjs
#
# Valid repo names: axios, expressjs, iamkun, yhirose, requests, flask, elastic

$ErrorActionPreference = "Stop"

$RootDir = $PSScriptRoot

# Parse command-line arguments for specific repos
$SelectedRepos = $args
$RunAll = $true
if ($SelectedRepos.Count -gt 0) {
    $RunAll = $false
    
    # Normalize repo names (allow variations)
    $repoMap = @{
        "axios" = "axios"
        "express" = "expressjs"
        "expressjs" = "expressjs"
        "dayjs" = "iamkun"
        "iamkun" = "iamkun"
        "cpp-httplib" = "yhirose"
        "yhirose" = "yhirose"
        "requests" = "psf/requests"
        "flask" = "pallets/flask"
        "elastic" = "elastic"
        "elasticsearch" = "elastic"
    }
    
    # Validate and normalize selected repos
    $ValidatedRepos = @()
    foreach ($repo in $SelectedRepos) {
        if ($repoMap.ContainsKey($repo)) {
            $ValidatedRepos += $repoMap[$repo]
        } else {
            Write-Host "✗ Unknown repo: $repo" -ForegroundColor Red
            Write-Host "Valid repos: axios, expressjs, iamkun, yhirose, requests, flask, elastic" -ForegroundColor Yellow
            exit 1
        }
    }
    $SelectedRepos = $ValidatedRepos
}

# Helper function to check if a repo should be run
function Should-RunRepo($Repo) {
    if ($RunAll) { return $true }
    return $SelectedRepos -contains $Repo
}

function Write-Section($Name) {
    Write-Host "==> $Name" -ForegroundColor Cyan
}

function Command-Exists($Cmd) {
    return [bool](Get-Command $Cmd -ErrorAction SilentlyContinue)
}

$passed = 0
$failed = 0
$skipped = 0

function Pass() { Write-Host "PASS`n" -ForegroundColor Green; $script:passed++ }
function Fail() { Write-Host "FAIL`n" -ForegroundColor Red; $script:failed++ }
function Skip($Reason) { Write-Host "SKIP - $Reason`n" -ForegroundColor Yellow; $script:skipped++ }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Project Dataset - Run Tests" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if (-not (Command-Exists git)) {
    Write-Host "✗ git is not installed." -ForegroundColor Red
    exit 1
}

$hasNode = Command-Exists node
$hasPython = Command-Exists python
$hasPython3 = Command-Exists python3

if (-not $hasNode) { Write-Host "⚠ node is not installed. Node-based repos will be skipped." -ForegroundColor Yellow }
if (-not ($hasPython -or $hasPython3)) { Write-Host "⚠ python is not installed. Python-based repos will be skipped." -ForegroundColor Yellow }

function Get-PythonCmd() {
    if (Command-Exists python3) { return "python3" }
    if (Command-Exists python) { return "python" }
    return $null
}

$py = Get-PythonCmd

# 1) Axios
if (Should-RunRepo "axios") {
    Write-Section "axios (npm test)"
    try {
        if (-not $hasNode) { Skip "node missing"; }
        elseif (-not (Test-Path (Join-Path $RootDir "axios\\package.json"))) { Skip "axios not downloaded"; }
        else {
            Push-Location (Join-Path $RootDir "axios")
            if (-not (Test-Path (Join-Path $PWD "node_modules"))) {
                Write-Host "Installing dependencies (first run)..." -ForegroundColor Yellow
                if (Test-Path (Join-Path $PWD "package-lock.json")) { npm ci } else { npm install }
            }
            npm test
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 2) Express
if (Should-RunRepo "expressjs") {
    Write-Section "expressjs (npm test)"
    try {
        if (-not $hasNode) { Skip "node missing"; }
        elseif (-not (Test-Path (Join-Path $RootDir "expressjs\\package.json"))) { Skip "expressjs not downloaded"; }
        else {
            Push-Location (Join-Path $RootDir "expressjs")
            if (-not (Test-Path (Join-Path $PWD "node_modules"))) {
                Write-Host "Installing dependencies (first run)..." -ForegroundColor Yellow
                if (Test-Path (Join-Path $PWD "package-lock.json")) { npm ci } else { npm install }
            }
            npm test
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 3) Day.js
if (Should-RunRepo "iamkun") {
    Write-Section "iamkun/dayjs (npm test)"
    try {
        if (-not $hasNode) { Skip "node missing"; }
        elseif (-not (Test-Path (Join-Path $RootDir "iamkun\\package.json"))) { Skip "iamkun/dayjs not downloaded"; }
        else {
            Push-Location (Join-Path $RootDir "iamkun")
            if (-not (Test-Path (Join-Path $PWD "node_modules"))) {
                Write-Host "Installing dependencies (first run)..." -ForegroundColor Yellow
                if (Test-Path (Join-Path $PWD "package-lock.json")) { npm ci } else { npm install }
            }
            npm test
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 4) cpp-httplib
if (Should-RunRepo "yhirose") {
    Write-Section "yhirose/cpp-httplib (cmake build + ctest if available)"
    try {
        if (-not (Test-Path (Join-Path $RootDir "yhirose\\CMakeLists.txt"))) { Skip "yhirose/cpp-httplib not downloaded"; }
        elseif (-not (Command-Exists cmake)) { Skip "cmake missing"; }
        else {
            $buildDir = Join-Path $RootDir "yhirose\\build"
            if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
            New-Item -ItemType Directory -Path $buildDir | Out-Null

            Push-Location $buildDir
            cmake ..
            cmake --build .
            if (Command-Exists ctest) {
                ctest --output-on-failure
            } else {
                Write-Host "ctest not found; built successfully" -ForegroundColor Yellow
            }
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 5) Requests (Python)
if (Should-RunRepo "psf/requests") {
    Write-Section "psf/requests (pytest)"
    try {
        if (-not $py) { Skip "python missing"; }
        elseif (-not (Test-Path (Join-Path $RootDir "psf\\requests\\pyproject.toml"))) { Skip "psf/requests not downloaded"; }
        else {
            Push-Location (Join-Path $RootDir "psf\\requests")
            & $py -m venv .venv
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pip install -U pip
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pip install -e ".[dev]"
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pytest -q
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 6) Flask (Python)
if (Should-RunRepo "pallets/flask") {
    Write-Section "pallets/flask (pytest)"
    try {
        if (-not $py) { Skip "python missing"; }
        elseif (-not (Test-Path (Join-Path $RootDir "pallets\\flask\\pyproject.toml"))) { Skip "pallets/flask not downloaded"; }
        else {
            Push-Location (Join-Path $RootDir "pallets\\flask")
            & $py -m venv .venv
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pip install -U pip
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pip install -e ".[dev]"
            & (Join-Path $PWD ".venv\\Scripts\\python.exe") -m pytest -q
            Pop-Location
            Pass
        }
    } catch { Fail; try { Pop-Location } catch {} }
}

# 7) Elasticsearch (optional / heavy)
if (Should-RunRepo "elastic") {
    Write-Section "elastic/elasticsearch (optional / heavy)"
    if (Test-Path (Join-Path $RootDir "elastic")) {
        Write-Host "NOTE: Elasticsearch tests are intentionally skipped by default (very large/slow)." -ForegroundColor Yellow
        Write-Host "      If you really want them, run inside elastic/: `./gradlew test`" -ForegroundColor Yellow
        Skip "elasticsearch (optional/heavy)"
    } else {
        Skip "elasticsearch directory not present (run setup.sh/setup.ps1 to download)"
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ("Summary: {0} passed, {1} failed, {2} skipped" -f $passed, $failed, $skipped) -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

if ($failed -ne 0) { exit 1 }

