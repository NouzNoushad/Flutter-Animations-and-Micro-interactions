import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(48, 51, 52, 1);
const Color blueColor = Color.fromRGBO(0, 199, 244, 1);
const Color blueDarkColor = Color.fromRGBO(0, 168, 207, 1);
const Color greenColor = Color.fromRGBO(0, 248, 95, 1);

class DownloadButtonScreen extends StatefulWidget {
  const DownloadButtonScreen({super.key});

  @override
  State<DownloadButtonScreen> createState() => _DownloadButtonScreenState();
}

class _DownloadButtonScreenState extends State<DownloadButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<double> borderAnimation;
  late Animation<Offset> iconAnimation;
  late Animation<int> progressAnimation;
  late Animation<double> upAnimation;
  late Animation<Color?> colorAnimation;

  bool buttonTapped = false;
  bool secondAnimStart = false;
  bool secondAnimProgress = false;
  bool showIcon = true;
  String text = 'download';

  Color borderColor = blueColor;

  initAnimation() {
    borderAnimation = Tween<double>(begin: 0.9, end: 0.25).animate(_controller);
    iconAnimation = Tween<Offset>(
            begin: const Offset(0.18, 0.5), end: const Offset(0.5, 0.5))
        .animate(_controller);

    progressAnimation = IntTween(begin: 0, end: 10).animate(
        CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));

    upAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -0.3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -0.3, end: 0.1), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller2, curve: Curves.linear));

    colorAnimation =
        ColorTween(begin: Colors.white, end: greenColor).animate(_controller2);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          secondAnimStart = true;
          secondAnimProgress = true;
        });
        _controller1.forward();
      }
    });

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          secondAnimStart = false;
          showIcon = false;
        });
        borderAnimation =
            Tween<double>(begin: 0.25, end: 0.6).animate(_controller2);
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          secondAnimProgress = false;
          borderColor = greenColor;
          text = 'open';
        });

        // set to init state
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() {
            buttonTapped = false;
            secondAnimStart = false;
            secondAnimProgress = false;
            showIcon = true;
            text = 'download';

            borderColor = blueColor;
          });
          initAnimation();
          _controller.reset();
          _controller1.reset();
          _controller2.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: AnimatedBuilder(
            animation:
                Listenable.merge([_controller, _controller1, _controller2]),
            builder: (context, child) {
              return Stack(
                children: [
                  CustomPaint(
                    painter: DownloadPainter(
                        buttonTapped: buttonTapped,
                        iconPosition: iconAnimation.value,
                        borderWidth: borderAnimation.value,
                        progress: progressAnimation.value,
                        secondAnimStart: secondAnimStart,
                        secondAnimProgress: secondAnimProgress,
                        upHeight: upAnimation.value,
                        showIcon: showIcon,
                        dotColor: colorAnimation.value!,
                        borderColor: borderColor),
                    size: size,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          buttonTapped = true;
                          text = "";
                        });
                        _controller.reset();
                        _controller.forward();
                      },
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.9,
                        color: Colors.transparent,
                        alignment: text == 'open'
                            ? Alignment.center
                            : const Alignment(0.2, 0),
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}

class DownloadPainter extends CustomPainter {
  DownloadPainter(
      {required this.buttonTapped,
      required this.borderWidth,
      required this.iconPosition,
      required this.progress,
      required this.secondAnimStart,
      required this.secondAnimProgress,
      required this.upHeight,
      required this.showIcon,
      required this.dotColor,
      required this.borderColor});
  final bool buttonTapped;
  final double borderWidth;
  final Offset iconPosition;
  final int progress;
  final bool secondAnimStart;
  final bool secondAnimProgress;
  final double upHeight;
  final bool showIcon;
  final Color dotColor;
  final Color borderColor;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    drawIcon(IconData iconData, Offset offset) {
      IconData icon = iconData;
      TextPainter textPainter = TextPainter(
          textAlign: TextAlign.center, textDirection: TextDirection.rtl);
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontSize: 50.0,
              fontFamily: icon.fontFamily,
              color: Colors.white));
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // border
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: offset, width: w * borderWidth, height: h * 0.12),
            Radius.circular(h * 0.5)),
        paint); // 0.9 - 0.25

    Offset circleOffset =
        Offset(w * iconPosition.dx, h * iconPosition.dy); // 0.18 - 0.5

    if (showIcon) {
      // circle
      canvas.drawCircle(circleOffset, w * 0.108, Paint()..color = blueColor);
    }

    if (secondAnimProgress) {
      int i = -90 + 36 * progress;
      var x1 = offset.dx + w * 0.12 * cos(i * pi / 180);
      var y1 = offset.dy + w * 0.12 * sin(i * pi / 180);
      canvas.drawCircle(
          Offset(x1, y1 + h * upHeight), w * 0.018, Paint()..color = dotColor);
    }

    if (secondAnimStart) {
      canvas.drawArc(
          Rect.fromCircle(center: offset, radius: w * 0.115),
          4.6,
          pi * 0.2 * progress,
          false,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.5);

      canvas.clipRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: offset, width: w * 0.2, height: h * 0.10),
          Radius.circular(h * 0.5)));

      canvas.drawRect(
          Rect.fromCircle(
              center: Offset(w * 0.5, h * 0.6 - h * 0.01 * progress),
              radius: w * 0.1),
          Paint()..color = blueDarkColor);
    }

    if (showIcon) {
      // icon
      drawIcon(buttonTapped ? Icons.stop : Icons.arrow_downward,
          Offset(circleOffset.dx - w * 0.07, h * 0.465));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
