import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(1, 20, 3, 1);
const Color primaryColor = Color.fromRGBO(98, 226, 192, 1);
const Color secondaryColor = Color.fromRGBO(211, 234, 145, 1);

class CoolTimerScreen extends StatefulWidget {
  const CoolTimerScreen({super.key});

  @override
  State<CoolTimerScreen> createState() => _CoolTimerScreenState();
}

class _CoolTimerScreenState extends State<CoolTimerScreen> {
  Timer? timer;
  int counter = 0;
  bool isStarted = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        counter += 1;
      });
      if (counter >= 120) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 1800), () {
          setState(() {
            counter = 0;
            isStarted = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: isStarted
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () {
                startTimer();
                setState(() {
                  isStarted = true;
                });
              },
              label: const Text(
                'Start',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
      body: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: CustomPaint(
                painter: CoolTimerPainter(increment: counter),
                size: MediaQuery.of(context).size,
              ),
            ),
          ),
          Center(
            child: Text(
              '$counter%',
              style: const TextStyle(
                  fontSize: 60,
                  fontFamily: 'FjallaOne',
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class CoolTimerPainter extends CustomPainter {
  CoolTimerPainter({required this.increment});
  final int increment;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    double radius = w * 0.4;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..shader = const RadialGradient(radius: 0.45, colors: [
        primaryColor,
        secondaryColor,
      ]).createShader(Rect.fromCircle(center: offset, radius: radius));

    double thickness = 40;
    double r = radius - (thickness * 0.6);
    double outerCircleRadius = r;
    double innerCircleRadius = r - thickness;

    // outer circle
    canvas.drawArc(
        Rect.fromCircle(center: offset, radius: radius),
        0,
        pi * 0.01 * 1.8 * increment,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..shader = const RadialGradient(radius: 3.4, colors: [
            secondaryColor,
            primaryColor,
          ], stops: [
            0.8,
            0.5
          ]).createShader(Rect.fromCircle(center: offset, radius: 30)));

    // inner circle
    for (int i = 0; i <= 3.2 * increment; i += 3) {
      var x1 = offset.dx + outerCircleRadius * cos(i * pi / 180);
      var x2 = offset.dx + innerCircleRadius * cos(i * pi / 180);
      var y1 = offset.dy + outerCircleRadius * sin(i * pi / 180);
      var y2 = offset.dy + innerCircleRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
