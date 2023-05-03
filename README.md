# Moodle Docker Brew

This brew script simplifies the process of running the Moodle Docker, which can be found at https://github.com/moodlehq/moodle-docker.

## Features
- Build for `MacOS` and `OrbStack` (fast docker client)
- Run multiple Moodle versions simultaneously.
- Utilize `behat` and `phpunit` commands.
- Includes multiple checks to ensure error-free execution.
- Stores all files within this directory.
- Supports Moodle versions 42, 41, 40, 311, 310, and 39.
- Assigns unique ports for each Moodle test suite.


```bash
# Examples:
# moodle-docker help
# moodle-docker start 42
# moodle-docker start 41
# moodle-docker start 311
# moodle-docker start 39
# moodle-docker update 41
# moodle-docker stop 41
# moodle-docker destroy 41
# moodle-docker behat 41 --tags=@auth_manual

#./moodle-docker phpunit 39 auth/manual/tests/manual_test.php
```

## TODO 

- [ ] Make it installable from brew (check if git package can be private) (https://betterprogramming.pub/a-step-by-step-guide-to-create-homebrew-taps-from-github-repos-f33d3755ba74)
- [ ] Xdebug option  
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
 
## Authors
* Luuk Verhoeven :: [Ldesign Media](https://ldesignmedia.nl/) - [luuk@ldesignmedia.nl](luuk@ldesignmedia.nl)

<img src="https://ldesignmedia.nl/themes/ldesignmedia/assets/images/logo/logo.svg" alt="ldesignmedia" height="70px">
