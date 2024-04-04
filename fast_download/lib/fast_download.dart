import 'dart:math';

import 'package:flutter/material.dart';

class FastDownloadScreen extends StatefulWidget {
  const FastDownloadScreen({super.key});

  @override
  State<FastDownloadScreen> createState() => _FastDownloadScreenState();
}

class _FastDownloadScreenState extends State<FastDownloadScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late AnimationController _controller6;
  late AnimationController _controller7;

  late Animation<Offset> arrowEdgeAnimation;
  late Animation<Offset> arrowResizeAnimation;
  late Animation<Offset> arrowJumpAnimation;
  late Animation<double> rotationAnimation;
  late Animation<Offset> throwAnimation;
  late Animation<Offset> progressAnimation;
  late Animation<double> opacityAnimation;
  late Animation<int> countAnimation;
  late Animation<double> dotAnimation;
  late Animation<double> circleProgressAnimation;

  bool showArrowEdge = true;
  bool showDot = false;
  bool showProgress = false;
  bool showStart = false;
  bool showDotProgress = false;
  bool showBorder = false;
  bool showComplete = false;

  initAnimation() {
    arrowEdgeAnimation = Tween<Offset>(
            begin: const Offset(0.05, 0.01), end: const Offset(0.0, 0.04))
        .animate(_controller1);
    arrowResizeAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.08), end: const Offset(0.0, 0.005))
        .animate(_controller1);
    arrowJumpAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.5, 0.4))
        .animate(_controller1);

    rotationAnimation =
        Tween<double>(begin: 0.0, end: 765.0).animate(_controller2);
    throwAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(0.25, 0.25))
        .animate(_controller3);

    opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller4);

    progressAnimation = Tween<Offset>(
            begin: const Offset(-0.5, 0.25), end: const Offset(0.25, 0.25))
        .animate(_controller5);
    countAnimation = IntTween(begin: 0, end: 100).animate(_controller5);

    dotAnimation = Tween<double>(begin: 0.75, end: 0.01).animate(
        CurvedAnimation(parent: _controller6, curve: const Interval(0.0, 0.5)));

    circleProgressAnimation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_controller7);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 450,
        ));
    _controller2 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));
    _controller3 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    _controller4 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 800,
        ));

    _controller5 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));
    _controller6 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 800,
        ));
    _controller7 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 800,
        ));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showArrowEdge = false;
          showDot = true;
        });

        Future.delayed(
            const Duration(
              milliseconds: 300,
            ), () {
          _controller2.forward();
        });
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller3.forward();
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showProgress = true;
        });
        throwAnimation = Tween<Offset>(
                begin: const Offset(0.25, 0.25), end: const Offset(-0.49, 0.25))
            .animate(_controller4);
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller4.forward();
        });
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showStart = true;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          _controller5.forward();
        });
      }
    });

    _controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        progressAnimation = Tween<Offset>(
                begin: const Offset(0.25, 0.25), end: const Offset(0.25, -0.03))
            .animate(CurvedAnimation(
                parent: _controller6, curve: const Interval(0.5, 1.0)));

        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            showProgress = false;
            showDot = false;
            showStart = false;
            showDotProgress = true;
          });
          _controller6.forward();
        });
      }
    });

    _controller6.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            showBorder = true;
            showDotProgress = false;
          });
          _controller7.forward();
        });
      }
    });

    _controller7.addStatusListener((status) {
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
      showArrowEdge = true;
      showDot = false;
      showProgress = false;
      showStart = false;
      showDotProgress = false;
      showBorder = false;
      showComplete = false;
    });
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
    _controller5.reset();
    _controller6.reset();
    _controller7.reset();
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
      backgroundColor: const Color.fromRGBO(0, 104, 191, 1),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            _controller1,
            _controller2,
            _controller3,
            _controller4,
            _controller5,
            _controller6,
            _controller7,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: FastDownloadPainter(
                    arrowEdgeOffset: arrowEdgeAnimation.value,
                    arrowJumpOffset: arrowJumpAnimation.value,
                    arrowResizeOffset: arrowResizeAnimation.value,
                    showArrowEdge: showArrowEdge,
                    rotation: rotationAnimation.value,
                    throwOffset: throwAnimation.value,
                    showProgress: showProgress,
                    progressOffset: progressAnimation.value,
                    showStart: showStart,
                    opacity: opacityAnimation.value,
                    count: countAnimation.value,
                    dotProgress: dotAnimation.value,
                    showDotProgress: showDotProgress,
                    showDot: showDot,
                    circleProgress: circleProgressAnimation.value,
                    showBorder: showBorder,
                    showComplete: showComplete,
                  ),
                  size: size,
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

