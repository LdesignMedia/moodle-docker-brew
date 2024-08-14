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
  log "Initializing..."

  if [[ "$(uname)" != "Darwin" ]]; then
    abort "This script is not running on macOS."
  fi

  if [[ $- == *i* ]]; then
    log "You are in interactive mode."
  else
    abort "You are in non-interactive mode."
  fi

  if [ "$(id -u)" -eq 0 ]; then
    abort "You are running as root."
  fi

  if which docker >/dev/null 2>&1; then
    log "${GREEN}Docker is installed."
  else
    abort "Docker is NOT installed."
  fi

  if [ -S /var/run/docker.sock ]; then
    log "${GREEN}Docker is running."
  else
    abort "Docker is NOT running."
  fi

  # Check if unzip is installed
  if ! command -v unzip >/dev/null 2>&1; then
    abort "Error: unzip is required to extract the Moodle version."
  fi

  # Check if git is installed
  if ! command -v git >/dev/null 2>&1; then
    abort "Error: git is required."
  fi

  # Search for the application in the /Applications directory
  if [ ! -d "/Applications/OrbStack.app" ]; then
    abort "Orbstack is not installed, please install it first."
  fi

  if [ -f "$SCRIPT_DIR/../.gitmodules" ]; then
    abort "Submodules found (old codebase) (please run \"moodle-docker upgrade\" to run on the latest version)."
  fi

  if [ ! -f "$SCRIPT_DIR/../moodlehq-docker/config.docker-template.php" ]; then
    echo "Missing submodule, trying to fix it."

    echo "$SCRIPT_DIR/../"
    cd $SCRIPT_DIR/../

    git clone git@github.com:moodlehq/moodle-docker.git moodlehq-docker
    abort "Git submodule was not found, please try again."
  fi

}

export -f log
export -f abort
export -f setup
export -f check_is_running
