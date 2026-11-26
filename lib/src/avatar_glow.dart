import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Pulses rings outward from behind [child], like a ripple around an avatar
/// or a call button.
class AvatarGlow extends StatefulWidget {
  /// Creates a glow around [child].
  const AvatarGlow({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFFFFFFFF),
    this.glowCount = 2,
    this.glowShape = BoxShape.circle,
    this.glowBorderRadius,
    this.glowRadiusFactor = 0.7,
    this.duration = const Duration(seconds: 2),
    this.startDelay,
    this.animate = true,
    this.repeat = true,
    this.curve = Curves.fastOutSlowIn,
  }) : assert(
         glowShape != BoxShape.circle || glowBorderRadius == null,
         'A circle cannot have a border radius.',
       ),
       assert(glowCount > 0, 'glowCount must be positive.');

  /// The widget the glow surrounds.
  final Widget child;

  /// Color of the rings. Each ring starts at 30% of this color's opacity and
  /// fades out as it grows.
  final Color glowColor;

  /// Number of rings drawn on top of each other.
  final int glowCount;

  /// Shape of the rings.
  final BoxShape glowShape;

  /// Corner radius of the rings when [glowShape] is [BoxShape.rectangle].
  final BorderRadius? glowBorderRadius;

  /// How far each ring grows, relative to half the shorter side of [child].
  final double glowRadiusFactor;

  /// Duration of one pulse.
  final Duration duration;

  /// Wait before the first pulse.
  final Duration? startDelay;

  /// Whether the glow is pulsing. Setting it to false lets the current pulse
  /// shrink back and stop.
  final bool animate;

  /// Whether pulses repeat. When false, a single pulse plays.
  final bool repeat;

  /// Curve of the ring growth.
  final Curve curve;

  @override
  State<AvatarGlow> createState() => _AvatarGlowState();
}

class _AvatarGlowState extends State<AvatarGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  Timer? _startDelayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _start();
    }
  }

  @override
  void didUpdateWidget(covariant AvatarGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _animationController.duration = widget.duration;
    }
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _start() : _stop();
    } else if (widget.animate && widget.repeat != oldWidget.repeat) {
      _play();
    }
  }

  @override
  void dispose() {
    _startDelayTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _start() {
    _startDelayTimer?.cancel();
    final startDelay = widget.startDelay;
    if (startDelay == null) {
      _play();
    } else {
      _startDelayTimer = Timer(startDelay, _play);
    }
  }

  void _play() {
    if (widget.repeat) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _stop() {
    _startDelayTimer?.cancel();
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _GlowPainter(
          progress: _animationController,
          glowColor: widget.glowColor,
          glowCount: widget.glowCount,
          glowShape: widget.glowShape,
          glowBorderRadius: widget.glowBorderRadius,
          glowRadiusFactor: widget.glowRadiusFactor,
          curve: widget.curve,
        ),
        child: widget.child,
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  _GlowPainter({
    required this.progress,
    required this.glowColor,
    required this.glowCount,
    required this.glowShape,
    required this.glowBorderRadius,
    required this.glowRadiusFactor,
    required this.curve,
  }) : super(repaint: progress);

  static const _initialGlowOpacity = 0.3;

  final Animation<double> progress;
  final Color glowColor;
  final int glowCount;
  final BoxShape glowShape;
  final BorderRadius? glowBorderRadius;
  final double glowRadiusFactor;
  final Curve curve;

  @override
  void paint(Canvas canvas, Size size) {
    final fadingOpacity = _initialGlowOpacity * (1 - progress.value);
    final glowPaint =
        Paint()
          ..color = glowColor.withAlpha(
            (255 * glowColor.a * fadingOpacity).round(),
          );
    final childRadius = math.min(size.width, size.height) / 2;
    final easedProgress = curve.transform(progress.value);
    final center = size.center(Offset.zero);

    // Each ring adds its outline to one path that is filled again, the same
    // way avatar_glow draws, so overlapping rings deepen towards the center
    // and the anti-aliased edges match the original pixel for pixel.
    final ringsPath = Path();
    for (var ringIndex = 1; ringIndex <= glowCount; ringIndex++) {
      final ringRadius =
          childRadius +
          childRadius * glowRadiusFactor * ringIndex * easedProgress;
      final ringBounds = Rect.fromCircle(center: center, radius: ringRadius);
      ringsPath.addPath(_ringPath(ringBounds), Offset.zero);
      canvas.drawPath(ringsPath, glowPaint);
    }
  }

  Path _ringPath(Rect ringBounds) {
    final borderRadius = glowBorderRadius;
    return switch (glowShape) {
      BoxShape.circle => Path()..addOval(ringBounds),
      BoxShape.rectangle when borderRadius != null =>
        Path()..addRRect(borderRadius.toRRect(ringBounds)),
      BoxShape.rectangle => Path()..addRect(ringBounds),
    };
  }

  @override
  bool shouldRepaint(_GlowPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.glowColor != glowColor ||
      oldDelegate.glowCount != glowCount ||
      oldDelegate.glowShape != glowShape ||
      oldDelegate.glowBorderRadius != glowBorderRadius ||
      oldDelegate.glowRadiusFactor != glowRadiusFactor ||
      oldDelegate.curve != curve;
}
