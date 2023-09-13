# Moodle Docker Brew

This brew script simplifies the process of running the Moodle Docker, which can be found at https://github.com/moodlehq/moodle-docker.

## Features
- Can be installed via Homebrew.
- Build for `MacOS` and `OrbStack` (fast docker client)
- Run multiple Moodle versions simultaneously.
- Utilize `behat` and `phpunit` commands.
- Includes multiple checks to ensure error-free execution.
- Stores all Moodle files within this directory (See `~/.moodle-docker-brew/moodle`).
- Supports Moodle versions 42, 41, 40, 311, 310, and 39.
- Assigns unique ports for each Moodle test suite.
- Can be accessed locally using http://localhost:8042/ where in this example 42 is the Moodle version number.

## Installation with Homebrew

Make sure brew is installed on your system. You can use the following command to install brew:

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install OrbStack

We recommend using OrbStack as a docker client. It's much faster than the default docker client. We currently support only MacOS and OrbStack.

```bash
brew install orbstack
```

### Install moodle-docker
```bash
 brew install ldesignmedia/moodledocker/moodle-docker
```
_More information about the brew launcher can be found at: https://github.com/LdesignMedia/homebrew-moodle-docker_

This repo is automatically created in `~/.moodle-docker-brew` after the homebrew installation. This directory will contain all Moodle files and data.
Keep in mind if you run `moodle-docker destroy` all data of the given moodle version will be removed.

## Usage commands

```bash
# Examples:
moodle-docker help

moodle-docker start 39    # (Install/start a Moodle 39 instance)
moodle-docker start 311   # (Install/start a Moodle 311 instance)
moodle-docker start 41    # (Install/start a Moodle 41 instance)
moodle-docker start 42    # (Install/start a Moodle 42 instance)

moodle-docker stop 39     # (Stop a Moodle 41 instance, can be restarted with the start command)
moodle-docker stop 311    # (Stop a Moodle 41 instance, can be restarted with the start command)
moodle-docker stop 41     # (Stop a Moodle 41 instance, can be restarted with the start command)
moodle-docker stop 42     # (Stop a Moodle 41 instance, can be restarted with the start command)

moodle-docker destroy 39  # (Remove a Moodle 41 instance, all data/docker containers will be removed)
moodle-docker destroy 311 # (Remove a Moodle 41 instance, all data/docker containers will be removed)
moodle-docker destroy 41  # (Remove a Moodle 41 instance, all data/docker containers will be removed)
moodle-docker destroy 42  # (Remove a Moodle 41 instance, all data/docker containers will be removed)

moodle-docker update 42  # (Reload PHPunit and Behat testsite)
```

## Upgrade to latest version of moodle-docker

```bash
brew upgrade moodle-docker
moodle-docker upgrade     # (Install latest version of moodle-docker)
```

## PHP versions

Only Moodle 3.9 will work with PHP `7.4`. All other versions will use PHP `8.0`. 
Currently, you can't change the PHP version.

## Behat and phpunit

```bash
# Testing examples
moodle-docker phpunit 41 auth/manual/tests/manual_test.php
moodle-docker behat 41 --tags=@auth_manual # (Run a behat command on a running Moodle 41 instance)

moodle-docker phpunit 39 auth/manual/tests/manual_test.php  # (Run a phpunit command on a running Moodle 39 instance)
moodle-docker behat 39 --tags=@auth_manual
```
## Behat VNC

```bash
# Download a VNC client: https://www.realvnc.com/en/connect/download/viewer/
# Host: localhost/0.0.0.0
# Port: 59000 + Moodle version number (59000 + 42 = 59042)
# Connect to the VNC server with the following credentials:
# The password is 'secret'.
```

## TODO 

- [ ] Install developer/commander tools
- [ ] Install `directlogin.php`
- [ ] Connect PHPstorm test building a plugin
- [ ] xdebug configuration see Using XDebug for live debugging
- [ ] test connecting navicat, add to readme how to
- [ ] command for stopping all 
- [ ] command to see all running Moodle versions
- [ ] install with a specific version of PHP
- [ ] Xdebug option
 
## Authors
* Luuk Verhoeven :: [Ldesign Media](https://ldesignmedia.nl/) - [luuk@ldesignmedia.nl](luuk@ldesignmedia.nl)

<img src="https://ldesignmedia.nl/themes/ldesignmedia/assets/images/logo/logo.svg" alt="ldesignmedia" height="70px">