class FastDownloadPainter extends CustomPainter {
  FastDownloadPainter({
    required this.arrowEdgeOffset,
    required this.arrowJumpOffset,
    required this.arrowResizeOffset,
    required this.throwOffset,
    required this.showArrowEdge,
    required this.showProgress,
    required this.rotation,
    required this.progressOffset,
    required this.showStart,
    required this.opacity,
    required this.count,
    required this.dotProgress,
    required this.showDotProgress,
    required this.showDot,
    required this.circleProgress,
    required this.showBorder,
    required this.showComplete,
  });
  final Offset arrowJumpOffset;
  final Offset arrowEdgeOffset;
  final Offset arrowResizeOffset;
  final Offset throwOffset;
  final bool showArrowEdge;
  final bool showProgress;
  final double rotation;
  final Offset progressOffset;
  final bool showStart;
  final double opacity;
  final int count;
  final double dotProgress;
  final bool showDotProgress;
  final bool showDot;
  final double circleProgress;
  final bool showBorder;
  final bool showComplete;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    drawText(String text, Offset offset) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          children: const [
            TextSpan(
                text: ' %',
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(73, 147, 208, 1),
                    fontWeight: FontWeight.w500))
          ],
          style: const TextStyle(
              fontSize: 40, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // border
    canvas.drawCircle(
        offset,
        w * 0.17,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color.fromRGBO(73, 147, 208, 1).withOpacity(opacity)
          ..strokeWidth = 5);

    if (showArrowEdge) {
      // arrow back
      Offset dotOffset = Offset(w * arrowJumpOffset.dx,
          h * arrowJumpOffset.dy); // (0.5, 0.5) -> (0.5, 0.4)
      canvas.drawRect(
          Rect.fromCenter(
              center: dotOffset,
              width: w * arrowResizeOffset.dx,
              height: h * arrowResizeOffset.dy),
          paint); // (0.0, 0.08) -> (0.0, 0.008)

      // arrow
      canvas.drawPath(
          Path()
            ..moveTo(
                offset.dx + w * arrowEdgeOffset.dx,
                offset.dy +
                    h * arrowEdgeOffset.dy) // (0.05, 0.01) -> (0.0, 0.04)
            ..lineTo(offset.dx, offset.dy + h * 0.04)
            ..lineTo(
                offset.dx - w * arrowEdgeOffset.dx,
                offset.dy +
                    h * arrowEdgeOffset.dy), // (0.05, 0.01) -> (0.0, 0.04)
          paint);
    }

    double i = -90 + rotation;
    var x = offset.dx + w * 0.17 * cos(i * pi / 180);
    var y = offset.dy + w * 0.17 * sin(i * pi / 180);

    if (showDot) {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(x + w * throwOffset.dx, y + h * throwOffset.dy),
              width: w * arrowResizeOffset.dx,
              height: h * arrowResizeOffset.dy),
          paint);
    }

    if (showProgress) {
      canvas.drawLine(
          Offset(x + w * 0.25, y + h * 0.25),
          Offset(x + w * throwOffset.dx, y + h * throwOffset.dy),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = const Color.fromRGBO(73, 147, 208, 1)
            ..strokeWidth = 5);
    }

    if (showStart) {
      canvas.drawLine(Offset(x + w * -0.49, y + h * throwOffset.dy),
          Offset(x + w * progressOffset.dx, y + h * progressOffset.dy), paint);

      drawText('$count', Offset(offset.dx - w * 0.08, offset.dy));
    }

    if (showDotProgress) {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(offset.dx, y + h * progressOffset.dy),
              width: w * dotProgress,
              height: h * 0.0),
          paint..color = Colors.white);
    }

    if (showBorder) {
      canvas.drawArc(
          Rect.fromCircle(center: offset, radius: w * 0.17),
          -1.6,
          -pi * circleProgress,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = const Color.fromRGBO(73, 147, 208, 1)
            ..strokeWidth = 5);
    }

    if (showComplete) {
      // complete icon
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(
                completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.015)
            ..lineTo(completeOffset.dx - w * 0.01, completeOffset.dy + h * 0.04)
            ..lineTo(
                completeOffset.dx + w * 0.08, completeOffset.dy - h * 0.04),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
