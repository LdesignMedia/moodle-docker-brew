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
- Supported versions: dev (latest), 5.0 (pre-release), 4.5, 4.4, 4.3, 4.2, 4.1, 4.0, 3.11, 3.10, 3.9
- Port convention per version: web `80NN`, DB `330NN`, VNC `590NN` (e.g., 8042/33042/59042 for 4.2)
- Development version uses special ports: web `8099`, DB `33099`, VNC `59099`
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

# Start with a specific PHP version
moodle-docker start 42 --php=8.2

# Or try the latest development version
moodle-docker start dev

# Open your browser
open http://localhost:8042/  # For version 4.2
open http://localhost:8099/  # For dev version

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
moodle-docker start   {version}         # Start (e.g., dev, 50, 45, 44, 43, 42, 41, 40, 311, 310, 39)
moodle-docker stop    {version}         # Stop containers (preserves data)
moodle-docker destroy {version}         # Stop and remove containers + data
moodle-docker update  {version}         # Re-init Behat + PHPUnit (after adding plugins)
moodle-docker behat   {version} [...]   # Run Behat in the container
moodle-docker phpunit {version} [...]   # Run PHPUnit in the container
moodle-docker xdebug  {version} [cmd]   # Manage Xdebug (install/enable/disable/status)
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

## Behat Setup & Testing

### Initial Setup

- First-time init: Behat is initialized automatically when you run `moodle-docker start {version}`
- Re-initialize after adding/updating plugins:

```bash
moodle-docker update {version}   # e.g., moodle-docker update 42
```

### Running Behat Tests

```bash
# Run all tests
moodle-docker behat 42

# Run specific tags
moodle-docker behat 42 --tags=@auth

# Run specific feature file
moodle-docker behat 42 /path/to/test.feature

# Interactive mode (pauses at breakpoints)
moodle-docker behat 42 --interactive --tags=@mytests
```

### Watching Tests in Real-Time with VNC

Connect to the Selenium container to watch tests run visually:

1. **Download a VNC viewer**: [RealVNC Viewer](https://www.realvnc.com/download/viewer/)
2. **Connect to the VNC server**:
   - Host: `localhost`
   - Port: `590NN` (e.g., `59042` for Moodle 4.2)
   - Password: `secret`
3. **Watch your tests execute** in a real browser window

### Interactive Testing

Interactive mode allows you to debug tests step-by-step and watch them run in real-time via VNC.

#### How to Run Interactive Tests

```bash
# Run tests interactively with the --interactive or -i flag
moodle-docker behat 42 --interactive --tags=@mytest

# Or use the short form
moodle-docker behat 42 -i --tags=@mytest
```

#### What Happens in Interactive Mode

1. **VNC Connection Pause**: The script pauses before starting tests, giving you time to connect your VNC viewer
2. **Test Pausing**: Tests pause at `@pause` tags in your scenarios
3. **Failure Stops**: Tests stop immediately on the first failure for debugging
4. **Verbose Output**: Detailed test execution information is displayed
5. **Manual Control**: Press Enter to continue when tests pause

#### Setting Up VNC to Watch Tests

When you run tests in interactive mode:

1. The script will pause and display:
   ```
   ⏸️  PAUSE: Open your VNC viewer now!
   Connect VNC viewer to: localhost:59042 (port varies by version)
   Password: secret
   ```

2. Open your VNC viewer and connect before pressing Enter

3. Once connected, press Enter to start the tests

#### Using @pause Tags for Breakpoints

Add `@pause` tags to your Behat scenarios to create breakpoints:

```gherkin
@mytest @pause
Scenario: Test with a breakpoint
    Given I am on homepage
    When I log in as "admin"
    Then I should see "Dashboard"  # Test pauses here
    And I click on "Site administration"  # Press Enter to continue to this step
```

When the test reaches a `@pause` tag:
- The test execution pauses
- You can inspect the browser state in VNC
- Press Enter in the terminal to continue

#### Example Workflow

```bash
# 1. Start interactive test
moodle-docker behat 42 -i --tags=@auth_manual

# 2. Script pauses - connect VNC viewer to localhost:59042

# 3. Press Enter when VNC is connected

# 4. Tests run - they pause at any @pause tags

# 5. Press Enter to continue past each pause point
```

### Useful URLs

- Behat test status: `http://localhost:80NN/admin/tool/behat/index.php`
- Failed test screenshots: `http://localhost:80NN/_/faildumps/`

## Xdebug (PHP Debugging)

Enable step-by-step debugging for PHP development:

```bash
# Install and configure Xdebug for Moodle 4.2
moodle-docker xdebug 42 install

# Check Xdebug status
moodle-docker xdebug 42 status

# Temporarily disable Xdebug (improves performance when not debugging)
moodle-docker xdebug 42 disable

# Re-enable Xdebug
moodle-docker xdebug 42 enable
```

### IDE Configuration

1. Configure your IDE to listen on port 9003
2. Set path mappings:
   - Local: `/path/to/moodle-docker-brew/moodle/42`
   - Remote: `/var/www/html`
3. For PHPStorm/VSCode, you may need to set an IDE key in the Xdebug config

### Notes

- Xdebug uses `host.docker.internal` on macOS/Windows
- Linux users may need to use `localhost` or the host IP
- Performance is slower with Xdebug enabled - disable when not debugging

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

### Default PHP Versions

Each Moodle version automatically uses the appropriate PHP version:

- Moodle 3.9 → PHP 7.4
- Moodle 3.10-3.11 → PHP 8.0
- Moodle 4.0-4.3 → PHP 8.0
- Moodle 4.4-4.5 → PHP 8.1
- Moodle 5.0+ → PHP 8.2
- Development (dev) → PHP 8.2

### Manual PHP Version Override

You can override the default PHP version using the `--php` flag:

```bash
# Start Moodle 5.0 with PHP 8.3 instead of default 8.2
moodle-docker start 50 --php=8.3

# Start Moodle 4.4 with PHP 8.2 instead of default 8.1
moodle-docker start 44 --php=8.2

# Test your plugin with different PHP versions
moodle-docker start 45 --php=7.4  # Test backward compatibility
moodle-docker start 45 --php=8.3  # Test forward compatibility
```

**Note**: The specified PHP version must be available as a Docker image (`moodlehq/moodle-php-apache:VERSION`). Common versions include: 7.4, 8.0, 8.1, 8.2, 8.3

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
- [ ] Command to stop all running instances
- [ ] Display all running Moodle versions

## Authors

- Luuk Verhoeven — [Ldesign Media](https://ldesignmedia.nl/) — [luuk@ldesignmedia.nl](mailto:luuk@ldesignmedia.nl)

<img src="https://ldesignmedia.nl/themes/ldesignmedia/assets/images/logo/logo.svg" alt="ldesignmedia" height="70px">
