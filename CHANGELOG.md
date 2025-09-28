# Changelog

All notable changes to moodle-docker-brew will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.36] - 2025-09-28

### Added
- **New `cron` command** for running Moodle cron jobs
  - `moodle-docker cron <version>` - Run cron once
  - `moodle-docker cron <version> watch` - Run cron continuously (every 60 seconds)
  - `moodle-docker cron <version> scheduled` - List scheduled tasks
  - Live output with timestamps for debugging
  - Clean exit handling with Ctrl+C for watch mode

- **New `task` command** for managing scheduled tasks
  - `moodle-docker task <version> list` - List all available scheduled tasks
  - `moodle-docker task <version> select` - Interactive task selection menu
  - `moodle-docker task <version> select <number>` - Run task by number directly (e.g., select 5)
  - `moodle-docker task <version> run <class>` - Run specific task by class name
  - Color-coded output with task highlighting
  - Numbered task list for easy selection
  - Full error handling and validation

- **Enhanced error handling** to prevent wrong argument usage
  - Detection of swapped arguments (e.g., `moodle-docker 45 start` shows correct format)
  - Improved command typo suggestions (e.g., 'tsk' suggests 'task')
  - Version format validation (detects 4.5 vs 45, v45 vs 45)
  - Context-specific usage examples for missing arguments
  - Clear, color-coded error messages

### Changed
- Improved help documentation with examples for all new commands
- Better command suggestion algorithm that checks both starting letters and substring matches
- Updated cron scheduled mode to reference the new task command

### Fixed
- Trap command syntax for proper signal handling in cron watch mode
- Command validation order to ensure proper error messages

## [1.0.35] - 2025-09-27

### Added
- Smart git conflict handling during upgrades with automatic stashing
- Backup creation for local modifications in moodlehq-docker
- Step-by-step progress display during upgrade process
- Fallback to HTTPS if SSH clone fails
- Version verification after upgrade completion

### Changed
- Complete rewrite of upgrade function with better error handling
- Improved feedback with 4-step upgrade process visualization
- Better detection of whether updates are needed
- Cleaner output with suppressed git command noise

### Fixed
- Fixed git merge conflicts when local changes exist in moodlehq-docker
- Resolved "files would be overwritten by merge" errors
- Handled untracked files properly during updates

## [1.0.34] - 2025-09-27

### Added
- Comprehensive system pre-check with visual status indicators
- Disk space validation (warns if less than 5GB available)
- Network connectivity check to GitHub
- Additional tool checks (curl requirement)
- Real-time status display during checks with ✓/✗/⚠ indicators

### Changed
- Complete rewrite of setup() function with better error handling
- Separated errors from warnings for clearer feedback
- Added descriptive fix instructions for each potential issue
- Improved Docker daemon check using docker info instead of socket check

### Fixed
- Added missing CYAN color variable for proper display formatting

## [1.0.33] - 2025-09-27

### Added
- Comprehensive help display with formatted output and visual design
- Help automatically shown when no arguments are provided
- Detailed listing of all available Moodle versions organized by category
- Port mapping information in help display
- Examples section with common use cases

### Changed
- Enhanced help command with box drawing characters and color coding
- Organized Moodle versions into Development, Stable, and Legacy categories
- Improved error messages when missing required arguments

## [1.0.32] - 2025-09-27

### Added
- VNC connection pause in interactive mode - script pauses to allow VNC viewer connection
- Press Enter prompt when running interactive tests to give time for VNC setup
- Comprehensive interactive testing documentation in README

### Changed
- Enhanced interactive mode workflow with clear VNC connection instructions
- Improved README with step-by-step interactive testing guide
- Better explanation of @pause tags and breakpoint functionality

## [1.0.31] - 2025-09-27

### Added
- Automatic Behat initialization check before running tests
- Automatic PHPUnit initialization check before running tests
- Auto-initialize test frameworks if vendor/bin/behat or vendor/bin/phpunit don't exist

### Fixed
- Fixed "Could not open input file: /var/www/html/vendor/bin/behat" error on first run
- Fixed similar error for PHPUnit when running tests before initialization

