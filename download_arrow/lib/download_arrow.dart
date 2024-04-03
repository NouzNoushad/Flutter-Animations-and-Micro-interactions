import 'package:flutter/material.dart';

class DownloadArrowScreen extends StatefulWidget {
  const DownloadArrowScreen({super.key});

  @override
  State<DownloadArrowScreen> createState() => _DownloadArrowScreenState();
}

class _DownloadArrowScreenState extends State<DownloadArrowScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<Offset> arrowEdgeAnimation;
  late Animation<Offset> arrowLineAnimation;
  late Animation<Offset> moveUpAnimation;
  late Animation<Offset> liquidArcAnimation;
  late Animation<Offset> liquidHeightAnimation;
  late Animation<double> opacityAnimation;

  bool showComplete = false;

  initAnimation() {
    arrowEdgeAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.02), end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(parent: _controller1, curve: const Interval(0.0, 0.4)),
    );
    arrowLineAnimation = Tween<Offset>(
            begin: const Offset(0.0, -0.02), end: const Offset(0.0, 0.0))
        .animate(
      _controller1,
    );
    moveUpAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.5, 0.42))
        .animate(
      _controller1,
    );

    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller2, curve: const Interval(0.0, 0.3)),
    );

    liquidArcAnimation = Tween<Offset>(
            begin: const Offset(0.06, -0.08), end: const Offset(0.06, 0.08))
        .animate(
      CurvedAnimation(parent: _controller2, curve: const Interval(0.1, 0.9)),
    );
    liquidHeightAnimation = Tween<Offset>(
            begin: const Offset(0.125, -0.08), end: const Offset(0.125, 0.08))
        .animate(
      CurvedAnimation(parent: _controller2, curve: const Interval(0.5, 1.0)),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        moveUpAnimation = Tween<Offset>(
                begin: const Offset(0.5, 0.42), end: const Offset(0.5, 0.58))
            .animate(
          CurvedAnimation(
              parent: _controller2, curve: const Interval(0.2, 1.0)),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller2.forward();
        });
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            showComplete = true;
          });
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
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
      backgroundColor: const Color.fromRGBO(218, 224, 239, 1),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            _controller1,
            _controller2,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: DesignArrow(
                    arrowEdge: arrowEdgeAnimation.value,
                    arrowLine: arrowLineAnimation.value,
                    moveUp: moveUpAnimation.value,
                    liquidArc: liquidArcAnimation.value,
                    liquidHeight: liquidHeightAnimation.value,
                    opacity: opacityAnimation.value,
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
                      height: size.height * 0.18,
                      width: size.width * 0.3,
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class DesignArrow extends CustomPainter {
  DesignArrow({
    required this.arrowEdge,
    required this.arrowLine,
    required this.moveUp,
    required this.liquidHeight,
    required this.liquidArc,
    required this.opacity,
    required this.showComplete,
  });
  final Offset arrowEdge;
  final Offset arrowLine;
  final Offset moveUp;
  final Offset liquidHeight;
  final Offset liquidArc;
  final double opacity;
  final bool showComplete;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    // shadow
    canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset(offset.dx, offset.dy),
                  width: w * 0.25,
                  height: h * 0.16),
              const Radius.circular(10))),
        Colors.black,
        10,
        false);

    canvas.clipRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(offset.dx, offset.dy),
            width: w * 0.25,
            height: h * 0.16),
        const Radius.circular(10)));

    // background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(offset.dx, offset.dy),
              width: w * 0.25,
              height: h * 0.16),
          const Radius.circular(10)),
      Paint()..color = const Color.fromRGBO(37, 65, 222, 1),
    );

    // arrow
    Offset edgeOffset = Offset(w * 0.5, h * 0.5);
    canvas.drawPath(
        Path()
          ..moveTo(edgeOffset.dx - w * 0.032, edgeOffset.dy)
          ..lineTo(edgeOffset.dx + w * arrowEdge.dx,
              edgeOffset.dy + h * arrowEdge.dy) // 0.02 -> 0.0
          ..lineTo(edgeOffset.dx + w * 0.032, edgeOffset.dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withOpacity(opacity));

    Offset lineOffset = Offset(w * moveUp.dx, h * moveUp.dy); // 0.5 -> 0.42
    canvas.drawLine(
        Offset(lineOffset.dx + w * arrowLine.dx,
            lineOffset.dy + h * arrowLine.dy), // -0.02 -> 0.0
        Offset(lineOffset.dx, lineOffset.dy + h * 0.02),
        paint);

    // liquid
    Offset liquidOffset = Offset(w * 0.5, h * 0.5);
    Offset heightOffset = Offset(liquidHeight.dx, liquidHeight.dy);
    Offset arcOffset = Offset(liquidArc.dx, liquidArc.dy);
    canvas.drawPath(
        Path()
          ..moveTo(liquidOffset.dx - w * 0.125, liquidOffset.dy - h * 0.08)
          ..lineTo(liquidOffset.dx + w * 0.125, liquidOffset.dy - h * 0.08)
          ..lineTo(liquidOffset.dx + w * heightOffset.dx,
              liquidOffset.dy + h * heightOffset.dy)
          ..cubicTo(
              liquidOffset.dx + w * arcOffset.dx,
              liquidOffset.dy + h * arcOffset.dy,
              liquidOffset.dx - w * arcOffset.dx,
              liquidOffset.dy + h * arcOffset.dy,
              liquidOffset.dx - w * heightOffset.dx,
              liquidOffset.dy + h * heightOffset.dy)
          ..lineTo(liquidOffset.dx - w * 0.125, liquidOffset.dy - h * 0.08),
        Paint()..color = const Color.fromRGBO(75, 221, 134, 1));

    if (showComplete) {
      // complete icon
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.03, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.02)
            ..lineTo(
                completeOffset.dx + w * 0.05, completeOffset.dy - h * 0.02),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
