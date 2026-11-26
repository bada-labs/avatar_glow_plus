import 'package:avatar_glow_plus/avatar_glow_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget glow({bool animate = true, bool repeat = true, Duration? startDelay}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: AvatarGlow(
          animate: animate,
          repeat: repeat,
          startDelay: startDelay,
          glowColor: const Color(0xFF4CAF50),
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );
  }

  testWidgets('keeps pulsing while animate and repeat are on', (tester) async {
    await tester.pumpWidget(glow());
    await tester.pump(const Duration(seconds: 5));

    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('plays one pulse and stops when repeat is off', (tester) async {
    await tester.pumpWidget(glow(repeat: false));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pump(const Duration(seconds: 2));
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('does not animate when animate is off', (tester) async {
    await tester.pumpWidget(glow(animate: false));

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('waits for startDelay before the first pulse', (tester) async {
    await tester.pumpWidget(glow(startDelay: const Duration(seconds: 1)));
    await tester.pump(const Duration(milliseconds: 900));
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('cancels a pending startDelay when removed', (tester) async {
    await tester.pumpWidget(glow(startDelay: const Duration(seconds: 1)));
    await tester.pumpWidget(const SizedBox());
    // The test binding fails the test if a timer is still pending here.
  });

  testWidgets('shrinks back and stops when animate turns off', (tester) async {
    await tester.pumpWidget(glow());
    await tester.pump(const Duration(milliseconds: 500));

    await tester.pumpWidget(glow(animate: false));
    await tester.pumpAndSettle();

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('turning repeat on while stopped does not restart it', (
    tester,
  ) async {
    await tester.pumpWidget(glow(animate: false, repeat: false));
    await tester.pumpWidget(glow(animate: false));

    expect(tester.hasRunningAnimations, isFalse);
  });
}
