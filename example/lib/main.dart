import 'package:avatar_glow_plus/avatar_glow_plus.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// A green call button with a pulsing glow. Tap it to stop or start the glow.
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _isGlowing = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFF101010),
        child: Center(
          child: GestureDetector(
            onTap: () => setState(() => _isGlowing = !_isGlowing),
            child: AvatarGlow(
              animate: _isGlowing,
              glowColor: const Color(0xFF4CAF50),
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
