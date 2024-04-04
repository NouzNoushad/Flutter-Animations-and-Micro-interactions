import 'package:flutter/material.dart';

class DownloadInteractionScreen extends StatefulWidget {
  const DownloadInteractionScreen({super.key});

  @override
  State<DownloadInteractionScreen> createState() =>
      _DownloadInteractionScreenState();
}

class _DownloadInteractionScreenState extends State<DownloadInteractionScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> resizeAnimation;
  late Animation<Offset> offsetAnimation;
  late Animation<double> textAnimation;
  late Animation<int> progressAnimation;
  late Animation<double> loadingAnimation;
  late Animation<double> arrowAnimation;

  bool showBox = false;
  bool switchColor = false;
  bool showComplete = false;
  bool showShadow = false;

  initAnimation() {
    resizeAnimation = Tween<Offset>(
            begin: const Offset(0.18, 0.10), end: const Offset(0.28, 0.15))
        .animate(_controller1);

    offsetAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.22, 0.5))
        .animate(_controller2);
    textAnimation = Tween<double>(begin: 0.4, end: 0.68).animate(_controller2);

    loadingAnimation =
        Tween<double>(begin: 0.075, end: -0.075).animate(_controller3);
    progressAnimation = IntTween(begin: 0, end: 100).animate(_controller3);
    arrowAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -0.02), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.02, end: 0.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -0.02), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.02, end: 0.0), weight: 1),
    ]).animate(_controller3);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 400,
        ));
    _controller2 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 500,
        ));
    _controller3 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1800,
        ));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          switchColor = true;
        });
      }

      if (status == AnimationStatus.completed) {
        setState(() {
          showBox = true;
        });
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showShadow = true;
        });
        _controller3.forward();
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showComplete = true;
        });

        Future.delayed(const Duration(milliseconds: 1200), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showBox = false;
      switchColor = false;
      showComplete = false;
      showShadow = false;
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
      backgroundColor: Colors.grey.shade300,
      body: AnimatedBuilder(
          animation:
              Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: DownloadButtonPainter(
                    resizeOffset: resizeAnimation.value,
                    showBox: showBox,
                    changeColor: switchColor,
                    textMovement: textAnimation.value,
                    offsetMovement: offsetAnimation.value,
                    progress: progressAnimation.value,
                    loading: loadingAnimation.value,
                    arrowMovement: arrowAnimation.value,
                    showComplete: showComplete,
                    showShadow: showShadow,
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
                      height: size.height * 0.2,
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

class DownloadButtonPainter extends CustomPainter {
  DownloadButtonPainter({
    required this.resizeOffset,
    required this.showBox,
    required this.changeColor,
    required this.offsetMovement,
    required this.textMovement,
    required this.arrowMovement,
    required this.progress,
    required this.loading,
    required this.showComplete,
    required this.showShadow,
  });
  final Offset resizeOffset;
  final bool showBox;
  final bool changeColor;
  final Offset offsetMovement;
  final double textMovement;
  final double arrowMovement;
  final double loading;
  final int progress;
  final bool showComplete;
  final bool showShadow;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;

    Paint paint = Paint()
      ..color = changeColor ? Colors.black : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.8;

    Paint fillPaint = Paint()
      ..color = changeColor ? Colors.white : Colors.black;

    drawText(String text, Offset offset, Color color) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 22, color: color, fontWeight: FontWeight.w800),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // background
    Offset offset = Offset(w * offsetMovement.dx, h * offsetMovement.dy);

    canvas.drawShadow(
        Path()
          ..addRect(
            Rect.fromCenter(
                center: Offset(offset.dx, offset.dy),
                width: w * 0.18,
                height: h * 0.11),
          ),
        Colors.black,
        10,
        false);

    if (showShadow) {
      canvas.drawShadow(
          Path()
            ..addRect(
              Rect.fromCenter(
                  center: Offset(w * 0.36, h * 0.5),
                  width: w * 0.55,
                  height: h * 0.15),
            ),
          Colors.black,
          10,
          false);
    }

    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(offset.dx, offset.dy),
          width: w * resizeOffset.dx,
          height: h * resizeOffset.dy),
      fillPaint,
    );

    // box
    Offset boxOffset = Offset(offset.dx, offset.dy + h * 0.03);

    if (showBox) {
      drawText('Status'.toUpperCase(), Offset(w * textMovement, h * 0.47),
          Colors.grey);
      drawText('$progress%', Offset(w * textMovement, h * 0.51), Colors.black);

      // progress box
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w * 0.5, h * 0.5),
            width: w * resizeOffset.dx,
            height: h * resizeOffset.dy),
        fillPaint,
      );

      Offset loadingOffset = Offset(w * 0.5, h * 0.5);
      canvas.drawPath(
          Path()
            ..moveTo(loadingOffset.dx - w * 0.14, loadingOffset.dy + h * 0.075)
            ..lineTo(loadingOffset.dx + w * 0.14, loadingOffset.dy + h * 0.075)
            ..lineTo(
                loadingOffset.dx + w * 0.14, loadingOffset.dy + h * loading)
            ..lineTo(
                loadingOffset.dx - w * 0.14, loadingOffset.dy + h * loading)
            ..close(),
          Paint()..color = Colors.blue);

      if (showComplete) {
        // complete icon
        Offset completeOffset = Offset(w * 0.5, h * 0.5);
        canvas.drawPath(
            Path()
              ..moveTo(
                  completeOffset.dx - w * 0.03, completeOffset.dy + h * 0.01)
              ..lineTo(completeOffset.dx, completeOffset.dy + h * 0.02)
              ..lineTo(
                  completeOffset.dx + w * 0.05, completeOffset.dy - h * 0.02),
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.8);
      }

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: boxOffset, width: w * 0.12, height: h * 0.035),
              const Radius.circular(4)),
          paint);

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset(boxOffset.dx, boxOffset.dy - h * 0.02),
                  width: w * 0.06,
                  height: h * 0.03),
              const Radius.circular(4)),
          fillPaint);
    }

    // download icon
    Offset arrowOffset =
        Offset(offset.dx + w * 0.0, offset.dy + h * arrowMovement);
    canvas.drawPath(
        Path()
          ..moveTo(arrowOffset.dx - w * 0.02, arrowOffset.dy + h * 0.01)
          ..lineTo(arrowOffset.dx, arrowOffset.dy + h * 0.018)
          ..lineTo(arrowOffset.dx + w * 0.02, arrowOffset.dy + h * 0.01)
          ..moveTo(arrowOffset.dx, arrowOffset.dy + h * 0.018)
          ..lineTo(arrowOffset.dx, arrowOffset.dy - h * 0.015),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
