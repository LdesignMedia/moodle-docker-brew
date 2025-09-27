# Moodle Docker Brew

Homebrew-installable helper for running MoodleHQ’s official `moodle-docker` stack on macOS with OrbStack. Start multiple Moodle versions side-by-side, run Behat and PHPUnit, and iterate on plugins quickly.

## Highlights

- Wrapper around the official Moodle developer Docker image (https://github.com/moodlehq/moodle-docker)
- macOS + OrbStack optimized workflow (fast, simple)
- Homebrew formula: `moodle-docker`
- Run multiple Moodle versions concurrently
- Built-in runners for `behat` and `phpunit`
- Safety checks before doing destructive actions
- Persistent data under `~/moodle-docker-brew/moodle` (when installed via Homebrew)
- Supported versions: 5.2, 5.1, 5.0, 4.5, 4.4, 4.3, 4.2, 4.1, 4.0, 3.11, 3.10, 3.9
- Port convention per version: web `80NN`, DB `330NN`, VNC `590NN` (e.g., 8042/33042/59042 for 4.2)
- Default admin credentials: `admin` / `test`

## Requirements

- macOS
- Docker via OrbStack (`brew install orbstack`)
- git and unzip available on PATH
- GitHub SSH key configured for `upgrade` (clones `moodlehq/moodle-docker` via SSH)

## Install

### Homebrew (recommended)

```bash
brew install ldesignmedia/moodledocker/moodle-docker
```

More info about the tap: https://github.com/LdesignMedia/homebrew-moodle-docker

### Local clone (for development)

```bash
git clone https://github.com/LdesignMedia/moodle-docker-brew.git
cd moodle-docker-brew
./moodle-docker help
```

> Note: When installed via Homebrew, Moodle data lives under `~/moodle-docker-brew/moodle`. Using `moodle-docker destroy` removes the data for the selected version.

## Quick Start

```bash
# Start Moodle 4.2 (downloads Moodle, creates DB, launches containers)
moodle-docker start 42

# Open your browser
open http://localhost:8042/

# Stop containers (keeps data)
moodle-docker stop 42

# Remove containers and data for 4.2
moodle-docker destroy 42
```

## Step‑by‑Step Usage

1) Start a Moodle version

- Pick a supported version number (e.g., 42 for 4.2) and start it:

```bash
moodle-docker start 42
```

The script downloads Moodle, starts the containers, installs the DB, and initializes Behat + PHPUnit. Watch the output for the line beginning with `Directory:` — that path is where your Moodle files live for that version.

2) Open the site

- Visit `http://localhost:8042`
- Login with `admin` / `test`

3) Develop plugins (optional)

- Place your plugin inside the working directory shown as `Directory:` in the terminal output, under the correct subfolder, e.g.:
  - `.../moodle/42/local/myplugin`
  - `.../moodle/42/mod/myactivity`
  - `.../moodle/42/blocks/myblock`
- Go to Site administration → Notifications to install/upgrade your plugin.
- After adding or changing plugins, re-initialize test frameworks:

```bash
moodle-docker update 42
```

4) Run tests

- Behat (with optional tags):

```bash
moodle-docker behat 42 --tags=@your_tag
```

- PHPUnit (point to a test or directory):

```bash
moodle-docker phpunit 42 path/to/tests
```

5) Stop or destroy when done

- Stop containers (preserves data): `moodle-docker stop 42`
- Destroy containers and data for that version: `moodle-docker destroy 42`

## Commands

```bash
moodle-docker help                      # Usage and examples
moodle-docker start   {version}         # Start (e.g., 45, 44, 43, 42, 41, 40, 311, 310, 39)
moodle-docker stop    {version}         # Stop containers (preserves data)
moodle-docker destroy {version}         # Stop and remove containers + data
moodle-docker update  {version}         # Re-init Behat + PHPUnit (after adding plugins)
moodle-docker behat   {version} [...]   # Run Behat in the container
moodle-docker phpunit {version} [...]   # Run PHPUnit in the container
moodle-docker upgrade                   # Update this tool + upstream moodlehq/moodle-docker
moodle-docker grunt   {version} [watch] # Run grunt watch (JS/CSS builder)
```

