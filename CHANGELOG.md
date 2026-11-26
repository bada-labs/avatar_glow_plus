# Changelog

## 3.1.0

First release of `avatar_glow_plus`, a maintained successor of [`avatar_glow`](https://pub.dev/packages/avatar_glow) 3.0.1. It draws the same pixels as 3.0.1 (checked frame by frame in `test/parity_test.dart`).

* Replace the deprecated `Color.withOpacity` with an alpha that is rounded the same way, so colors are unchanged.
* The glow's painter no longer outlives the widget; it repaints from the animation instead of listening to it.
* A pending `startDelay` is cancelled when the widget is removed or `animate` turns off, instead of firing later.
* Changing `repeat` while `animate` is off no longer starts the animation.
* A translucent `glowColor` keeps its own opacity; 3.0.1 ignored it.
* Uses only `package:flutter/widgets.dart`. Requires Flutter 3.27.

# Changelog of avatar_glow


Official Changelog for different addition, changes, modifications.

## [3.0.1]

- chore(misc): update README.md (Ayush P Gupta)
- chore(misc): upgrade package lock (Ayush P Gupta)
- refactor!: v3.0.0 (#34) (Sahil Kumar)
- feat: upgrade example to Flutter 3.0 (#33) (BradInTheUSA)
- fix: late timer issue (#28) (jakeBrightHR)
- Fix timer issue in unit tests (#27) (jakeBrightHR)
- refactor: follow linting rules by Lint package (#26) (Yousef Almutairi)

## [2.0.2+1]

- Upgrade example to Flutter 3.0

## [2.0.2]

- Hide circle if animate false (#21)

## [2.0.1]

- Fix #17 thanks to [@nurassylive](@nurassylive)
- Fix stop animation jank when `animate` is set to false

## [2.0.0]

- Migrate example to android v2
- [Null Safety] Migrate package to support null safety
- [Pubspec] Remove author
- [Misc] Add linux desktop support
- [Refactor] Remove redundant code and refactor

## [1.2.0]

- Fix README with updated code

## [1.1.0]

### Merged

- [#6](https://github.com/apgapg/avatar_glow/pull/6) Add 'animate', 'curve' option.
  Thanks [@Nolence](https://github.com/Nolence) for PR. Thanks [@Sahil](https://github.com/xsahil03x) for feedback.
- Add macos support

## [1.0.0]

### Merged

- [#5](https://github.com/apgapg/avatar_glow/pull/5) Add option to change shape of widget.
  Thanks [@gildurao](https://github.com/gildurao)

## [0.2.0]

### Merged

- [#2](https://github.com/apgapg/avatar_glow/issues/2) Fixes exception when using widget inside scroll widget. Fixed
  missing repeat parameter usage. Thanks [@Sahil](https://github.com/xsahil03x)

### Added

- Delay in starting animation 'startDelay'

## [0.1.0] - Initial Release
