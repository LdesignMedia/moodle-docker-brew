#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR=$(dscl . -read /Users/$(whoami) NFSHomeDirectory | awk '{print $NF}')

if [ ! -d "$HOME_DIR/.moodle-docker-brew ]; then

echo "Installing (moodle-docker-brew)"
DESTDIR="$HOME_DIR/.moodle-docker-brew"

echo "Installing to: $DESTDIR"

# Check if unzip is installed
if ! command -v unzip >/dev/null 2>&1; then
  echo "Error: unzip is required to extract the Moodle version."
  exit 1
fi

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required."
  exit 1
fi

# Search for the application in the /Applications directory
if [ ! -d "/Applications/OrbStack.app" ]; then
  echo "Error: Orbstack is not installed, please install it first."
  exit 1
fi

echo "Cloning (moodle-docker-brew)"
git clone git@github.com:LdesignMedia/moodle-docker-brew.git "$DESTDIR"

if [ -d "$DESTDIR" ]; then
  cd "$DESTDIR" || exit

  # Installing dependencies.
  git submodule update --init --recursive
  chmod +x "$DESTDIR/moodle-docker"
else
  echo "Error: installing failed.."
  exit 1
fi

echo "Finished installing dependencies"

else 
  bash $HOME_DIR/.moodle-docker-brew/moodle-docker "$@"
fi
