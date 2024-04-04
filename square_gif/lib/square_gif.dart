import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(200, 200, 200, 1);
const Color squareLeftFaceColor = Color.fromRGBO(155, 152, 153, 1);
const Color squareRightFaceColor = Color.fromRGBO(213, 213, 215, 1);
const Color squareTopFaceColor = Color.fromRGBO(221, 221, 221, 1);

class SquareGifScreen extends StatefulWidget {
  const SquareGifScreen({super.key});

  @override
  State<SquareGifScreen> createState() => _SquareGifScreenState();
}

class _SquareGifScreenState extends State<SquareGifScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;

  late Animation<Offset> topLeftBottomRightAnimation;
  late Animation<Offset> bottomLeftTopRightAnimation;
  late Animation<Offset> cornerLeftAnimation;
  late Animation<Offset> cornerRightAnimation;

  initAnimation() {
    topLeftBottomRightAnimation = Tween<Offset>(
            begin: const Offset(1.0, 1.0), end: const Offset(1.0, 0.2))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    bottomLeftTopRightAnimation = Tween<Offset>(
            begin: const Offset(1.0, 1.0), end: const Offset(0.0, 0.8))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    cornerLeftAnimation = Tween<Offset>(
            begin: const Offset(1.0, 1.0), end: const Offset(0.5, 1.06))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    cornerRightAnimation = Tween<Offset>(
            begin: const Offset(1.0, 1.0), end: const Offset(0.5, 0.94))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        topLeftBottomRightAnimation = Tween<Offset>(
                begin: const Offset(1.0, 0.2), end: const Offset(2.0, 0.0))
            .animate(
                CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
        bottomLeftTopRightAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.8), end: const Offset(-1.0, 1.0))
            .animate(
                CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
        cornerLeftAnimation = Tween<Offset>(
                begin: const Offset(0.5, 1.06), end: const Offset(0.5, 1.26))
            .animate(
                CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
        cornerRightAnimation = Tween<Offset>(
                begin: const Offset(0.5, 0.94), end: const Offset(0.5, 0.74))
            .animate(
                CurvedAnimation(parent: controller1, curve: Curves.easeInOut));

        controller1.forward();
      }
    });

    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.reset();
          controller1.reset();
          initAnimation();
          controller.forward();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            controller.reset();
            controller1.reset();
            initAnimation();
            controller.forward();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge([controller, controller1]),
          builder: (context, child) {
            return CustomPaint(
              painter: GifPainter(
                topLeftBottomRight: topLeftBottomRightAnimation.value,
                bottomLeftTopRight: bottomLeftTopRightAnimation.value,
                cornerLeft: cornerLeftAnimation.value,
                cornerRight: cornerRightAnimation.value,
              ),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class GifPainter extends CustomPainter {
  GifPainter({
    required this.topLeftBottomRight,
    required this.bottomLeftTopRight,
    required this.cornerLeft,
    required this.cornerRight,
  });
  final Offset topLeftBottomRight;
  final Offset bottomLeftTopRight;
  final Offset cornerLeft;
  final Offset cornerRight;

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.grey;

    Paint rightFacePaint = Paint()..color = squareRightFaceColor;
    Paint leftFacePaint = Paint()..color = squareLeftFaceColor;
    Paint topFacePaint = Paint()..color = squareTopFaceColor;

    // draw square
    double squareHeight = h * 0.07;
    double squareWidth = w * 0.155;
    double sh = h * 0.03;

    drawSquare(Offset offset) {
      paintSquare(Paint right, Paint left, Paint top) {
        // front right
        canvas.drawPath(
            Path()
              ..moveTo(offset.dx, offset.dy)
              ..lineTo(offset.dx + squareWidth, offset.dy - sh)
              ..lineTo(offset.dx + squareWidth, offset.dy + squareHeight)
              ..lineTo(offset.dx, offset.dy + sh + squareHeight)
              ..close(),
            right);

        // front left
        canvas.drawPath(
            Path()
              ..moveTo(offset.dx, offset.dy)
              ..lineTo(offset.dx - squareWidth, offset.dy - sh)
              ..lineTo(offset.dx - squareWidth, offset.dy + squareHeight)
              ..lineTo(offset.dx, offset.dy + sh + squareHeight)
              ..close(),
            left);

        // top
        canvas.drawPath(
            Path()
              ..moveTo(offset.dx, offset.dy)
              ..lineTo(offset.dx - squareWidth, offset.dy - sh)
              ..lineTo(offset.dx, offset.dy - 2 * sh)
              ..lineTo(offset.dx + squareWidth, offset.dy - sh)
              ..close(),
            top);
      }

      // fill paint
      paintSquare(rightFacePaint, leftFacePaint, topFacePaint);
      // border paint
      paintSquare(paint, paint, paint);
    }

    double sHeight = squareHeight + h * 0.06;
    double sWidth = squareWidth;

    // corner right
    Offset offset5 = Offset(offset.dx + 2 * sWidth * cornerRight.dx,
        offset.dy * cornerRight.dy); // (1, 1) -> (0.5, 0.94) -> (0.5, 0.7)
    drawSquare(offset5);

    // top left
    Offset offset4 = Offset(offset.dx - sWidth * topLeftBottomRight.dx,
        offset.dy - sHeight * topLeftBottomRight.dy);
    drawSquare(offset4); // (1, 1) -> (1, 0.2) -> (2, 0)

    // bottom left
    Offset offset2 = Offset(offset.dx - sWidth * bottomLeftTopRight.dx,
        offset.dy + sHeight * bottomLeftTopRight.dy);
    drawSquare(offset2); // (1, 1) -> (0.0, 0.8) -> (-1, 1)

    // center
    drawSquare(offset);

    // bottom right
    Offset offset1 = Offset(
        offset.dx + sWidth * topLeftBottomRight.dx,
        offset.dy +
            sHeight * topLeftBottomRight.dy); // (1, 1) -> (1, 0.2) -> (2, 0.0)
    drawSquare(offset1);

    // top right
    Offset offset3 = Offset(
        offset.dx + sWidth * bottomLeftTopRight.dx,
        offset.dy -
            sHeight * bottomLeftTopRight.dy); // (1, 1) -> (0.0, 0.8) -> (-1, 1)
    drawSquare(offset3);

    // corner left
    Offset offset6 = Offset(offset.dx - sWidth * 2 * cornerLeft.dx,
        offset.dy * cornerLeft.dy); // (1, 1) -> (0.5, 1.06) -> (0.5, 1.3)
    drawSquare(offset6);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
