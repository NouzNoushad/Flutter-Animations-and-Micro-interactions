import 'dart:math';

import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(91, 120, 133, 1);

class DownloadingScreen extends StatefulWidget {
  const DownloadingScreen({super.key});

  @override
  State<DownloadingScreen> createState() => _DownloadingScreenState();
}

class _DownloadingScreenState extends State<DownloadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  late Animation<double> hitAnimation;
  late Animation<double> bendAnimation;
  late Animation<double> arcAnimation;
  late Animation<double> progressAnimation;
  late Animation<double> completeAnimation;

  bool showArc = true;
  bool showProgress = false;
  bool showComplete = false;

  initAnimation() {
    hitAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.57), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.57, end: 0.5), weight: 1),
    ]).animate(_controller1);
    bendAnimation = Tween<double>(begin: 0.11, end: 0.095).animate(
        CurvedAnimation(parent: _controller1, curve: const Interval(0.5, 1)));

    arcAnimation = Tween<double>(begin: 0, end: 1).animate(_controller2);
    progressAnimation = Tween<double>(begin: 0, end: 2).animate(_controller3);
    completeAnimation =
        Tween<double>(begin: 0.3, end: 0.5).animate(_controller4);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showArc = false;
        });
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            showProgress = true;
          });
          _controller3.forward();
        });
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            showComplete = true;
          });
          hitAnimation =
              Tween<double>(begin: 0.5, end: 0.7).animate(_controller4);
          _controller4.forward();
        });
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showArc = true;
      showProgress = false;
      showComplete = false;
    });
    initAnimation();
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _controller1.forward();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [_controller1, _controller2, _controller3, _controller4]),
          builder: (context, child) {
            return CustomPaint(
              painter: DownloadingPainter(
                  hitHeight: hitAnimation.value,
                  bendLength: bendAnimation.value,
                  showArc: showArc,
                  showProgress: showProgress,
                  arcSweep: arcAnimation.value,
                  progress: progressAnimation.value,
                  completeHeight: completeAnimation.value,
                  showComplete: showComplete),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class DownloadingPainter extends CustomPainter {
  DownloadingPainter(
      {required this.bendLength,
      required this.hitHeight,
      required this.arcSweep,
      required this.showArc,
      required this.showProgress,
      required this.progress,
      required this.showComplete,
      required this.completeHeight});
  final double bendLength;
  final double hitHeight;
  final bool showArc;
  final double arcSweep;
  final bool showProgress;
  final double progress;
  final bool showComplete;
  final double completeHeight;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);

    drawDownloadIcon(Offset iconOffset) {
      // icon
      double iconEdge = 0.08;
      double iconCorner = 0.034;
      double iconHeight = 0.05;
      double iconEnd = 0.045;

      canvas.drawPath(
          Path()
            ..moveTo(iconOffset.dx, iconOffset.dy + h * iconEnd)
            ..lineTo(iconOffset.dx - w * iconEdge, iconOffset.dy)
            ..lineTo(iconOffset.dx - w * iconCorner, iconOffset.dy)
            ..lineTo(
                iconOffset.dx - w * iconCorner, iconOffset.dy - h * iconHeight)
            ..lineTo(
                iconOffset.dx + w * iconCorner, iconOffset.dy - h * iconHeight)
            ..lineTo(iconOffset.dx + w * iconCorner, iconOffset.dy)
            ..lineTo(iconOffset.dx + w * iconEdge, iconOffset.dy)
            ..close(),
          Paint()..color = primaryColor);
    }

    if (showComplete) {
      // cut
      canvas.clipRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(center: offset, radius: w * 0.23),
            Radius.circular(h * 0.5)),
      );
    }

    // download icon
    Offset iconOffset = Offset(w * 0.5, h * hitHeight);
    drawDownloadIcon(iconOffset);

    if (showComplete) {
      // drawCompleteIcon
      Offset completeOffset = Offset(w * 0.5, h * completeHeight);
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.04)
            ..lineTo(
                completeOffset.dx + w * 0.08, completeOffset.dy - h * 0.05),
          Paint()
            ..color = const Color.fromARGB(255, 0, 211, 7)
            ..strokeWidth = 15
            ..style = PaintingStyle.stroke);
    }

    // left arc
    canvas.drawArc(
        Rect.fromCircle(center: offset, radius: w * 0.22),
        1.6,
        pi * arcSweep,
        false,
        Paint()
          ..color = const Color.fromRGBO(200, 208, 211, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);
    // right arc
    canvas.drawArc(
        Rect.fromCircle(center: offset, radius: w * 0.22),
        1.6,
        -pi * arcSweep,
        false,
        Paint()
          ..color = const Color.fromRGBO(200, 208, 211, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);

    if (showProgress) {
      // circular progress
      canvas.drawArc(
          Rect.fromCircle(center: offset, radius: w * 0.22),
          -1.6,
          pi * progress,
          false,
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10);
    }

    if (showArc) {
      // download base
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx + w * -0.09,
                offset.dy + h * bendLength) 
            ..cubicTo(
                offset.dx + w * -0.04, 
                offset.dy + h * 0.11,
                offset.dx + w * 0.04, 
                offset.dy + h * 0.11,
                offset.dx + w * 0.09, 
                offset.dy + h * bendLength),
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
