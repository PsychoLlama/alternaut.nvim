# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Casing transforms for patterns. Enables matching files with different naming
  conventions, like PascalCase components with kebab-case CSS files. Use the
  new pattern object syntax with `transform.origin` and `transform.target`.

## [0.7.0] - 2025-10-12

### Removed

- The Vimscript implementation no longer ships alongside the Lua implementation.

## [0.6.0] - 2025-03-30

### Added

- Rewrote the plugin in Lua. It lives alongside the old implementation.
- [Lua] New concept of user-defined "modes" enables switching between more
  than just test files, such as styles, templates, headers, etc.

### Deprecated

- The Vimscript implementation is no longer maintained. It will be removed in
  a future release. It only exists to ease migration. Only Neovim will be
  supported going forward.

## [0.5.0] - 2021-04-01

### Added

- Support for tests and source files colocated in the same directory.

### Fixed

- Massive performance problems when using `'.'` as a directory convention.

## [0.4.0] - 2020-12-28

### Removed

- `RegisterLanguage(...)` and `AddInterceptor(...)` (deprecated in v0.2.0).

### Changed

- (private) Renamed API functions to snake_case.

## [0.3.0] - 2020-09-23

### Added

- More streamlined `<Plug>(alternaut-toggle)` mapping.

## [0.2.0] - 2020-09-22

### Added

- Declarative configs using `alternaut#conventions`. See issue #1 for a description of the problem.
- Similarly, declarative interceptors using `alternaut#interceptors`.

### Deprecated

- `alternaut#RegisterLanguage(...)` and `alternaut#AddInterceptor(...)` are no longer supported. Use the declarative configs instead.

## [0.1.0] - 2020-02-02

Initial release (unstable).

[Unreleased]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/PsychoLlama/alternaut.nvim/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/PsychoLlama/alternaut.nvim/commits/v0.1.0
