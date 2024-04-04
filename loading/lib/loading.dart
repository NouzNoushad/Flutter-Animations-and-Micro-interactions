import 'dart:async';

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? timer;
  double progress = 0.0;
  bool isDownloading = false;

  void startDownload() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.05;
      });
      if (progress >= 1) {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            progress = 0.0;
            isDownloading = false;
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: isDownloading
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
              onPressed: () {
                startDownload();
                setState(() {
                  isDownloading = true;
                });
              },
              label: const Text('Download')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: size.height * 0.05,
            width: size.width * 0.9,
            color: Colors.transparent,
            child: CustomPaint(
              painter: ProgressPainter(
                progress: progress,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter({required this.progress});
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    // border
    canvas.drawRect(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w, height: h),
        paint);
    // progress
    for (double i = 0.04; i < progress; i += 0.04) {
      // 0.5+
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(w * i, h * 0.5), width: 12, height: h * 0.7),
          Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