Examples:

```bash
# Behat: run a tagged suite on 4.2
moodle-docker behat 42 --tags=@auth_manual

# PHPUnit: run a test on 4.2
moodle-docker phpunit 42 auth/manual/tests/manual_test.php
```

## Behat Setup

- First-time init: Behat is initialized automatically the first time you run `moodle-docker start {version}`.
- Re-initialize after changes (e.g., adding/updating plugins):

```bash
moodle-docker update {version}   # e.g., moodle-docker update 42
```

- Verify Behat status and steps mapping in your browser: `http://localhost:80NN/admin/tool/behat/index.php` (e.g., 8042 for 4.2).
- Run tests: `moodle-docker behat {version} [--tags=...]`.

## Grunt (JS/CSS Build)

Use grunt to rebuild AMD modules and theme assets during development.

```bash
# Start the watcher for Moodle 4.2
moodle-docker grunt 42 watch
```

What this does inside the container:

- Installs NVM if missing, selects a Node version based on `package.json` engines (`22`, `20`, `18`, or `16`; defaults to `20`).
- Installs `grunt-cli` globally and project dependencies (`npm ci` if lockfile exists, else `npm install`).
- Runs `grunt watch` in `/var/www/html`.

Notes:

- This is a long-running process; keep it open in a dedicated terminal tab.
- Stop with Ctrl+C. You can restart anytime.
- If dependencies change or you hit errors, run `moodle-docker grunt {version} watch` again to reinstall as needed.

## Access & Ports

- Web: `http://localhost:80NN/` (e.g., 8042)
- DB (MariaDB): host `localhost`, port `330NN`, user `moodle`, pass `m@0dl3ing`
- VNC (Selenium): host `localhost`, port `590NN`, password `secret`
- Behat faildumps: `http://localhost:80NN/_/faildumps/`
- Mail catcher: `http://localhost:80NN/_/mail/`

VNC viewer example: download [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/), connect to `localhost:59042` for Moodle 4.2.

![Database connection example](screenshots/database.png)

## PHP Versions

- 3.9 → PHP 7.4
- 4.4 and newer → PHP 8.1
- 4.0–4.3 → PHP 8.0

These versions are selected automatically; manual selection is not currently supported.

## Upgrade

Upgrade the Homebrew formula and refresh the embedded `moodlehq/moodle-docker` checkout:

```bash
brew upgrade moodle-docker
moodle-docker upgrade
```

Tip: `upgrade` uses SSH. Ensure your GitHub SSH key is configured or the clone will fail.

## Troubleshooting

- OrbStack not installed: install with `brew install orbstack` and start OrbStack.
- Ports in use: stop the other process or choose a different version number.
- Missing unzip/git: install via Homebrew (`brew install unzip git`).
- SSH access errors on `upgrade`: add your GitHub SSH key (`ssh -T git@github.com`).
- Clean start: run `moodle-docker destroy {version}` and then `moodle-docker start {version}`.

## Contributing

Contributions are welcome via pull request.

- Keep changes small and focused; use 2‑space indent for shell scripts.
- Share reusable logic under `scripts/helper.sh`.
- Lint/format: `shellcheck moodle-docker scripts/*.sh` and `shfmt -w .`.
- Verify end‑to‑end: start → behat/phpunit → stop.
- Don’t commit secrets or local `moodle/*` contents.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed version history.

## Version Map

Supported Moodle versions and their download URLs are defined in `moodle_versions.txt`. Update this file when adding new versions.

## To‑Do

- [ ] Add developer/commander tools
- [ ] Video: configure PhpStorm for plugin testing
- [ ] Xdebug settings
- [ ] Command to stop all running instances
- [ ] Display all running Moodle versions
- [ ] Option to install specific PHP versions
- [ ] Interactive Behat mode (pause/resume)

## Authors

- Luuk Verhoeven — [Ldesign Media](https://ldesignmedia.nl/) — [luuk@ldesignmedia.nl](mailto:luuk@ldesignmedia.nl)

<img src="https://ldesignmedia.nl/themes/ldesignmedia/assets/images/logo/logo.svg" alt="ldesignmedia" height="70px">
