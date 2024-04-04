import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(242, 243, 238, 1);
const Color topColor = Color.fromRGBO(153, 208, 103, 1);
const Color leftColor = Color.fromRGBO(11, 6, 52, 1);
const Color rightColor = Color.fromRGBO(5, 149, 148, 1);

class TriangleSquareScreen extends StatefulWidget {
  const TriangleSquareScreen({super.key});

  @override
  State<TriangleSquareScreen> createState() => _TriangleSquareScreenState();
}

class _TriangleSquareScreenState extends State<TriangleSquareScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> movement1;
  late Animation<Offset> movement2;
  late Animation<Offset> movement3;
  late Animation<Offset> movement4;
  late Animation<Offset> movement5;
  late Animation<Offset> movement6;
  late Animation<Offset> movement7;
  late Animation<Offset> movement8;
  late Animation<Offset> movement9;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();

    movement1 = Tween<Offset>(
            begin: const Offset(0.18, -0.21), end: const Offset(0.0, -0.15))
        .animate(_controller);
    movement2 = Tween<Offset>(
            begin: const Offset(0.18, -0.09), end: const Offset(0.18, -0.21))
        .animate(_controller);
    movement3 = Tween<Offset>(
            begin: const Offset(0.18, 0.03), end: const Offset(0.18, -0.09))
        .animate(_controller);
    movement4 = Tween<Offset>(
            begin: const Offset(0.18, 0.15), end: const Offset(0.18, 0.03))
        .animate(_controller);
    movement5 = Tween<Offset>(
            begin: const Offset(0.0, -0.15), end: const Offset(-0.18, -0.09))
        .animate(_controller);
    movement6 = Tween<Offset>(
            begin: const Offset(-0.18, -0.09), end: const Offset(-0.36, -0.03))
        .animate(_controller);
    movement7 = Tween<Offset>(
            begin: const Offset(-0.36, -0.03), end: const Offset(-0.18, 0.03))
        .animate(_controller);
    movement8 = Tween<Offset>(
            begin: const Offset(-0.18, 0.03), end: const Offset(0.0, 0.09))
        .animate(_controller);
    movement9 = Tween<Offset>(
            begin: const Offset(0.0, 0.09), end: const Offset(0.18, 0.15))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: TrianglePainter(
                movement1: movement1.value,
                movement2: movement2.value,
                movement3: movement3.value,
                movement4: movement4.value,
                movement5: movement5.value,
                movement6: movement6.value,
                movement7: movement7.value,
                movement8: movement8.value,
                movement9: movement9.value,
              ),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.movement1,
    required this.movement2,
    required this.movement3,
    required this.movement4,
    required this.movement5,
    required this.movement6,
    required this.movement7,
    required this.movement8,
    required this.movement9,
  });
  final Offset movement1;
  final Offset movement2;
  final Offset movement3;
  final Offset movement4;
  final Offset movement5;
  final Offset movement6;
  final Offset movement7;
  final Offset movement8;
  final Offset movement9;

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;

    // Paint paint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.stroke;

    double squareHeight = h * 0.02;
    double squareWidth = w * 0.09;
    double sh = h * 0.03;

    drawSquare(Offset offset) {
      // front right
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx + squareWidth, offset.dy - sh)
            ..lineTo(offset.dx + squareWidth, offset.dy + squareHeight)
            ..lineTo(offset.dx, offset.dy + sh + squareHeight)
            ..close(),
          Paint()..color = rightColor);

      // front left
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx - squareWidth, offset.dy - sh)
            ..lineTo(offset.dx - squareWidth, offset.dy + squareHeight)
            ..lineTo(offset.dx, offset.dy + sh + squareHeight)
            ..close(),
          Paint()..color = leftColor);

      // top
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx, offset.dy)
            ..lineTo(offset.dx - squareWidth, offset.dy - sh)
            ..lineTo(offset.dx, offset.dy - 2 * sh)
            ..lineTo(offset.dx + squareWidth, offset.dy - sh)
            ..close(),
          Paint()..color = topColor);
    }

    //line
    Offset offset = Offset(w * 0.58, h * 0.55);

    Offset offset1 =
        Offset(offset.dx + w * movement4.dx, offset.dy + h * movement4.dy);
    drawSquare(offset1);

    Offset offset2 =
        Offset(offset.dx + w * movement3.dx, offset.dy + h * movement3.dy);
    drawSquare(offset2);

    Offset offset3 =
        Offset(offset.dx + w * movement2.dx, offset.dy + h * movement2.dy);
    drawSquare(offset3);

    Offset offset4 =
        Offset(offset.dx + w * movement1.dx, offset.dy + h * movement1.dy);
    drawSquare(offset4);

    // top
    Offset offset5 =
        Offset(offset.dx + w * movement5.dx, offset.dy + h * movement5.dy);
    drawSquare(offset5);

    Offset offset6 =
        Offset(offset.dx + w * movement6.dx, offset.dy + h * movement6.dy);
    drawSquare(offset6);

    Offset offset7 =
        Offset(offset.dx + w * movement7.dx, offset.dy + h * movement7.dy);
    drawSquare(offset7);

    // bottom
    Offset offset8 =
        Offset(offset.dx + w * movement8.dx, offset.dy + h * movement8.dy);
    drawSquare(offset8);

    Offset offset9 =
        Offset(offset.dx + w * movement9.dx, offset.dy + h * movement9.dy);
    drawSquare(offset9);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
