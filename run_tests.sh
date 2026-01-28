#!/bin/bash
# Run test suites for all downloaded repositories.
# Usage: ./run_tests.sh [repo1] [repo2] ...
#   Examples:
#     ./run_tests.sh              # Run all repos
#     ./run_tests.sh axios flask  # Run only axios and flask
#     ./run_tests.sh expressjs    # Run only expressjs
#
# Valid repo names: axios, expressjs, iamkun, yhirose, requests, flask, elastic

set -eo pipefail

# Parse command-line arguments for specific repos
SELECTED_REPOS=()
for arg in "$@"; do
  [[ -n "$arg" ]] && SELECTED_REPOS+=("$arg")
done

RUN_ALL=true
if [[ ${#SELECTED_REPOS[@]} -gt 0 ]]; then
  RUN_ALL=false
  
  # Normalize repo names (allow variations) - using case statement for compatibility
  normalize_repo() {
    case "$1" in
      axios) echo "axios" ;;
      express|expressjs) echo "expressjs" ;;
      dayjs|iamkun) echo "iamkun" ;;
      cpp-httplib|yhirose) echo "yhirose" ;;
      requests) echo "psf/requests" ;;
      flask) echo "pallets/flask" ;;
      elastic|elasticsearch) echo "elastic" ;;
      *) echo "" ;;
    esac
  }
  
  # Validate and normalize selected repos
  VALIDATED_REPOS=()
  for repo in "${SELECTED_REPOS[@]}"; do
    normalized=$(normalize_repo "$repo")
    if [[ -n "$normalized" ]]; then
      VALIDATED_REPOS+=("$normalized")
    else
      echo -e "${RED}✗ Unknown repo: $repo${NC}"
      echo "Valid repos: axios, expressjs, iamkun, yhirose, requests, flask, elastic"
      exit 1
    fi
  done
  SELECTED_REPOS=("${VALIDATED_REPOS[@]}")
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

# Make tool caches local to this repo to avoid permission issues on lab machines.
export NPM_CONFIG_CACHE="${NPM_CONFIG_CACHE:-$ROOT_DIR/.cache/npm}"
export PIP_CACHE_DIR="${PIP_CACHE_DIR:-$ROOT_DIR/.cache/pip}"
mkdir -p "$NPM_CONFIG_CACHE" "$PIP_CACHE_DIR"

run_section() {
  local name="$1"
  echo -e "${BLUE}==> ${name}${NC}"
}

record_pass() { echo -e "${GREEN}PASS${NC}\n"; PASSED=$((PASSED+1)); }
record_fail() { echo -e "${RED}FAIL${NC}\n"; FAILED=$((FAILED+1)); }
record_skip() { echo -e "${YELLOW}SKIP${NC} - $1\n"; SKIPPED=$((SKIPPED+1)); }

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Project Dataset - Run Tests${NC}"
echo -e "${BLUE}========================================${NC}\n"

if ! command -v git >/dev/null 2>&1; then
  echo -e "${RED}✗ git is not installed.${NC}"
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo -e "${YELLOW}⚠ node is not installed. Node-based repos will be skipped.${NC}"
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${YELLOW}⚠ python3 is not installed. Python-based repos will be skipped.${NC}"
fi

echo ""

run_node_tests() {
  local dir="$1"
  local label="$2"
  local status=0

  run_section "$label"
  if ! command -v node >/dev/null 2>&1; then
    record_skip "node missing"
    return 0
  fi
  if [[ ! -f "$ROOT_DIR/$dir/package.json" ]]; then
    record_skip "$dir not downloaded"
    return 0
  fi

  set +e
  (
    cd "$ROOT_DIR/$dir" || exit 1
    if [[ ! -d node_modules ]]; then
      echo -e "${YELLOW}Installing dependencies (first run)...${NC}"
      if [[ -f package-lock.json ]]; then
        npm ci || exit 1
      else
        npm install || exit 1
      fi
    fi
    npm test
  )
  status=$?
  set -e

  if [[ "$status" -eq 0 ]]; then record_pass; else record_fail; fi
}

