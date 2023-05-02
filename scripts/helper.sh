#!/bin/bash
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
            [yY][eE][sS]|[yY])
                return 0
                ;;
            [nN][oO]|[nN])
                return 1
                ;;
            *)
                echo "Please answer 'yes' or 'no'."
                ;;
        esac
    done
}

function setup() {
  log "Initializing..."

  if [[ "$(uname)" != "Darwin" ]]; then
    abort "This script is not running on macOS."
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

  if [ ! -f "moodlehq-docker/config.docker-template.php" ]; then
    # Try to solve this issue.
    git submodule update --init --recursive
    abort "Git submodule is missing (moodlehq-docker)."
  fi

}

export -f log
export -f abort
export -f setup
