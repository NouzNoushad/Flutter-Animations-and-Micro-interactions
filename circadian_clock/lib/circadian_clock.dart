import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CircadianClockScreen extends StatefulWidget {
  const CircadianClockScreen({super.key});

  @override
  State<CircadianClockScreen> createState() => _CircadianClockScreenState();
}

class _CircadianClockScreenState extends State<CircadianClockScreen> {
  Timer? timer;
  int needlePosition = 0;
  double rotation = 0.0;
  Color backgroundColor = Colors.white;
  Color foregroundColor = Colors.black;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(microseconds: 1000), (timer) {
      setState(() {});
      needlePosition += 1;
      if (needlePosition >= 360) {
        rotation += 0.1;
        needlePosition = 0;
      }
      if (rotation >= 2) {
        rotation = 0.0;
        backgroundColor =
            backgroundColor == Colors.black ? Colors.white : Colors.black;
        foregroundColor =
            foregroundColor == Colors.white ? Colors.black : Colors.white;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          height: size.height * 0.5,
          width: size.width * 0.9,
          color: Colors.transparent,
          child: CustomPaint(
            painter: ClockPainter(
                rotation: rotation,
                needlePosition: needlePosition,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor),
          ),
        ),
      )),
    );
  }
}

class ClockPainter extends CustomPainter {
  ClockPainter(
      {required this.rotation,
      required this.needlePosition,
      required this.backgroundColor,
      required this.foregroundColor});
  final double rotation;
  final int needlePosition;
  final Color backgroundColor;
  final Color foregroundColor;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    double radius = w * 0.4;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;

    Paint timerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..colorFilter = const ColorFilter.mode(Colors.pink, BlendMode.difference);

    double outerCircleRadius = radius;
    double innerCircleRadius = radius - 40;
    Paint foregroundFillPaint = Paint()..color = foregroundColor;
    Paint backgroundFillPaint = Paint()..color = backgroundColor;

    // background
    canvas.drawShadow(
        Path()..addOval(Rect.fromCircle(center: offset, radius: radius)),
        Colors.black,
        20,
        true);
    canvas.drawCircle(offset, radius, backgroundFillPaint);
    // clock arc
    canvas.drawArc(Rect.fromCircle(center: offset, radius: radius), 0,
        pi * rotation, true, foregroundFillPaint);
    // timer
    int i = needlePosition;
    var x1 = offset.dx + outerCircleRadius * cos(i * pi / 180);
    var x2 = offset.dx + innerCircleRadius * cos(i * pi / 180);
    var y1 = offset.dy + outerCircleRadius * sin(i * pi / 180);
    var y2 = offset.dy + innerCircleRadius * sin(i * pi / 180);
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), timerPaint);
    // border
    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