run_pytest() {
  local dir="$1"
  local label="$2"
  local status=0

  run_section "$label"
  if ! command -v python3 >/dev/null 2>&1; then
    record_skip "python3 missing"
    return 0
  fi
  if [[ ! -f "$ROOT_DIR/$dir/pyproject.toml" && ! -f "$ROOT_DIR/$dir/setup.py" ]]; then
    record_skip "$dir not downloaded"
    return 0
  fi

  set +e
  (
    cd "$ROOT_DIR/$dir" || exit 1
    python3 -m venv .venv || exit 1
    # shellcheck disable=SC1091
    source .venv/bin/activate || exit 1
    python -m pip install -U pip || exit 1
    python -m pip install -e ".[dev]" || exit 1
    python -m pytest -q
  )
  status=$?
  set -e

  if [[ "$status" -eq 0 ]]; then record_pass; else record_fail; fi
}

run_cmake_ctest() {
  local dir="$1"
  local label="$2"
  local status=0

  run_section "$label"
  if [[ ! -f "$ROOT_DIR/$dir/CMakeLists.txt" ]]; then
    record_skip "$dir not downloaded"
    return 0
  fi
  if ! command -v cmake >/dev/null 2>&1; then
    record_skip "cmake missing"
    return 0
  fi

  set +e
  (
    cd "$ROOT_DIR/$dir" || exit 1
    rm -rf build
    mkdir -p build
    cd build || exit 1
    cmake .. || exit 1
    cmake --build . || exit 1
    if command -v ctest >/dev/null 2>&1; then
      ctest --output-on-failure
    else
      echo "ctest not found; built successfully"
    fi
  )
  status=$?
  set -e

  if [[ "$status" -eq 0 ]]; then record_pass; else record_fail; fi
}

# Helper function to check if a repo should be run
should_run_repo() {
  local repo="$1"
  if [[ "$RUN_ALL" == "true" ]]; then
    return 0
  fi
  for selected in "${SELECTED_REPOS[@]}"; do
    if [[ "$selected" == "$repo" ]]; then
      return 0
    fi
  done
  return 1
}

# 1) Axios
if should_run_repo "axios"; then
  run_node_tests "axios" "axios (npm test)"
fi

# 2) Express
if should_run_repo "expressjs"; then
  run_node_tests "expressjs" "expressjs (npm test)"
fi

# 3) Day.js
if should_run_repo "iamkun"; then
  run_node_tests "iamkun" "iamkun/dayjs (npm test)"
fi

# 4) cpp-httplib
if should_run_repo "yhirose"; then
  run_cmake_ctest "yhirose" "yhirose/cpp-httplib (cmake build + ctest if available)"
fi

# 5) Requests (Python)
if should_run_repo "psf/requests"; then
  run_pytest "psf/requests" "psf/requests (pytest)"
fi

# 6) Flask (Python)
if should_run_repo "pallets/flask"; then
  run_pytest "pallets/flask" "pallets/flask (pytest)"
fi

# 7) Elasticsearch (optional / heavy)
if should_run_repo "elastic"; then
  if [[ -d "$ROOT_DIR/elastic" ]]; then
    echo -e "${YELLOW}NOTE:${NC} Elasticsearch tests are intentionally skipped by default (very large/slow)."
    echo -e "      If you really want them, run inside elastic/: \`./gradlew test\`\n"
    record_skip "elasticsearch (optional/heavy)"
  else
    record_skip "elasticsearch directory not present (run setup.sh to download)"
  fi
fi

echo -e "${BLUE}========================================${NC}"
echo -e "Summary: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}, ${YELLOW}${SKIPPED} skipped${NC}"
echo -e "${BLUE}========================================${NC}"

if [[ "$FAILED" -ne 0 ]]; then
  exit 1
fi

