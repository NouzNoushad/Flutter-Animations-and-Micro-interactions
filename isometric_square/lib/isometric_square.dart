import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(241, 241, 241, 1);
const Color topColor = Color.fromRGBO(149, 164, 182, 1);
const Color leftColor = Color.fromRGBO(64, 68, 72, 1);
const Color rightColor = Color.fromRGBO(57, 57, 57, 1);

class IsometricSquareScreen extends StatefulWidget {
  const IsometricSquareScreen({super.key});

  @override
  State<IsometricSquareScreen> createState() => _IsometricSquareScreenState();
}

class _IsometricSquareScreenState extends State<IsometricSquareScreen>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  late Animation<Offset> movement1;
  late Animation<Offset> movement2;
  late Animation<Offset> movement3;
  late Animation<Offset> movement4;
  late Animation<Offset> movement5;
  late Animation<Offset> movement6;

  bool showTopLeft = false;
  bool showTopCenter = false;
  bool showTopRight = false;
  bool showBottomRight = false;
  bool showBottomCenter = false;
  bool showBottomLeft = false;

  @override
  void initState() {
    super.initState();
    int duration = 400;
    for (int i = 1; i <= 6; i++) {
      _controllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: duration)));
    }

    movement1 = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.14, -0.044))
        .animate(
            CurvedAnimation(parent: _controllers[0], curve: Curves.easeInOut));
    movement2 = Tween<Offset>(
            begin: const Offset(-0.14, -0.044), end: const Offset(0.0, -0.088))
        .animate(
            CurvedAnimation(parent: _controllers[1], curve: Curves.easeInOut));
    movement3 = Tween<Offset>(
            begin: const Offset(0.0, -0.088), end: const Offset(0.14, -0.044))
        .animate(
            CurvedAnimation(parent: _controllers[2], curve: Curves.easeInOut));
    movement4 = Tween<Offset>(
            begin: const Offset(0.14, -0.044), end: const Offset(0.14, 0.046))
        .animate(
            CurvedAnimation(parent: _controllers[3], curve: Curves.easeInOut));
    movement5 = Tween<Offset>(
            begin: const Offset(0.14, 0.046), end: const Offset(0.0, 0.09))
        .animate(
            CurvedAnimation(parent: _controllers[4], curve: Curves.easeInOut));
    movement6 = Tween<Offset>(
            begin: const Offset(0.0, 0.09), end: const Offset(-0.14, 0.046))
        .animate(
            CurvedAnimation(parent: _controllers[5], curve: Curves.easeInOut));

    _controllers[0].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showTopCenter = true;
        });
        _controllers[1].forward();
      }
    });

    _controllers[1].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showTopRight = true;
        });
        _controllers[2].forward();
      }
    });

    _controllers[2].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showBottomRight = true;
        });
        _controllers[3].forward();
      }
    });

    _controllers[3].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showBottomCenter = true;
        });
        _controllers[4].forward();
      }
    });

    _controllers[4].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showBottomLeft = true;
        });
        _controllers[5].forward();
      }
    });

    _controllers[5].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          resetControllers();
          _controllers[0].forward();
        });
      }
    });
  }

  resetControllers() {
    setState(() {
      showTopRight = false;
      showTopCenter = false;
      showTopLeft = true;
      showBottomRight = false;
      showBottomCenter = false;
      showBottomLeft = false;
    });
    _controllers[0].reset();
    _controllers[1].reset();
    _controllers[2].reset();
    _controllers[3].reset();
    _controllers[4].reset();
    _controllers[5].reset();
  }

  @override
  void dispose() {
    _controllers[0].dispose();
    _controllers[1].dispose();
    _controllers[2].dispose();
    _controllers[3].dispose();
    _controllers[4].dispose();
    _controllers[5].dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            resetControllers();
            _controllers[0].forward();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge([..._controllers]),
          builder: (context, child) {
            return CustomPaint(
              painter: IsometricPainter(
                  showTopLeft: showTopLeft,
                  showTopCenter: showTopCenter,
                  showTopRight: showTopRight,
                  showBottomRight: showBottomRight,
                  showBottomCenter: showBottomCenter,
                  showBottomLeft: showBottomLeft,
                  topLeftOffset: movement1.value,
                  topCenterOffset: movement2.value,
                  topRightOffset: movement3.value,
                  bottomRightOffset: movement4.value,
                  bottomCenterOffset: movement5.value,
                  bottomLeftOffset: movement6.value),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class IsometricPainter extends CustomPainter {
  IsometricPainter(
      {required this.topLeftOffset,
      required this.topCenterOffset,
      required this.topRightOffset,
      required this.bottomRightOffset,
      required this.bottomCenterOffset,
      required this.bottomLeftOffset,
      required this.showTopCenter,
      required this.showTopLeft,
      required this.showTopRight,
      required this.showBottomRight,
      required this.showBottomCenter,
      required this.showBottomLeft});

  final bool showTopLeft;
  final bool showTopCenter;
  final bool showTopRight;
  final bool showBottomRight;
  final bool showBottomCenter;
  final bool showBottomLeft;

  final Offset topLeftOffset;
  final Offset topCenterOffset;
  final Offset topRightOffset;
  final Offset bottomRightOffset;
  final Offset bottomCenterOffset;
  final Offset bottomLeftOffset;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint topPaint = Paint()..color = topColor;
    Paint leftPaint = Paint()..color = leftColor;
    Paint rightPaint = Paint()..color = rightColor;

    // draw square
    double squareHeight = h * 0.04;
    double squareWidth = w * 0.13;
    double sh = h * 0.04;

    drawSquare(Offset offset) {
      // front right
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx + squareWidth, offset.dy - sh)
            ..lineTo(offset.dx + squareWidth, offset.dy + squareHeight)
            ..lineTo(offset.dx, offset.dy + sh + squareHeight)
            ..close(),
          rightPaint);

      // front left
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx - squareWidth, offset.dy - sh)
            ..lineTo(offset.dx - squareWidth, offset.dy + squareHeight)
            ..lineTo(offset.dx, offset.dy + sh + squareHeight)
            ..close(),
          leftPaint);

      // top
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx - squareWidth, offset.dy - sh)
            ..lineTo(offset.dx, offset.dy - 2 * sh)
            ..lineTo(offset.dx + squareWidth, offset.dy - sh)
            ..close(),
          topPaint);
    }

    if (showTopCenter) {
      // top center
      Offset offset3 = Offset(offset.dx + w * topCenterOffset.dx,
          offset.dy + h * topCenterOffset.dy);
      drawSquare(offset3);
    }

    if (showBottomLeft) {
      // bottom left
      Offset offset4 = Offset(offset.dx + w * bottomLeftOffset.dx,
          offset.dy + h * bottomLeftOffset.dy);
      drawSquare(offset4);
    }

    if (showBottomRight) {
      // bottom right
      Offset offset5 = Offset(offset.dx + w * bottomRightOffset.dx,
          offset.dy + h * bottomRightOffset.dy);
      drawSquare(offset5);
    }

    if (showBottomCenter) {
      // bottom center
      Offset offset6 = Offset(offset.dx + w * bottomCenterOffset.dx,
          offset.dy + h * bottomCenterOffset.dy);
      drawSquare(offset6);
    }

    if (showTopRight) {
      // top right
      Offset offset2 = Offset(
          offset.dx + w * topRightOffset.dx, offset.dy + h * topRightOffset.dy);
      drawSquare(offset2);
    }

    if (showTopLeft) {
      // top left
      Offset offset1 = Offset(
          offset.dx + w * topLeftOffset.dx, offset.dy + h * topLeftOffset.dy);
      drawSquare(offset1);
    }

    // middle
    drawSquare(offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
