import 'dart:math';

import 'package:flutter/material.dart';

class GhostAnimation extends StatefulWidget {
  const GhostAnimation({super.key});

  @override
  State<GhostAnimation> createState() => _GhostAnimationState();
}

class _GhostAnimationState extends State<GhostAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> flyAnimation;
  late Animation<double> shadowAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();

    flyAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -40), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -40, end: 0), weight: 1),
    ]).animate(controller);

    shadowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 1),
    ]).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(230, 82, 143, 1),
      body: Center(
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform(
                    transform:
                        Matrix4.translationValues(0, flyAnimation.value, 0),
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width * 0.6,
                      color: Colors.transparent,
                      child: CustomPaint(
                        painter: GhostPainter(),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: shadowAnimation.value,
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.6,
                      color: Colors.transparent,
                      child: CustomPaint(
                        painter: GhostShadowPainter(),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class GhostShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    // shadow
    canvas.drawLine(
        Offset(w * 0.15, h * 0.5),
        Offset(w * 0.85, h * 0.5),
        Paint()
          ..strokeWidth = 14
          ..color = const Color.fromRGBO(207, 23, 124, 1)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GhostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Paint paint = Paint()
      ..color = const Color.fromRGBO(0, 35, 54, 1)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Ghost
    drawGhost(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.15, h * 0.4)
            ..lineTo(w * 0.15, h * 0.9)
            ..lineTo(w * 0.35, h * 0.8)
            ..lineTo(w * 0.5, h * 0.9)
            ..lineTo(w * 0.65, h * 0.8)
            ..lineTo(w * 0.85, h * 0.9)
            ..lineTo(w * 0.85, h * 0.4)
            ..addArc(
                Rect.fromCircle(center: Offset(w * 0.5, h * 0.4), radius: 75.5),
                0,
                -pi),
          paint);
    }

    drawGhost(Paint()..color = const Color.fromRGBO(245, 195, 60, 1));
    drawGhost(paint);

    // eye
    drawEyes(xPosition) {
      canvas.drawCircle(Offset(w * (0.5 + xPosition), h * 0.4), 3, paint);
    }

    drawEyes(-0.12); // left
    drawEyes(0.12); // right
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
