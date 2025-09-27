#!/bin/bash -i
# Author: Luuk Verhoeven
# Date: 29.01.2023, 06:20
#
#                               `.:;+o***ooi;.`
#                                `,;o*%%&##########&*:`
#                              '+&%%%***%%%%&$$$$$$$##&i`
#                            `+$$%********%&$$$$$$$$$$$#&,
#                           ,&&%*********&$$$$$$$$$$$$$$$$:
#                          ,#$%********&$$$$$$$$$$$$$$$$$$o:
#                         .$$$$&*****%%$$$########$$$$$$$$*i:
#                         %$$##$&%**%$%.'..,::;i+*$$$$$$$$*i+.
#                        '$#&o;,&$&&$$$+;ooi;:;i*%&$$$$$$$*iii
#                        .$+::,;$$$$$$$$#$*%;`',,+#$$$$$$$oiii`
#                        .oo&%&$$$$$$$$$$%*%,'.$&:.$$$$$$$+iii`
#                        .#*+:`+$$$$$$$$$@%.,,+@@@i&$$$$$&iiii'
#                        ,*.*,`+#$$$$$$$$#@#&$@@@##$$$$$$%iii;
#                        ,,*%;+##$$$$$$$$$$$$$$$$$$$$$$$$oiioo,
#                        .$&@@##$$$$##$$$$$$$$$$$$$$$$$$$i+%*o%;
#                        .$$&&&$%$$&**$$$$$$$$$$$$$$$$$$%i+i;;;+.
#                        .$$$$$$oiii;o$$$$$$$$$$$$$$$$$$oii;i;ii,
#                        .$$$$$$$%%%$#$$$$$$$$$$$$$$$$$&iii;ii;+,
#                        '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*iiiii;ii`
#                        '$$$$$$$$$$$$$$&&&&$$$$$$$$$$&iii;;ii:'
#                         &$$$$$&&&&&$&&&$$$$$$$$$$$$#*i++ii,`
#                         o#$$$$&&$$&&$$$$$$$$$$$$$$#%+;'..`
#                         .#$$$$$$%o+%$$$$$$$$$$$$$$%+i`
#                          ;#$$$$$$$$$$$$$$$$$$$$$$*ii`
#                           :$#$$$$$$$$$$$$$$$$$&*+;i;
#                            'o#$$$$$$$$$$$$$&%oi;;;i;....'
#                              ,&#$$$$$$$$%o+i;;;iii+;...,::
#                               `;%###$%oi;;;iiiiiiii;,:;;ii`
#                                `.;ii;;;;;;i;i;;;;;;iiiiiii`
#                              `.....',+ii+*%*iiiiiiiiiiiii;
#                             ;**%%,..;$*i%$$$%;iiiiiiiiiii;
#                             ;#$$$+..i##%&$$&$*;iiiiiiiiii;
#                             `&$&$*.';%**$$$$$$o;iiiiiiiiii'
#                              +$&$&,,ioi%$$$$$$$o;iiiiiiiii: `
#                              o$&$$+oooo$$$$$$$$$+;iiiiii;;:.''
#                             '%$&$$*+o+*$$$$$$$$$$o;;;:;;:,.'.,,'
#                           `,i*&$$$%+o+&$$$$$$&&%%*oo++;:,''.:;;;;,.
#                         `'::*%o%$$&++o$$$$&%******%%o+:::io*ooo**%%o;.`
#                       ';*i:;%*%**&$o+&$&%****%%%%%oi::;+*%%%%%%%%**%%%*+:
#                     ,+%%%;:i%*%%****o%*****%%%%%*i::;+*%%******%%%%***%%%+`
#                   :*%%***;:;*%%*%%*******%%*%%*i;,;+*%%*%%%%%%%%%%%%%%***%i
#                 `o%%****%;::*%*%%o*%%%%*o+o**i;:;i*%%*%%%%%%%%%%%%%%%%%%**%.
#                 +%**%%%%%i::o%%oio%**%%%%*i:;,;;*%%**%%%%%%%%%%%%%%%%%%%*%*;'
#

# COLORS
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export CYAN=$(tput setaf 6)
export MAGENTA=$(tput setaf 5)
export RESET=$(tput sgr0)
export CURRENTDATE=$(date +%Y-%m-%d-%H-%M-%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging with colors and time.
function log {
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")]: $* ${RESET}"
}

# Exit the script function.
function abort() {
  log "${RED}Abort - $1 ${RESET}"
  exit 1
}

# Function to ask for confirmation
confirm() {
  while true; do
    read -r -p "${1:-Are you sure?} [y/N] " response
    case $response in
    [yY][eE][sS] | [yY])
      return 0
      ;;
    [nN][oO] | [nN])
      return 1
      ;;
    *)
      echo "Please answer 'yes' or 'no'."
      ;;
    esac
  done
}

# Check if the docker image is running.
function check_is_running() {
  log "Check if running ($COMPOSE_PROJECT_NAME)..."
  local container_name="$COMPOSE_PROJECT_NAME-webserver-1"

  # Check if the container is running
  if docker ps --filter "name=$container_name" --format "{{.Names}}" | grep -q "^$container_name$"; then
    log "The container $container_name is running."
  else
    abort "The container $container_name is not running."
  fi
}

