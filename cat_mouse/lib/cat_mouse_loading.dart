import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(90, 67, 111, 1);
const Color skinColor = Color.fromRGBO(200, 198, 201, 1);
const Color faceColor = Color.fromRGBO(126, 122, 141, 1);
const Color whiteColor = Colors.white;

class CatMouseLoadingScreen extends StatefulWidget {
  const CatMouseLoadingScreen({super.key});

  @override
  State<CatMouseLoadingScreen> createState() => _CatMouseLoadingScreenState();
}

class _CatMouseLoadingScreenState extends State<CatMouseLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> rotationAnimation;
  late Animation<double> eyeLidAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();

    rotationAnimation =
        Tween<double>(begin: 0.0, end: -2 * pi).animate(_controller);
    eyeLidAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -0.032), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.032, end: -0.032), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.032, end: 0.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.45, 1.0)));

    opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CatMousePainter(
                  rotation: rotationAnimation.value,
                  eyeLidHeight: eyeLidAnimation.value,
                  textOpacity: opacityAnimation.value),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class CatMousePainter extends CustomPainter {
  CatMousePainter(
      {required this.rotation,
      required this.eyeLidHeight,
      required this.textOpacity});
  final double rotation;
  final double eyeLidHeight;
  final double textOpacity;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    rotateBackground(double angle) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);

      Offset mouseOffset = Offset(w * 0.2, h * 0.5);
      canvas.drawCircle(Offset(mouseOffset.dx, mouseOffset.dy), w * 0.03,
          Paint()..color = Colors.white);

      canvas.drawPath(
          Path()
            ..moveTo(mouseOffset.dx, mouseOffset.dy + h * 0.04)
            ..lineTo(mouseOffset.dx - w * 0.03, mouseOffset.dy)
            ..lineTo(mouseOffset.dx + w * 0.03, mouseOffset.dy)
            ..close(),
          Paint()..color = Colors.white);

      canvas.drawCircle(
          Offset(mouseOffset.dx - w * 0.02, mouseOffset.dy + h * 0.022),
          w * 0.010,
          Paint()..color = Colors.white);
      canvas.drawCircle(
          Offset(mouseOffset.dx + w * 0.02, mouseOffset.dy + h * 0.022),
          w * 0.010,
          Paint()..color = Colors.white);

      canvas.drawArc(
          Rect.fromCircle(center: offset, radius: w * 0.3),
          pi,
          pi * 1.2,
          false,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4);
      canvas.restore();
    }

    rotateEyes(double angle, Offset eyeOffset) {
      canvas.save();
      canvas.translate(eyeOffset.dx, eyeOffset.dy);
      canvas.rotate(angle);
      canvas.translate(-eyeOffset.dx, -eyeOffset.dy);

      canvas.drawCircle(Offset(eyeOffset.dx - w * 0.03, eyeOffset.dy),
          w * 0.013, Paint()..color = faceColor);

      canvas.restore();
    }

    drawText(String text, Offset offset, Color color) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 22,
              color: color.withOpacity(textOpacity),
              fontWeight: FontWeight.w600,
              letterSpacing: 6),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // double rotation = -pi * 0.5;
    rotateBackground(rotation);

    // cat
    canvas.drawPath(
        Path()
          ..moveTo(offset.dx - w * 0.13, offset.dy)
          ..cubicTo(
              offset.dx - w * 0.15,
              offset.dy + h * 0.1,
              offset.dx + w * 0.15,
              offset.dy + h * 0.1,
              offset.dx + w * 0.13,
              offset.dy)
          ..lineTo(offset.dx + w * 0.12, offset.dy - h * 0.08)
          ..quadraticBezierTo(offset.dx + w * 0.1, offset.dy - h * 0.1,
              offset.dx + w * 0.08, offset.dy - h * 0.08)
          ..lineTo(offset.dx + w * 0.055, offset.dy - h * 0.06)
          ..quadraticBezierTo(offset.dx, offset.dy - h * 0.075,
              offset.dx - w * 0.055, offset.dy - h * 0.06)
          ..lineTo(offset.dx - w * 0.08, offset.dy - h * 0.08)
          ..quadraticBezierTo(offset.dx - w * 0.1, offset.dy - h * 0.1,
              offset.dx - w * 0.12, offset.dy - h * 0.08)
          ..lineTo(offset.dx - w * 0.13, offset.dy),
        Paint()..color = skinColor);

    // eye
    canvas.drawCircle(Offset(offset.dx - w * 0.056, offset.dy - h * 0.01),
        w * 0.053, Paint()..color = whiteColor);
    canvas.drawCircle(Offset(offset.dx + w * 0.056, offset.dy - h * 0.01),
        w * 0.053, Paint()..color = whiteColor);

    drawEyeLid(Offset eyeOffset) {
      canvas.drawPath(
          Path()
            ..moveTo(eyeOffset.dx - w * 0.062, eyeOffset.dy + h * eyeLidHeight)
            ..quadraticBezierTo(eyeOffset.dx, eyeOffset.dy - h * 0.075,
                eyeOffset.dx + w * 0.062, eyeOffset.dy + h * eyeLidHeight)
            ..close(),
          Paint()
            ..color = skinColor
            ..style = PaintingStyle.fill
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4);
    }

    Offset leftEyeOffset = Offset(offset.dx - w * 0.056, offset.dy - h * 0.01);
    rotateEyes(rotation, leftEyeOffset);
    drawEyeLid(leftEyeOffset);

    Offset rightEyeOffset = Offset(offset.dx + w * 0.056, offset.dy - h * 0.01);
    rotateEyes(rotation, rightEyeOffset);
    drawEyeLid(rightEyeOffset);

    // nose
    canvas.drawPath(
        Path()
          ..addArc(Rect.fromCircle(center: offset, radius: w * 0.035), 0, pi)
          ..close(),
        Paint()..color = faceColor);

    canvas.drawLine(Offset(offset.dx, offset.dy + h * 0.02),
        Offset(offset.dx, offset.dy + h * 0.04), paint);

    // mouth
    canvas.drawPath(
        Path()
          ..addArc(
              Rect.fromCircle(
                  center: Offset(offset.dx, offset.dy + h * 0.04),
                  radius: w * 0.023),
              0,
              pi)
          ..close(),
        Paint()..color = whiteColor);
    canvas.drawPath(
        Path()
          ..addArc(
              Rect.fromCircle(
                  center: Offset(offset.dx, offset.dy + h * 0.04),
                  radius: w * 0.023),
              0,
              pi)
          ..close(),
        paint);

    // text
    drawText('Loading...'.toUpperCase(),
        Offset(offset.dx - w * 0.15, offset.dy + h * 0.35), skinColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
