# avatar_glow_plus

[![pub package](https://img.shields.io/pub/v/avatar_glow_plus.svg)](https://pub.dev/packages/avatar_glow_plus)
[![CI](https://github.com/bada-labs/avatar_glow_plus/actions/workflows/ci.yaml/badge.svg)](https://github.com/bada-labs/avatar_glow_plus/actions/workflows/ci.yaml)

Pulsing glow rings around any widget, such as an avatar or a call button.

This is a maintained, drop-in successor of [`avatar_glow`](https://pub.dev/packages/avatar_glow), which has not been updated since 3.0.1 (2023). It keeps the same API and draws the same pixels, without the deprecated APIs. Bada Labs uses it in its call apps.

## What's different from `avatar_glow` 3.0.1

- **No deprecated APIs.** `Color.withOpacity` is replaced, with alpha rounded the same way so colors don't shift.
- **Same pixels.** A test renders both packages at several points of the animation and compares every pixel.
- **Cleaner lifecycle.** A pending `startDelay` is cancelled when the widget goes away, the painter no longer outlives the widget, and changing `repeat` while stopped no longer starts the glow.
- **Translucent colors work.** `glowColor`'s own opacity is kept.

## Migrating from `avatar_glow`

1. In `pubspec.yaml`, replace `avatar_glow` with `avatar_glow_plus`.
2. Replace `package:avatar_glow/avatar_glow.dart` with `package:avatar_glow_plus/avatar_glow_plus.dart`.

The API is unchanged.

## Usage

```dart
AvatarGlow(
  glowColor: Colors.green,
  child: const CircleAvatar(radius: 32, child: Icon(Icons.call)),
)
```

| Parameter | Default | Description |
|---|---|---|
| `child` | required | The widget the glow surrounds. |
| `glowColor` | white | Ring color. Rings start at 30% of its opacity and fade as they grow. |
| `glowCount` | 2 | Number of rings. |
| `glowShape` | `BoxShape.circle` | Ring shape. |
| `glowBorderRadius` | none | Corner radius for `BoxShape.rectangle`. |
| `glowRadiusFactor` | 0.7 | How far each ring grows, relative to half the child's shorter side. |
| `duration` | 2 s | Length of one pulse. |
| `startDelay` | none | Wait before the first pulse. |
| `animate` | true | Turning it off lets the current pulse shrink back and stop. |
| `repeat` | true | Whether pulses repeat. |
| `curve` | `Curves.fastOutSlowIn` | Curve of the ring growth. |

## Scope

This package fixes bugs and keeps up with Flutter changes. New features are considered conservatively to keep it small and dependable.

## Credits

Based on [`avatar_glow`](https://pub.dev/packages/avatar_glow) by Ayush P Gupta, under the MIT license. Maintained by [Bada Labs](https://badalabs.com).
