import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(31, 31, 31, 1);
const Color primaryColor = Color.fromRGBO(245, 245, 245, 1);
const Color primaryLightColor = Color.fromRGBO(193, 193, 193, 1);
const Color primaryLightShadeColor = Color.fromRGBO(224, 224, 224, 1);

class SquareLoopScreen extends StatefulWidget {
  const SquareLoopScreen({super.key});

  @override
  State<SquareLoopScreen> createState() => _SquareLoopScreenState();
}

class _SquareLoopScreenState extends State<SquareLoopScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  List<AnimationController> controllers = [];
  late Animation<double> downAnimation;
  List<Animation<double>> upAnimations = [];

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    downAnimation = Tween<double>(begin: 0, end: 30).animate(controller);

    for (int i = 0; i < 16; i++) {
      controllers.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)));
      upAnimations
          .add(Tween<double>(begin: 0, end: 50).animate(controllers[i]));
    }

    controllers[0].addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        for (int i = 1; i < 16; i++) {
          Future.delayed(Duration(milliseconds: 150 * i), () {
            controllers[i].forward();
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    for (int i = 0; i < 16; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            controller.reset();
            controller.forward();
            for (int i = 0; i < 16; i++) {
              controllers[i].reset();
            }
            controllers[0].forward();
          },
          label: const Text(
            'Animate',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          )),
      body: AnimatedBuilder(
          animation: Listenable.merge([controller, ...controllers]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, downAnimation.value),
              child: CustomPaint(
                painter: SquareLoopPainter(movement: upAnimations),
                size: MediaQuery.of(context).size,
              ),
            );
          }),
    );
  }
}

class SquareLoopPainter extends CustomPainter {
  SquareLoopPainter({
    required this.movement,
  });
  final List<Animation<double>> movement;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Offset offset = Offset(w * 0.5, h * 0.4);
    double squareHeight = h * 0.4;
    double squareCornerWidth = 30;
    double squareCornerHeight = 20;

    Paint primaryPaint = Paint()..color = primaryColor;
    Paint primaryLightPaint(topOffset) => Paint()
      ..color = primaryLightColor
      ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryLightColor, primaryLightColor, Colors.black])
          .createShader(
              Rect.fromCenter(center: topOffset, width: w, height: h));
    Paint primaryLightShadePaint(topOffset) => Paint()
      ..color = primaryLightShadeColor
      ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryLightShadeColor,
            primaryLightShadeColor,
            Colors.black
          ]).createShader(
          Rect.fromCenter(center: topOffset, width: w, height: h));

    drawSquare(Offset topOffset) {
      // bottom
      double topOffsetY = topOffset.dy + h * 0.3;
      canvas.drawPath(
          Path()
            ..moveTo(topOffset.dx - squareCornerWidth, topOffsetY)
            ..lineTo(topOffset.dx, topOffsetY - squareCornerHeight)
            ..lineTo(topOffset.dx + squareCornerWidth, topOffsetY)
            ..lineTo(topOffset.dx, topOffsetY + squareCornerHeight)
            ..close(),
          primaryPaint);

      // left - back layer
      canvas.drawPath(
          Path()
            ..moveTo(topOffset.dx - squareCornerWidth, topOffset.dy)
            ..lineTo(topOffset.dx, topOffset.dy - squareCornerHeight)
            ..lineTo(
                topOffset.dx, topOffset.dy - squareCornerHeight + squareHeight)
            ..lineTo(
                topOffset.dx - squareCornerWidth, topOffset.dy + squareHeight)
            ..close(),
          primaryLightShadePaint(topOffset));

      // right - back layer
      canvas.drawPath(
          Path()
            ..moveTo(topOffset.dx, topOffset.dy - squareCornerHeight)
            ..lineTo(topOffset.dx + squareCornerWidth, topOffset.dy)
            ..lineTo(
                topOffset.dx + squareCornerWidth, topOffset.dy + squareHeight)
            ..lineTo(
                topOffset.dx, topOffset.dy - squareCornerHeight + squareHeight)
            ..close(),
          primaryLightPaint(topOffset));

      // right - front layer
      canvas.drawPath(
          Path()
            ..moveTo(topOffset.dx, topOffset.dy + squareCornerHeight)
            ..lineTo(topOffset.dx - squareCornerWidth, topOffset.dy)
            ..lineTo(
                topOffset.dx - squareCornerWidth, topOffset.dy + squareHeight)
            ..lineTo(
                topOffset.dx, topOffset.dy + squareCornerHeight + squareHeight)
            ..close(),
          primaryLightPaint(topOffset));

      // left - front layer
      canvas.drawPath(
        Path()
          ..moveTo(topOffset.dx + squareCornerWidth, topOffset.dy)
          ..lineTo(topOffset.dx, topOffset.dy + squareCornerHeight)
          ..lineTo(
              topOffset.dx, topOffset.dy + squareCornerHeight + squareHeight)
          ..lineTo(
              topOffset.dx + squareCornerWidth, topOffset.dy + squareHeight)
          ..close(),
        primaryLightShadePaint(topOffset),
      );

      // top
      canvas.drawPath(
          Path()
            ..moveTo(topOffset.dx - squareCornerWidth, topOffset.dy)
            ..lineTo(topOffset.dx, topOffset.dy - squareCornerHeight)
            ..lineTo(topOffset.dx + squareCornerWidth, topOffset.dy)
            ..lineTo(topOffset.dx, topOffset.dy + squareCornerHeight)
            ..close(),
          primaryPaint);
    }

    // top middle
    Offset topOffset =
        Offset(offset.dx + w * 0.0, offset.dy - (30 * 5 + movement[0].value));
    drawSquare(topOffset);

    // top right
    topOffset =
        Offset(offset.dx + w * 0.1, offset.dy - (30 * 4 + movement[1].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx + w * 0.2, offset.dy - (30 * 3 + movement[2].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx + w * 0.3, offset.dy - (30 * 2 + movement[3].value));
    drawSquare(topOffset);

    // right corner
    topOffset =
        Offset(offset.dx + w * 0.4, offset.dy - (30 * 1 + movement[4].value));
    drawSquare(topOffset);

    // top left
    topOffset =
        Offset(offset.dx - w * 0.1, offset.dy - (30 * 4 + movement[15].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx - w * 0.2, offset.dy - (30 * 3 + movement[14].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx - w * 0.3, offset.dy - (30 * 2 + movement[13].value));
    drawSquare(topOffset);

    // left corner
    topOffset =
        Offset(offset.dx - w * 0.4, offset.dy - (30 * 1 + movement[12].value));
    drawSquare(topOffset);

    // bottom right
    topOffset =
        Offset(offset.dx + w * 0.3, offset.dy + (30 * 0 - movement[5].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx + w * 0.2, offset.dy + (30 * 1 - movement[6].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx + w * 0.1, offset.dy + (30 * 2 - movement[7].value));
    drawSquare(topOffset);

    // bottom left
    topOffset =
        Offset(offset.dx - w * 0.3, offset.dy + (30 * 0 - movement[11].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx - w * 0.2, offset.dy + (30 * 1 - movement[10].value));
    drawSquare(topOffset);

    topOffset =
        Offset(offset.dx - w * 0.1, offset.dy + (30 * 2 - movement[9].value));
    drawSquare(topOffset);

    // bottom middle
    topOffset =
        Offset(offset.dx + w * 0.0, offset.dy + (30 * 3 - movement[8].value));
    drawSquare(topOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
