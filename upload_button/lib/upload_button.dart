import 'package:flutter/material.dart';

class UploadButtonScreen extends StatefulWidget {
  const UploadButtonScreen({super.key});

  @override
  State<UploadButtonScreen> createState() => _UploadButtonScreenState();
}

class _UploadButtonScreenState extends State<UploadButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> buttonAnimation;
  late Animation<double> radiusAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<Offset> indicatorAnimation;
  late Animation<double> progressAnimation;
  late Animation<int> countAnimation;
  late Animation<double> angleAnimation;

  bool showButton = true;
  bool showContainer = false;
  bool showIndicator = false;
  bool showComplete = false;

  initAnimation() {
    buttonAnimation = Tween<Offset>(
            begin: const Offset(0.32, 0.15), end: const Offset(0.85, 0.04))
        .animate(_controller1);
    radiusAnimation =
        Tween<double>(begin: 0.5, end: 0.01).animate(_controller1);
    colorAnimation = ColorTween(begin: Colors.indigo, end: Colors.white)
        .animate(_controller1);

    countAnimation = IntTween(begin: 0, end: 100).animate(_controller2);
    progressAnimation =
        Tween<double>(begin: -0.43, end: 0.43).animate(_controller2);
    angleAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(
        CurvedAnimation(parent: _controller2, curve: const Interval(0.0, 0.2)));
    indicatorAnimation = Tween<Offset>(
            begin: const Offset(0.1, 0.57), end: const Offset(0.9, 0.48))
        .animate(CurvedAnimation(
            parent: _controller2, curve: const Interval(0.0, 1.0)));
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            showIndicator = true;
          });
          _controller2.forward();
        });
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            showIndicator = false;
          });
          buttonAnimation = Tween<Offset>(
                  begin: const Offset(0.85, 0.04),
                  end: const Offset(0.32, 0.15))
              .animate(_controller3);
          radiusAnimation =
              Tween<double>(begin: 0.01, end: 0.5).animate(_controller1);
          colorAnimation = ColorTween(
                  begin: Colors.white, end: const Color.fromRGBO(12, 218, 4, 1))
              .animate(_controller3);
          _controller3.forward();
        });
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
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
      showButton = true;
      showContainer = false;
      showIndicator = false;
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
      backgroundColor: const Color.fromRGBO(23, 46, 116, 1),
      body: AnimatedBuilder(
          animation:
              Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: UploadPainter(
                    showButton: showButton,
                    showContainer: showContainer,
                    color: colorAnimation.value!,
                    buttonOffset: buttonAnimation.value,
                    radius: radiusAnimation.value,
                    angle: angleAnimation.value,
                    progress: progressAnimation.value,
                    indicatorOffset: indicatorAnimation.value,
                    count: countAnimation.value,
                    showIndicator: showIndicator,
                    showComplete: showComplete,
                  ),
                  size: size,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showButton = false;
                        showContainer = true;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _controller1.reset();
                        _controller1.forward();
                      });
                    },
                    child: Container(
                      height: size.height * 0.1,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class UploadPainter extends CustomPainter {
  UploadPainter({
    required this.buttonOffset,
    required this.radius,
    required this.color,
    required this.showButton,
    required this.showContainer,
    required this.indicatorOffset,
    required this.count,
    required this.progress,
    required this.angle,
    required this.showIndicator,
    required this.showComplete,
  });
  final Offset buttonOffset;
  final double radius;
  final Color color;
  final bool showButton;
  final bool showContainer;
  final bool showIndicator;
  final bool showComplete;
  final Offset indicatorOffset;
  final int count;
  final double progress;
  final double angle;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35
      ..color = const Color.fromRGBO(15, 80, 245, 1);
    Offset offset = Offset(w * 0.5, h * 0.5);

    drawText(String text, Offset offset, Color color, double size) {
      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: size, color: color, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    drawIcon(IconData iconData, Offset offset) {
      IconData icon = iconData;
      TextPainter textPainter = TextPainter(
          textAlign: TextAlign.center, textDirection: TextDirection.rtl);
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontSize: 40.0,
              fontFamily: icon.fontFamily,
              color: Colors.white));
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    drawProgressIndicator(Offset progressOffset) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center:
                      Offset(progressOffset.dx, progressOffset.dy - h * 0.1),
                  width: w * 0.16,
                  height: h * 0.06),
              Radius.circular(h * 0.015)),
          Paint()..color = const Color.fromRGBO(235, 40, 82, 1));
      canvas.drawPath(
          Path()
            ..moveTo(progressOffset.dx - w * 0.01, progressOffset.dy - h * 0.07)
            ..lineTo(progressOffset.dx + w * 0.01, progressOffset.dy - h * 0.07)
            ..lineTo(progressOffset.dx, progressOffset.dy - h * 0.055)
            ..close(),
          Paint()..color = const Color.fromRGBO(235, 40, 82, 1));

      drawText(
          '$count%',
          Offset(progressOffset.dx - w * 0.04, progressOffset.dy - h * 0.115),
          color,
          18);
    }

    rotateProgressIndicator(
      Offset progressOffset,
      double angle,
    ) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);
      drawProgressIndicator(progressOffset);
      canvas.restore();
    }

    if (showButton) {
      // background
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: offset, width: w * 0.5, height: h * 0.1),
              const Radius.circular(15)),
          Paint()..color = const Color.fromRGBO(15, 80, 245, 1));

      // text and icon
      drawText(
          'Upload'.toUpperCase(),
          Offset(offset.dx - w * 0.05, offset.dy - h * 0.015),
          Colors.white,
          22);
      drawIcon(Icons.cloud_upload,
          Offset(offset.dx - w * 0.17, offset.dy - h * 0.03));
    }

    if (showContainer) {
      // circle
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: offset,
                  width: w * buttonOffset.dx,
                  height: h * buttonOffset.dy),
              Radius.circular(h * radius)),
          Paint()..color = color);

      if (showIndicator) {
        // progress indicator
        Offset progressOffset =
            Offset(w * indicatorOffset.dx, h * indicatorOffset.dy);
        rotateProgressIndicator(progressOffset, 0.2);

        // background cut
        canvas.clipRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: offset,
                  width: w * buttonOffset.dx,
                  height: h * buttonOffset.dy),
              Radius.circular(h * radius)),
        );

        // progress
        canvas.drawLine(Offset(offset.dx - w * 0.43, offset.dy),
            Offset(offset.dx + w * progress, offset.dy), paint);
      }
    }

    if (showComplete) {
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.04)
            ..lineTo(
                completeOffset.dx + w * 0.08, completeOffset.dy - h * 0.04),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 8
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
