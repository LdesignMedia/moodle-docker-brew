#!/usr/bin/env bash
# Don't use set -e as it might exit on non-critical errors
set -uo pipefail

echo "========================================="
echo "Grunt Watch Setup"
echo "========================================="

# Use a writable NVM_DIR for www-data
export NVM_DIR="/var/www/html/.nvm"
mkdir -p "$NVM_DIR"

echo "Checking for NVM..."
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "Installing NVM..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/nvm.sh -o "$NVM_DIR/nvm.sh"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/bash_completion -o "$NVM_DIR/bash_completion" || true
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$NVM_DIR/nvm.sh" https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/nvm.sh
    wget -qO "$NVM_DIR/bash_completion" https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/bash_completion || true
  else
    echo "ERROR: curl or wget required to install nvm" >&2
    exit 1
  fi
  echo "NVM installed successfully"
else
  echo "NVM already installed"
fi

# shellcheck disable=SC1090
. "$NVM_DIR/nvm.sh"

cd /var/www/html

# Choose Node version from package.json engines if present
NODEVER="20"
if [ -f package.json ]; then
  echo "Checking package.json for Node version requirements..."
  # Extract the node version requirement and check for specific versions
  NODE_REQ=$(grep -oE '"node"[[:space:]]*:[[:space:]]*"[^"]*"' package.json 2>/dev/null | head -1)
  echo "Found Node requirement: $NODE_REQ"

  if echo "$NODE_REQ" | grep -qE '22\.|>=22' 2>/dev/null; then
    NODEVER="22"
  elif echo "$NODE_REQ" | grep -qE '20\.|>=20' 2>/dev/null; then
    NODEVER="20"
  elif echo "$NODE_REQ" | grep -qE '18\.|>=18' 2>/dev/null; then
    NODEVER="18"
  elif echo "$NODE_REQ" | grep -qE '16\.|>=16' 2>/dev/null; then
    NODEVER="16"
  fi
fi

echo "Installing Node $NODEVER..."
nvm install "$NODEVER" 2>&1
nvm use "$NODEVER"

echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"

# Ensure grunt-cli and dependencies
echo "Installing grunt-cli globally..."
npm install -g grunt-cli 2>&1

echo "Installing project dependencies..."
if [ -f package-lock.json ]; then
  echo "Using npm ci (from package-lock.json)..."
  npm ci 2>&1
else
  echo "Using npm install..."
  npm install 2>&1
fi

echo "========================================="

echo "Starting grunt watch (Ctrl+C to stop)"
echo "========================================="

# Trap SIGINT (Ctrl+C) to ensure clean exit
trap 'echo "Stopping grunt watch..."; exit 0' INT TERM

# Run grunt watch with unbuffered output
grunt watch
