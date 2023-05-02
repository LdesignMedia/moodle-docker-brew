# Moodle Docker Brew

This brew script simplifies the process of running the Moodle Docker, which can be found at https://github.com/moodlehq/moodle-docker.

## Features
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

- [ ] Make it installable from brew (https://betterprogramming.pub/a-step-by-step-guide-to-create-homebrew-taps-from-github-repos-f33d3755ba74)
- [ ] Xdebug option  
- [ ] Install developer/commander tools
- [ ] Install directlogin
- [ ] Reinstall behat/unit testsite if you add extra plugins