import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(234, 234, 234, 1);

class OriginalTimerScreen extends StatefulWidget {
  const OriginalTimerScreen({super.key});

  @override
  State<OriginalTimerScreen> createState() => _OriginalTimerScreenState();
}

class _OriginalTimerScreenState extends State<OriginalTimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double needlePosition = 0.0;
  Timer? timer;
  double count = 0;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: size.height * 0.04,
                left: size.width * 0.18,
                child: Text(
                  (count.toStringAsFixed(2)).padLeft(5, '0'),
                  style: const TextStyle(
                      fontSize: 115,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'FjallaOne'),
                )),
            Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    needlePosition += 0.01;
                    count += 0.1;
                  });
                },
                onPanEnd: (details) {
                  controller.forward();
                  timer =
                      Timer.periodic(const Duration(milliseconds: 50), (timer) {
                    if (needlePosition <= 0.0) {
                      timer.cancel();
                      controller.reverse();
                    } else {
                      setState(() {
                        needlePosition -= 0.01;
                        count -= 0.1;
                      });
                    }
                    if (count <= 0.0) {
                      setState(() {
                        count = 0.0;
                      });
                    }
                  });
                },
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.5,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: TimerPainter(needlePosition: needlePosition),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0.0,
                left: 0.0,
                child: GestureDetector(
                  onTap: () {
                    timer?.cancel();
                    controller.reverse();
                    setState(() {
                      needlePosition = 0.0;
                      count = 0.0;
                    });
                  },
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: const Offset(0, -0.05))
                        .animate(controller),
                    child: Container(
                      height: size.height * 0.09,
                      width: size.width,
                      color: Colors.white,
                      child: const Center(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.replay),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Reset',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({required this.needlePosition});
  final double needlePosition;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    double centerX = w * 0.5;
    double centerY = h * 0.5;
    double radius = w * 0.28;
    double innerCircleRadius = radius;
    double outerCircleRadius = radius + 5;

    Offset offset = Offset(centerX, centerY);
    Paint borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint divisionPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;
    double startAngle = 0.0;

    // numbers
    drawNumbers(int i) {
      var sweepAngle = 0.0835 * 360 * pi / 180.0;
      final radius = w * 0.9;
      final c = Offset(w * 0.5, h * 0.5);
      final r = radius * 0.42;
      final dx = r * cos(startAngle + sweepAngle * -3);
      final dy = r * sin(startAngle + sweepAngle * -3);
      final position = c + Offset(dx, dy);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: ((i ~/ 5) - (i ~/ 30)).toString(),
          style: const TextStyle(
              fontFamily: 'FjallaOne',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final pos = position +
          Offset(-textPainter.width * 0.5, -textPainter.height * 0.5);
      textPainter.paint(canvas, pos);

      startAngle += sweepAngle;
    }

    // outer circle
    canvas.drawShadow(
        Path()..addOval(Rect.fromCircle(center: offset, radius: w * 0.45)),
        Colors.black,
        10,
        true);
    canvas.drawCircle(offset, w * 0.45, Paint()..color = backgroundColor);

    double i = (4.5 + needlePosition) * 60;
    var needleX = centerX + w * 0.29 * cos(i * pi / 180);
    var needleY = centerY + w * 0.29 * sin(i * pi / 180);
    canvas.drawLine(
        offset,
        Offset(needleX, needleY),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10
          ..color = Colors.black);

    // divisions
    for (int i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        outerCircleRadius = radius + 15;
        drawNumbers(i);
      } else {
        outerCircleRadius = radius + 5;
      }
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), divisionPaint);
    }

    // inner circle
    canvas.drawShadow(
        Path()..addOval(Rect.fromCircle(center: offset, radius: w * 0.25)),
        Colors.black,
        10,
        true);
    canvas.drawCircle(offset, w * 0.25, Paint()..color = backgroundColor);
    canvas.drawCircle(offset, w * 0.22, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
