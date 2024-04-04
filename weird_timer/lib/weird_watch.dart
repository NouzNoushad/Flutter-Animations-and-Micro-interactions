import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const Color blueColor = Color.fromRGBO(52, 37, 171, 1);
const Color yellowColor = Color.fromRGBO(235, 221, 28, 1);
const Color blackColor = Color.fromRGBO(39, 39, 37, 1);

class WeirdWatchScreen extends StatefulWidget {
  const WeirdWatchScreen({super.key});

  @override
  State<WeirdWatchScreen> createState() => _WeirdWatchScreenState();
}

class _WeirdWatchScreenState extends State<WeirdWatchScreen>
    with SingleTickerProviderStateMixin {
  double needlePosition = 0.0;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.3,
            child: const Text(
              'Drag and Release',
              style: TextStyle(fontSize: 20, color: Colors.white24),
            ),
          ),
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  needlePosition += 0.01;
                });
              },
              onPanEnd: (details) {
                timer =
                    Timer.periodic(const Duration(milliseconds: 50), (timer) {
                  if (needlePosition <= 0.0) {
                    timer.cancel();
                  } else {
                    setState(() {
                      needlePosition -= 0.01;
                    });
                  }
                });
              },
              child: Container(
                height: size.height * 0.35,
                width: size.width * 0.7,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: WatchPainter(needlePosition: needlePosition),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WatchPainter extends CustomPainter {
  WatchPainter({required this.needlePosition});
  final double needlePosition;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    double centerX = w * 0.5;
    double centerY = h * 0.5;
    Offset offset = Offset(w * 0.5, h * 0.5);
    double radius = w * 0.45;
    double innerCircleRadius = radius - 20;
    double outerCircleRadius = radius;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Paint divisionPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // first
    canvas.drawCircle(offset, w * 0.5, Paint()..color = Colors.white);
    canvas.drawCircle(offset, w * 0.5, paint);

    // second
    canvas.drawCircle(offset, w * 0.45, Paint()..color = yellowColor);
    canvas.drawCircle(offset, w * 0.45, paint);

    // divisions
    for (int i = 0; i <= 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), divisionPaint);
    }
    // pointer
    double i = (4.5 + needlePosition) * 60;
    var minuteHandX = centerX + w * 0.45 * cos(i * pi / 180);
    var minuteHandY = centerY + w * 0.45 * sin(i * pi / 180);
    canvas.drawLine(offset, Offset(minuteHandX, minuteHandY), divisionPaint);
    var minuteHandXc = centerX + w * 0.32 * cos(i * pi / 180);
    var minuteHandYc = centerY + w * 0.32 * sin(i * pi / 180);
    canvas.drawCircle(Offset(minuteHandXc, minuteHandYc), w * 0.02,
        Paint()..color = Colors.white);
    canvas.drawCircle(Offset(minuteHandXc, minuteHandYc), w * 0.02, paint);

    // third
    canvas.drawCircle(offset, w * 0.2, Paint()..color = blueColor);
    // canvas.drawCircle(offset, w * 0.2, paint);

    // fourth
    canvas.drawCircle(offset, w * 0.02, Paint()..color = Colors.white);
    canvas.drawCircle(offset, w * 0.02, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
