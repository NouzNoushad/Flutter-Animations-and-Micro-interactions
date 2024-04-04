import 'dart:math';

import 'package:flutter/material.dart';

class MicroDownloadScreen extends StatefulWidget {
  const MicroDownloadScreen({super.key});

  @override
  State<MicroDownloadScreen> createState() => _MicroDownloadScreenState();
}

class _MicroDownloadScreenState extends State<MicroDownloadScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> arrowEndPointAnimation;
  late Animation<Offset> arrowMiddlePointAnimation;
  late Animation<Offset> arrowLineToDotAnimation;
  late Animation<Offset> arrowDotAnimation;
  late Animation<double> waveAnimation;
  late Animation<double> progressAnimation;

  bool showArrow = true;
  bool showWaves = false;
  bool showProgress = false;
  bool showComplete = false;
  bool showDot = true;

  initAnimation() {
    arrowLineToDotAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.1), end: const Offset(0.0, 0.005))
        .animate(_controller1);

    arrowEndPointAnimation = Tween<Offset>(
            begin: const Offset(0.07, 0.01), end: const Offset(0.12, 0.0))
        .animate(_controller2);
    arrowMiddlePointAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.05), end: const Offset(0.0, 0.0))
        .animate(_controller2);

    arrowDotAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.5, 0.405))
        .animate(CurvedAnimation(
            parent: _controller2, curve: const Interval(0.6, 1.0)));

    waveAnimation = TweenSequence([
      for (int i = 0; i < 5; i++)
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.015, end: -0.015), weight: 1),
    ]).animate(_controller3);

    progressAnimation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_controller3);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller2.forward();
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showDot = false;
          showArrow = false;
          showWaves = true;
          showProgress = true;
        });
        _controller3.forward();
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showWaves = false;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
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
      showDot = true;
      showArrow = true;
      showWaves = false;
      showProgress = false;
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
      backgroundColor: const Color.fromRGBO(27, 150, 233, 1),
      body: AnimatedBuilder(
          animation:
              Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: CustomPaint(
                    painter: MicroDownloadPainter(
                        arrowEndPoint: arrowEndPointAnimation.value,
                        arrowMiddleLine: arrowLineToDotAnimation.value,
                        arrowMiddlePoint: arrowMiddlePointAnimation.value,
                        dotHeight: arrowDotAnimation.value,
                        waveHeight: waveAnimation.value,
                        showArrow: showArrow,
                        showWaves: showWaves,
                        showDot: showDot,
                        progress: progressAnimation.value,
                        showProgress: showProgress,
                        showComplete: showComplete),
                    size: size,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _controller1.reset();
                      _controller1.forward();
                    },
                    child: Container(
                      height: size.height * 0.25,
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

class MicroDownloadPainter extends CustomPainter {
  MicroDownloadPainter({
    required this.arrowEndPoint,
    required this.arrowMiddleLine,
    required this.arrowMiddlePoint,
    required this.dotHeight,
    required this.waveHeight,
    required this.showArrow,
    required this.showWaves,
    required this.showProgress,
    required this.showComplete,
    required this.showDot,
    required this.progress,
  });
  final Offset arrowEndPoint;
  final Offset arrowMiddleLine;
  final Offset arrowMiddlePoint;
  final Offset dotHeight;
  final double waveHeight;
  final bool showArrow;
  final bool showWaves;
  final bool showProgress;
  final bool showComplete;
  final bool showDot;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 3.2;

    drawText() {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '0${progress.toStringAsFixed(2)} mb',
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(w * 0.42, h * 0.53));
    }

    // border
    canvas.drawCircle(
        offset,
        w * 0.2,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white12
          ..strokeWidth = 6);

    // download icon
    Offset downloadOffset = Offset(w * 0.5, h * 0.5);

    if (showArrow) {
      canvas.drawPath(
          Path()
            ..moveTo(downloadOffset.dx - w * arrowEndPoint.dx,
                downloadOffset.dy + h * arrowEndPoint.dy)
            ..lineTo(downloadOffset.dx + arrowMiddlePoint.dx,
                downloadOffset.dy + h * arrowMiddlePoint.dy)
            ..lineTo(downloadOffset.dx + w * arrowEndPoint.dx,
                downloadOffset.dy + h * arrowEndPoint.dy),
          paint);
    }

    // mocking wave animation
    if (showWaves) {
      canvas.drawPath(
          Path()
            ..moveTo(downloadOffset.dx + w * 0.12, downloadOffset.dy)
            ..quadraticBezierTo(
                downloadOffset.dx + w * 0.08,
                downloadOffset.dy + h * waveHeight,
                downloadOffset.dx + w * 0.06,
                downloadOffset.dy)
            ..quadraticBezierTo(
                downloadOffset.dx + w * 0.04,
                downloadOffset.dy - h * waveHeight,
                downloadOffset.dx + w * 0.02,
                downloadOffset.dy)
            ..quadraticBezierTo(
                downloadOffset.dx + w * 0.0,
                downloadOffset.dy + h * waveHeight,
                downloadOffset.dx - w * 0.02,
                downloadOffset.dy)
            ..quadraticBezierTo(
                downloadOffset.dx - w * 0.04,
                downloadOffset.dy - h * waveHeight,
                downloadOffset.dx - w * 0.06,
                downloadOffset.dy)
            ..quadraticBezierTo(
                downloadOffset.dx - w * 0.08,
                downloadOffset.dy + h * waveHeight,
                downloadOffset.dx - w * 0.12,
                downloadOffset.dy),
          paint);

      drawText();
    }

    if (showDot) {
      Offset dotOffset = Offset(w * dotHeight.dx, h * dotHeight.dy);
      canvas.drawRect(
          Rect.fromCenter(
              center: dotOffset,
              width: w * arrowMiddleLine.dx,
              height: h * arrowMiddleLine.dy),
          paint);
    }

    if (showProgress) {
      // progress
      canvas.drawArc(Rect.fromCircle(center: offset, radius: w * 0.2), -1.6,
          -pi * progress, false, paint);
    }

    if (showComplete) {
      // complete icon
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.04)
            ..lineTo(
                completeOffset.dx + w * 0.08, completeOffset.dy - h * 0.05),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
