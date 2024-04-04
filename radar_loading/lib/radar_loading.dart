import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const Color background = Color.fromRGBO(7, 29, 44, 1);
const Color primary = Color.fromRGBO(37, 163, 221, 1);

class RadarLoadingScreen extends StatefulWidget {
  const RadarLoadingScreen({super.key});

  @override
  State<RadarLoadingScreen> createState() => _RadarLoadingScreenState();
}

class _RadarLoadingScreenState extends State<RadarLoadingScreen>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  int radarPosition = 0;
  late AnimationController controller;
  late Animation<double> waveAnimation;
  double target = 0.35;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        radarPosition++;
      });
      if (radarPosition >= 360) {
        int random = Random().nextInt(30);
        target = 0.35 + random * 0.01;
        controller.reset();
        controller.forward();
        radarPosition = 0;
      }
    });
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    waveAnimation = Tween<double>(begin: 0.35, end: 1.5).animate(controller);
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
      backgroundColor: background,
      body: Center(
          child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          height: size.height * 0.5,
          width: size.width * 0.9,
          color: Colors.transparent,
          child: CustomPaint(
            painter: RadarPainter(
                radarPosition: radarPosition,
                waveLength: waveAnimation.value,
                target: target),
          ),
        ),
      )),
    );
  }
}

class RadarPainter extends CustomPainter {
  RadarPainter(
      {required this.radarPosition,
      required this.waveLength,
      required this.target});
  final int radarPosition;
  final double waveLength;
  final double target;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);

    // draw circle
    drawCircle(double radius, Color color, double stroke) {
      canvas.drawCircle(
          offset,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..color = color);
    }

    // background
    canvas.drawCircle(offset, w * 0.35, Paint()..color = primary);

    // 1st inner border
    drawCircle(w * 0.25, Colors.white24, 2.5);

    // 2nd inner border
    drawCircle(w * 0.15, Colors.white24, 2.5);

    // target
    canvas.drawCircle(
        Offset(w * target, h * target),
        w * 0.015,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..color = Colors.white70);

    // radar wave
    int i1 = radarPosition;
    int i2 = i1 - 50;
    int i3 = i1 - 100;
    var xPosition1 = offset.dx + w * 0.35 * cos(i1 * pi / 180);
    var yPosition1 = offset.dy + w * 0.35 * sin(i1 * pi / 180);
    var xPosition2 = offset.dx + w * 0.47 * cos(i2 * pi / 180);
    var yPosition2 = offset.dy + w * 0.47 * sin(i2 * pi / 180);
    var xPosition3 = offset.dx + w * 0.35 * cos(i3 * pi / 180);
    var yPosition3 = offset.dy + w * 0.35 * sin(i3 * pi / 180);

    canvas.drawPath(
        Path()
          ..moveTo(offset.dx, offset.dy)
          ..lineTo(xPosition1, yPosition1)
          ..quadraticBezierTo(xPosition2, yPosition2, xPosition3, yPosition3)
          ..lineTo(offset.dx, offset.dy),
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                Color.fromRGBO(50, 202, 253, 1),
                Color.fromRGBO(50, 202, 253, 0.11),
                primary
              ])
              .createShader(Rect.fromCircle(center: offset, radius: w * 0.35)));

    // radar
    canvas.drawLine(
        offset,
        Offset(xPosition1, yPosition1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white);

    // outer border
    drawCircle(w * 0.35, Colors.white, 8);

    // 3rd inner border
    canvas.drawCircle(offset, w * 0.035, Paint()..color = Colors.white);
    canvas.drawCircle(
        offset,
        w * waveLength,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.white70);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
