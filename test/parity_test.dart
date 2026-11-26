import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:avatar_glow/avatar_glow.dart' as original;
import 'package:avatar_glow_plus/avatar_glow_plus.dart' as plus;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders `avatar_glow` 3.0.1 and this package with the same settings and
/// compares the painted pixels at several points of the animation.
void main() {
  const boundaryKey = Key('boundary');
  const child = SizedBox(width: 40, height: 40);

  Future<Uint8List> pixelsAfter(
    WidgetTester tester,
    Widget glow,
    Duration elapsed,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(child: glow),
            ),
          ),
        ),
      ),
    );
    await tester.pump(elapsed);
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(boundaryKey),
    );
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage();
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return data!.buffer.asUint8List();
    });
    await tester.pumpWidget(const SizedBox());
    return bytes!;
  }

  for (final elapsed in [
    Duration.zero,
    const Duration(milliseconds: 300),
    const Duration(milliseconds: 900),
    const Duration(milliseconds: 1700),
    const Duration(milliseconds: 2500),
  ]) {
    testWidgets('circle matches avatar_glow at $elapsed', (tester) async {
      final expected = await pixelsAfter(
        tester,
        original.AvatarGlow(glowColor: Color(0xFF4CAF50), child: child),
        elapsed,
      );
      final actual = await pixelsAfter(
        tester,
        const plus.AvatarGlow(glowColor: Color(0xFF4CAF50), child: child),
        elapsed,
      );
      expect(actual, expected);
    });

    testWidgets('rounded rectangle with 3 rings matches at $elapsed', (
      tester,
    ) async {
      const radius = BorderRadius.all(Radius.circular(12));
      final expected = await pixelsAfter(
        tester,
        original.AvatarGlow(
          glowColor: Color(0xFFF44336),
          glowShape: BoxShape.rectangle,
          glowBorderRadius: radius,
          glowCount: 3,
          glowRadiusFactor: 0.4,
          child: child,
        ),
        elapsed,
      );
      final actual = await pixelsAfter(
        tester,
        const plus.AvatarGlow(
          glowColor: Color(0xFFF44336),
          glowShape: BoxShape.rectangle,
          glowBorderRadius: radius,
          glowCount: 3,
          glowRadiusFactor: 0.4,
          child: child,
        ),
        elapsed,
      );
      expect(actual, expected);
    });
  }
}
