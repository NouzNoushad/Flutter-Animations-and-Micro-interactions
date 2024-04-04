import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(60, 76, 168, 1);
const Color primaryColor = Color.fromRGBO(186, 195, 245, 1);

class DownloadProgressScreen extends StatefulWidget {
  const DownloadProgressScreen({super.key});

  @override
  State<DownloadProgressScreen> createState() => _DownloadProgressScreenState();
}

class _DownloadProgressScreenState extends State<DownloadProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> slideAnimation;
  late Animation<Offset> arrowEdgeAnimation;
  late Animation<Offset> arrowMidAnimation;
  late Animation<double> progressAnimation;
  late Animation<double> arcAnimation;

  bool showComplete = false;

  initAnimation() {
    slideAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.5, 0.56))
        .animate(_controller1);
    arrowEdgeAnimation = Tween<Offset>(
            begin: const Offset(-0.07, 0.02), end: const Offset(-0.1, 0.049))
        .animate(CurvedAnimation(
            parent: _controller1, curve: const Interval(0.5, 1.0)));
    arrowMidAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.062), end: const Offset(-0.02, 0.062))
        .animate(CurvedAnimation(
            parent: _controller1, curve: const Interval(0.8, 1.0)));

    progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller2);

    arcAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller3);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller2.forward();
        });
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller3.forward();
        });
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            showComplete = true;
          });
        });

        Future.delayed(const Duration(milliseconds: 1500), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showComplete = false;
    });
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    initAnimation();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation:
              Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: SendButtonPainter(
                      arrowEdgeOffset: arrowEdgeAnimation.value,
                      arrowMidOffset: arrowMidAnimation.value,
                      arrowSlide: slideAnimation.value,
                      progress: progressAnimation.value,
                      arcProgress: arcAnimation.value,
                      showComplete: showComplete),
                  size: size,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _controller1.reset();
                      _controller1.forward();
                    },
                    child: Container(
                      height: size.height * 0.5,
                      width: size.width * 0.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class SendButtonPainter extends CustomPainter {
  SendButtonPainter({
    required this.arrowSlide,
    required this.arrowEdgeOffset,
    required this.arrowMidOffset,
    required this.progress,
    required this.arcProgress,
    required this.showComplete,
  });
  final Offset arrowSlide;
  final Offset arrowEdgeOffset;
  final Offset arrowMidOffset;
  final double progress;
  final double arcProgress;
  final bool showComplete;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = primaryColor;

    // arrow back
    Offset arrowBackOffset = Offset(
        w * arrowSlide.dx, h * arrowSlide.dy); // (0.5, 0.5) -> (0.5, 0.56)
    canvas.drawLine(Offset(arrowBackOffset.dx, arrowBackOffset.dy - h * 0.057),
        Offset(arrowBackOffset.dx, arrowBackOffset.dy + h * 0.057), paint);

    // arrow point
    canvas.drawPath(
        Path()
          ..moveTo(
              arrowBackOffset.dx + w * arrowEdgeOffset.dx,
              arrowBackOffset.dy +
                  h * arrowEdgeOffset.dy) // (-0.07, 0.02) -> (-0.1, 0.045)
          ..quadraticBezierTo(
              arrowBackOffset.dx + w * arrowMidOffset.dx,
              arrowBackOffset.dy +
                  h * arrowMidOffset.dy, // (0.0, 0.065) -> (-0.02, 0.065)
              arrowBackOffset.dx,
              arrowBackOffset.dy + h * 0.056) // (0.0, 0.056)
          ..quadraticBezierTo(
              arrowBackOffset.dx + w * -arrowMidOffset.dx,
              arrowBackOffset.dy +
                  h * arrowMidOffset.dy, // (0.0, 0.065) -> (0.02, 0.065)
              arrowBackOffset.dx + w * -arrowEdgeOffset.dx,
              arrowBackOffset.dy +
                  h * arrowEdgeOffset.dy), // (0.07, 0.02) -> (0.1, 0.045)
        paint);

    // left arc
    canvas.drawArc(Rect.fromCircle(center: offset, radius: w * 0.25), 1.6,
        pi * progress, false, paint);
    // right arc
    canvas.drawArc(Rect.fromCircle(center: offset, radius: w * 0.25), 1.6,
        -pi * progress, false, paint);

    // filled arc
    canvas.drawArc(Rect.fromCircle(center: offset, radius: w * 0.25), 1.6,
        pi * arcProgress, true, Paint()..color = primaryColor);

    if (showComplete) {
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.04)
            ..lineTo(
                completeOffset.dx + w * 0.08, completeOffset.dy - h * 0.05),
          Paint()
            ..color = backgroundColor
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
