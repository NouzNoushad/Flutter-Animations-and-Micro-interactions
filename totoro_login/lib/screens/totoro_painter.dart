import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TotoroPainter extends CustomPainter {
  TotoroPainter(
      {required this.isLogin,
      required this.isTypingPassword,
      required this.isTypingEmail});
  final bool isLogin;
  final bool isTypingPassword;
  final bool isTypingEmail;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    Paint fullPaint = Paint()..color = skinColor;
    Paint nailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = Colors.black54;

    // left ear
    drawLeftEar(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.28, h * 0.28)
            ..lineTo(w * 0.26, h * 0.26)
            ..quadraticBezierTo(w * 0.18, h * 0.3, w * 0.13, h * 0.12)
            ..quadraticBezierTo(w * 0.37, h * 0.22, w * 0.29, h * 0.25)
            ..lineTo(w * 0.33, h * 0.28),
          paint);
    }

    drawLeftEar(fullPaint);
    drawLeftEar(paint);

    // right ear
    drawRightEar(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.72, h * 0.28)
            ..lineTo(w * 0.74, h * 0.26)
            ..quadraticBezierTo(w * 0.82, h * 0.3, w * 0.87, h * 0.12)
            ..quadraticBezierTo(w * 0.63, h * 0.22, w * 0.71, h * 0.25)
            ..lineTo(w * 0.66, h * 0.28),
          paint);
    }

    drawRightEar(fullPaint);
    drawRightEar(paint);

    // totoro head
    drawHead(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.1, h * 0.46)
            ..lineTo(w * 0.12, h * 0.44)
            ..cubicTo(
                w * 0.08, h * 0.16, w * 0.92, h * 0.16, w * 0.88, h * 0.44)
            ..lineTo(w * 0.9, h * 0.46),
          paint);
    }

    drawHead(fullPaint);
    drawHead(paint);

    // head leaf
    drawHeadLeaf(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.34, h * 0.26)
            ..quadraticBezierTo(w * 0.38, h * 0.35, w * 0.52, h * 0.25)
            ..quadraticBezierTo(w * 0.62, h * 0.32, w * 0.65, h * 0.25)
            ..quadraticBezierTo(w * 0.64, h * 0.22, w * 0.52, h * 0.23)
            ..lineTo(w * 0.52, h * 0.15)
            ..lineTo(w * 0.51, h * 0.15)
            ..lineTo(w * 0.5, h * 0.23)
            ..quadraticBezierTo(w * 0.34, h * 0.22, w * 0.34, h * 0.26),
          paint);
    }

    drawHeadLeaf(Paint()..color = leafColor);
    drawHeadLeaf(paint);

    if (isTypingPassword) {
      // left eye
      canvas.drawArc(
          Rect.fromCenter(
              center: Offset(w * 0.27, h * 0.35),
              width: w * 0.08,
              height: h * 0.04),
          0,
          -pi,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round
            ..color = Colors.black);

      // right eye
      canvas.drawArc(
          Rect.fromCenter(
              center: Offset(w * 0.73, h * 0.35),
              width: w * 0.08,
              height: h * 0.04),
          0,
          -pi,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round
            ..color = Colors.black);
    } else {
      // left eyes
      canvas.drawCircle(Offset(w * 0.27, h * 0.35), 18, paint);
      canvas.drawCircle(
          Offset(w * 0.27, h * 0.35), 18, Paint()..color = Colors.white);
      // right eye
      canvas.drawCircle(Offset(w * 0.73, h * 0.35), 18, paint);
      canvas.drawCircle(
          Offset(w * 0.73, h * 0.35), 18, Paint()..color = Colors.white);

      if (isTypingEmail) {
        // left eyeball
        canvas.drawCircle(
            Offset(w * 0.27, h * 0.36), 8, Paint()..color = Colors.black);
        canvas.drawCircle(
            Offset(w * 0.28, h * 0.355), 3, Paint()..color = Colors.white);
        // right eyeball
        canvas.drawCircle(
            Offset(w * 0.73, h * 0.36), 8, Paint()..color = Colors.black);
        canvas.drawCircle(
            Offset(w * 0.74, h * 0.355), 3, Paint()..color = Colors.white);
      } else {
        // left eyeball
        canvas.drawCircle(
            Offset(w * 0.27, h * 0.35), 8, Paint()..color = Colors.black);
        canvas.drawCircle(
            Offset(w * 0.28, h * 0.345), 3, Paint()..color = Colors.white);
        // right eyeball
        canvas.drawCircle(
            Offset(w * 0.73, h * 0.35), 8, Paint()..color = Colors.black);
        canvas.drawCircle(
            Offset(w * 0.74, h * 0.345), 3, Paint()..color = Colors.white);
      }
    }

    // nose
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(w * 0.5, h * 0.35),
            width: w * 0.08,
            height: h * 0.03),
        -0.7,
        -pi * 0.5,
        false,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4);
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.46, h * 0.35)
          ..quadraticBezierTo(w * 0.5, h * 0.33, w * 0.54, h * 0.35)
          ..lineTo(w * 0.5, h * 0.36)
          ..lineTo(w * 0.46, h * 0.35),
        Paint()..color = Colors.black);

    // mouth
    if (isLogin) {
      drawMouth(Paint paint) {
        canvas.drawPath(
            Path()
              ..moveTo(w * 0.28, h * 0.41)
              ..lineTo(w * 0.72, h * 0.41)
              ..quadraticBezierTo(w * 0.5, h * 0.47, w * 0.28, h * 0.41),
            paint);
      }

      drawMouth(Paint()..color = Colors.white);
      drawMouth(paint);

      // teeth
      canvas.drawLine(
          Offset(w * 0.35, h * 0.41), Offset(w * 0.35, h * 0.425), paint);
      canvas.drawLine(
          Offset(w * 0.42, h * 0.41), Offset(w * 0.42, h * 0.435), paint);
      canvas.drawLine(
          Offset(w * 0.5, h * 0.41), Offset(w * 0.5, h * 0.44), paint);
      canvas.drawLine(
          Offset(w * 0.58, h * 0.41), Offset(w * 0.58, h * 0.435), paint);
      canvas.drawLine(
          Offset(w * 0.65, h * 0.41), Offset(w * 0.65, h * 0.425), paint);
    } else {
      // mouth
      canvas.drawLine(
          Offset(w * 0.49, h * 0.43),
          Offset(w * 0.51, h * 0.425),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round
            ..color = Colors.black);
    }

    // left moustache
    canvas.drawLine(
        Offset(w * 0.25, h * 0.4), Offset(w * 0.05, h * 0.38), paint);
    canvas.drawLine(
        Offset(w * 0.25, h * 0.41), Offset(w * 0.03, h * 0.42), paint);
    canvas.drawLine(
        Offset(w * 0.25, h * 0.42), Offset(w * 0.05, h * 0.45), paint);

    // right moustache
    canvas.drawLine(
        Offset(w * 0.75, h * 0.4), Offset(w * 0.95, h * 0.38), paint);
    canvas.drawLine(
        Offset(w * 0.75, h * 0.41), Offset(w * 0.93, h * 0.42), paint);
    canvas.drawLine(
        Offset(w * 0.75, h * 0.42), Offset(w * 0.95, h * 0.45), paint);

    // body shadow
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.5, h * 1.04),
            width: w * 0.75,
            height: h * 0.04),
        Paint()..color = darkColor);

    // lower body
    drawLowerBody(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.02, h * 0.71)
            ..cubicTo(
                w * -0.15, h * 1.15, w * 1.15, h * 1.15, w * 0.98, h * 0.71),
          paint);
    }

    drawLowerBody(fullPaint);
    drawLowerBody(paint);

    // belly
    drawBelly(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.12, h * 0.71)
            ..cubicTo(w * 0.05, h * 1.1, w * 0.95, h * 1.1, w * 0.88, h * 0.71),
          paint);
    }

    drawBelly(Paint()..color = Colors.white);
    drawBelly(paint);

    // login card
    drawCard(Paint paint) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset(w * 0.5, h * 0.62),
                  width: w * 0.85,
                  height: h * 0.32),
              const Radius.circular(15)),
          paint);
    }

    drawCard(Paint()..color = cardColor);
    drawCard(paint);

    // left nail
    canvas.drawLine(
      Offset(w * 0.16, h * 0.69),
      Offset(w * 0.19, h * 0.69),
      nailPaint,
    );
    canvas.drawLine(
      Offset(w * 0.17, h * 0.675),
      Offset(w * 0.21, h * 0.675),
      nailPaint,
    );
    canvas.drawLine(
      Offset(w * 0.17, h * 0.66),
      Offset(w * 0.19, h * 0.66),
      nailPaint,
    );

    // right nail
    canvas.drawLine(
      Offset(w * 0.84, h * 0.69),
      Offset(w * 0.81, h * 0.69),
      nailPaint,
    );
    canvas.drawLine(
      Offset(w * 0.83, h * 0.675),
      Offset(w * 0.79, h * 0.675),
      nailPaint,
    );
    canvas.drawLine(
      Offset(w * 0.83, h * 0.66),
      Offset(w * 0.81, h * 0.66),
      nailPaint,
    );

    // left hand
    drawLeftHand(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.07, h * 0.49)
            ..lineTo(w * 0, h * 0.57)
            ..lineTo(w * 0, h * 0.71)
            ..cubicTo(
                w * 0.2, h * 0.74, w * 0.22, h * 0.63, w * 0.07, h * 0.63),
          paint);
    }

    drawLeftHand(fullPaint);
    drawLeftHand(paint);

    // right hand
    drawRightHand(Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.93, h * 0.49)
            ..lineTo(w * 1, h * 0.57)
            ..lineTo(w * 1, h * 0.71)
            ..cubicTo(
                w * 0.8, h * 0.74, w * 0.78, h * 0.63, w * 0.93, h * 0.63),
          paint);
    }

    drawRightHand(fullPaint);
    drawRightHand(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