## [1.0.25] - 2025-09-27

### Added
- Manual PHP version override with `--php=VERSION` option
- Support for specifying custom PHP versions for any Moodle installation
- Improved help command with examples and detailed options

### Fixed
- **CRITICAL**: Fixed PHP version for Moodle 5.0+ (now correctly uses PHP 8.2 minimum instead of 8.1)
- Corrected PHP version mapping for all Moodle versions:
  - Moodle 3.9: PHP 7.4
  - Moodle 3.10-3.11: PHP 8.0
  - Moodle 4.0-4.3: PHP 8.0
  - Moodle 4.4-4.5: PHP 8.1
  - Moodle 5.0+: PHP 8.2
- **VERIFIED**: Moodle 5.0 now runs successfully with PHP 8.2.29 in Docker container

### Changed
- Enhanced PHP version detection logic with proper version requirements per Moodle release

### Technical Notes
- Requires pulling the `moodlehq/moodle-php-apache:8.2` Docker image for Moodle 5.0+
- Containers must be recreated (not just restarted) when changing PHP versions

## [1.0.24] - 2025-09-27

### Added
- Enhanced output formatting with visual separators and emojis
- Better structured information display with sections
- Progress indicators for each operation step
- Clear success/failure messages with visual feedback
- Improved command output for start, stop, destroy, behat, phpunit, and grunt

### Changed
- Reorganized output into logical sections (Configuration, Ports, Credentials, Tools, Documentation)
- Added color coding for better readability
- Improved user feedback during operations with step-by-step status updates

## [1.0.30] - 2025-09-27

### Added
- Interactive Behat testing mode with `--interactive` or `-i` flag
- Automatic pause at @pause tags for debugging scenarios
- Prominent VNC connection information display in start command
- Enhanced VNC information in behat command output
- Support for verbose output and stop-on-failure in interactive mode

### Changed
- Improved Behat test output with clear VNC viewer instructions
- Start command now prominently displays VNC connection details
- Added tips for watching tests in real-time via VNC

## [1.0.29] - 2025-09-27

### Fixed
- Fixed argument parsing for xdebug and grunt subcommands after shift operations
- Subcommands now correctly parsed from ALL_REMAINING_ARGS variable

## [1.0.28] - 2025-09-27

### Added
- Xdebug support with new `xdebug` command for PHP debugging
- Subcommands: install, enable, disable, status
- Automatic configuration for macOS/Windows with host.docker.internal
- IDE integration support for PHPStorm, VSCode, and other debuggers

### Changed
- Updated help command to include xdebug documentation

## [1.0.27] - 2025-09-27

### Added
- Support for development version (`dev`) using latest Moodle code from main branch
- Special port configuration for dev version: web 8099, DB 33099, VNC 59099

### Changed
- Development version automatically uses PHP 8.2

## [1.0.26] - 2025-09-27

### Fixed
- Removed non-existent Moodle 5.1 and 5.2 versions (these are scheduled for future release)
- Clarified that Moodle 5.0 is currently a development version (scheduled for April 2025)

### Changed
- Updated supported versions list to accurately reflect available versions

## [1.0.23] - 2025-09-27

### Added
- Support for Moodle 5.0 development version (version code: 50)
- CHANGELOG.md file to track version history

### Changed
- Updated README.md to include new Moodle versions in supported versions list

### Note
- Moodle 5.0 is currently in development and scheduled for release in April 2025
- Moodle 5.1 is scheduled for October 2025
- Moodle 5.2 is scheduled for April 2026

## [1.0.22] - 2025

### Added
- Grunt watch feature for continuous JS/CSS building
- Enhanced documentation with usage details

## [1.0.21] - 2025

### Changed
- Version bump

## [1.0.20] - 2025

### Changed
- Multiple version stabilization updates

## [1.0.19] - 2025

### Fixed
- Submodule update issues

### Added
- Support for Moodle 4.4 with PHP 8.1
- Support for Moodle 4.3

## Previous Versions

For earlier versions, please refer to the git commit history.