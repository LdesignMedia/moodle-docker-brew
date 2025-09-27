# Changelog

All notable changes to moodle-docker-brew will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

### Changed
- Enhanced PHP version detection logic with proper version requirements per Moodle release

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

## [1.0.23] - 2025-09-27

### Added
- Support for Moodle 5.0 (version code: 50)
- Support for Moodle 5.1 (version code: 51)
- Support for Moodle 5.2 (version code: 52)
- CHANGELOG.md file to track version history

### Changed
- Updated README.md to include new Moodle versions in supported versions list

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