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


## Installation with homebrew

How to: https://github.com/LdesignMedia/homebrew-moodle-docker

This repository is located at `~/.moodle-docker-brew` after the homebrew installation. 

## Usage

```bash
# Examples:
# moodle-docker help
# moodle-docker upgrade     (Install latest version of moodle-docker)
# moodle-docker start 42    (Install/start a Moodle 42 instance)
# moodle-docker start 41    (Install/start a Moodle 41 instance)
# moodle-docker start 311   (Install/start a Moodle 311 instance)
# moodle-docker start 39    (Install/start a Moodle 39 instance)
# moodle-docker update 41   (reload behat/unit testing installation)
# moodle-docker stop 41     (Stop a Moodle 41 instance, can be restarted with the start command)
# moodle-docker destroy 41  (Remove a Moodle 41 instance, all data/docker containers will be removed)

# Testing examples
# moodle-docker behat 41 --tags=@auth_manual (Run a behat command on a running Moodle 41 instance)
# moodle-docker phpunit 39 auth/manual/tests/manual_test.php  (Run a phpunit command on a running Moodle 39 instance)
```

## TODO 

- [ ] Install developer/commander tools
- [ ] Install `directlogin.php`
- [ ] Reinstall behat/unit testsite if you add extra plugins
- [ ] Mailhog test
- [ ] VNC test
- [ ] Screenshot on behat failure http://localhost:8042/_/faildumps/ in the informational message
- [ ] Connect PHPstorm test building a plugin
- [ ] xdebug configuration see Using XDebug for live debugging
- [ ] show mail link http://localhost:8000/_/mail with correct port in the informational message
- [ ] test connecting navicat, add to readme how to
- [ ] command for stopping all 
- [ ] command to see all running Moodle versions
- [ ] install with a specific version of PHP
- [ ] test building a Behat test
- [ ] test building a unit test
- [ ] Xdebug option
 
## Authors
* Luuk Verhoeven :: [Ldesign Media](https://ldesignmedia.nl/) - [luuk@ldesignmedia.nl](luuk@ldesignmedia.nl)

<img src="https://ldesignmedia.nl/themes/ldesignmedia/assets/images/logo/logo.svg" alt="ldesignmedia" height="70px">