function setup() {
  log ""
  log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "${CYAN}🔍 System Pre-Check${RESET}"
  log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  local errors=()
  local warnings=()

  # Check macOS
  echo -n "Checking operating system... "
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "${RED}✗${RESET}"
    errors+=("This script requires macOS (detected: $(uname))")
  else
    echo "${GREEN}✓ macOS${RESET}"
  fi

  # Check interactive mode
  echo -n "Checking shell mode... "
  if [[ $- == *i* ]]; then
    echo "${GREEN}✓ Interactive${RESET}"
  else
    echo "${RED}✗${RESET}"
    errors+=("Script must be run in interactive mode")
  fi

  # Check not running as root
  echo -n "Checking user permissions... "
  if [ "$(id -u)" -eq 0 ]; then
    echo "${RED}✗${RESET}"
    errors+=("Script should not be run as root")
  else
    echo "${GREEN}✓ Normal user${RESET}"
  fi

  # Check Docker installation
  echo -n "Checking Docker installation... "
  if which docker >/dev/null 2>&1; then
    echo "${GREEN}✓ Installed${RESET}"
  else
    echo "${RED}✗${RESET}"
    errors+=("Docker is not installed. Install via OrbStack: brew install orbstack")
  fi

  # Check Docker daemon
  echo -n "Checking Docker daemon... "
  if docker info >/dev/null 2>&1; then
    echo "${GREEN}✓ Running${RESET}"
  else
    echo "${RED}✗${RESET}"
    errors+=("Docker daemon is not running. Start OrbStack application")
  fi

  # Check OrbStack
  echo -n "Checking OrbStack... "
  if [ -d "/Applications/OrbStack.app" ]; then
    echo "${GREEN}✓ Installed${RESET}"
  else
    echo "${YELLOW}⚠${RESET}"
    warnings+=("OrbStack not found. Install with: brew install orbstack")
  fi

  # Check required tools
  echo -n "Checking required tools... "
  local missing_tools=()

  if ! command -v unzip >/dev/null 2>&1; then
    missing_tools+=("unzip")
  fi

  if ! command -v git >/dev/null 2>&1; then
    missing_tools+=("git")
  fi

  if ! command -v curl >/dev/null 2>&1; then
    missing_tools+=("curl")
  fi

  if [ ${#missing_tools[@]} -eq 0 ]; then
    echo "${GREEN}✓ All present${RESET}"
  else
    echo "${RED}✗${RESET}"
    errors+=("Missing required tools: ${missing_tools[*]}. Install with: brew install ${missing_tools[*]}")
  fi

  # Check moodlehq-docker
  echo -n "Checking moodlehq-docker... "
  if [ -f "$SCRIPT_DIR/../moodlehq-docker/config.docker-template.php" ]; then
    echo "${GREEN}✓ Present${RESET}"
  else
    echo "${YELLOW}⚠${RESET}"
    warnings+=("moodlehq-docker not found. Will attempt to clone...")

    # Try to clone it
    log ""
    log "Installing moodlehq-docker..."
    cd "$SCRIPT_DIR/../" || errors+=("Cannot change to parent directory")

    if git clone git@github.com:moodlehq/moodle-docker.git moodlehq-docker 2>/dev/null; then
      log "${GREEN}✓ Successfully cloned moodlehq-docker${RESET}"
    else
      errors+=("Failed to clone moodlehq-docker. Check SSH key: ssh -T git@github.com")
    fi
  fi

  # Check for old submodules
  echo -n "Checking for legacy submodules... "
  if [ -f "$SCRIPT_DIR/../.gitmodules" ]; then
    echo "${YELLOW}⚠${RESET}"
    warnings+=("Old submodules detected. Run 'moodle-docker upgrade' to update")
  else
    echo "${GREEN}✓ Clean${RESET}"
  fi

  # Check disk space
  echo -n "Checking disk space... "
  local available_space=$(df -h "$SCRIPT_DIR" | awk 'NR==2 {print $4}' | sed 's/Gi$//')
  if [[ "$available_space" =~ ^[0-9]+$ ]] && [ "$available_space" -lt 5 ]; then
    echo "${YELLOW}⚠${RESET}"
    warnings+=("Low disk space: ${available_space}GB available. Recommended: >5GB")
  else
    echo "${GREEN}✓ ${available_space} available${RESET}"
  fi

  # Check network connectivity
  echo -n "Checking network connectivity... "
  if curl -s --head https://github.com >/dev/null 2>&1; then
    echo "${GREEN}✓ Connected${RESET}"
  else
    echo "${YELLOW}⚠${RESET}"
    warnings+=("Cannot reach github.com. Network issues may prevent downloads")
  fi

  log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Display warnings
  if [ ${#warnings[@]} -gt 0 ]; then
    log ""
    log "${YELLOW}⚠️  Warnings:${RESET}"
    for warning in "${warnings[@]}"; do
      log "  • $warning"
    done
  fi

  # Display errors and abort if any
  if [ ${#errors[@]} -gt 0 ]; then
    log ""
    log "${RED}❌ Errors found:${RESET}"
    for error in "${errors[@]}"; do
      log "  • $error"
    done
    log ""
    abort "Please fix the above errors before continuing"
  fi

  log ""
  log "${GREEN}✅ All checks passed. System ready!${RESET}"
  log ""
}

export -f log
export -f abort
export -f setup
export -f check_is_running
