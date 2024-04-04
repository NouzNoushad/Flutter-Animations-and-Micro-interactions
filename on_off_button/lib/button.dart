import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor1 = Color.fromRGBO(29, 74, 63, 1);
const Color buttonColor1 = Color.fromRGBO(6, 125, 104, 1);
const Color buttonBackgroundColor1 = Color.fromRGBO(132, 166, 157, 1);

const Color backgroundColor2 = Color.fromRGBO(78, 31, 32, 1);
const Color buttonColor2 = Color.fromRGBO(133, 24, 26, 1);
const Color buttonBackgroundColor2 = Color.fromRGBO(175, 158, 158, 1);

class OnOffButtonScreen extends StatefulWidget {
  const OnOffButtonScreen({super.key});

  @override
  State<OnOffButtonScreen> createState() => _OnOffButtonScreenState();
}

class _OnOffButtonScreenState extends State<OnOffButtonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> rotationAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> opacityAnimation1;
  late Animation<double> opacityAnimation2;
  late Animation<Color?> backgroundColor;
  late Animation<Color?> buttonBackgroundColor;
  late Animation<Color?> buttonColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    rotationAnimation = Tween<double>(begin: 0.0, end: pi).animate(_controller);
    slideAnimation = Tween<Offset>(
            begin: const Offset(-0.25, 0.0), end: const Offset(0.25, 0.0))
        .animate(_controller);
    opacityAnimation1 =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    opacityAnimation2 =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    backgroundColor = ColorTween(begin: backgroundColor1, end: backgroundColor2)
        .animate(_controller);
    buttonBackgroundColor =
        ColorTween(begin: buttonBackgroundColor1, end: buttonBackgroundColor2)
            .animate(_controller);
    buttonColor =
        ColorTween(begin: buttonColor1, end: buttonColor2).animate(_controller);
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
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              color: backgroundColor.value,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: size.width * 0.8,
                      width: size.width * 0.8,
                      color: Colors.transparent,
                      child: CustomPaint(
                        painter: ButtonDesign(
                          rotation: rotationAnimation.value,
                          slideMotion: slideAnimation.value,
                          opacity1: opacityAnimation1.value,
                          opacity2: opacityAnimation2.value,
                          buttonColor: buttonColor.value!,
                          buttonBackgroundColor: buttonBackgroundColor.value!,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_controller.status == AnimationStatus.completed) {
                          _controller.reverse();
                        } else {
                          _controller.reset();
                          _controller.forward();
                        }
                      },
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.7,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ButtonDesign extends CustomPainter {
  ButtonDesign(
      {required this.rotation,
      required this.slideMotion,
      required this.opacity1,
      required this.opacity2,
      required this.buttonColor,
      required this.buttonBackgroundColor});
  final double rotation;
  final Offset slideMotion;
  final double opacity1;
  final double opacity2;
  final Color buttonColor;
  final Color buttonBackgroundColor;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    // Paint paint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.stroke;

    drawBackground() {
      canvas.drawShadow(
          Path()
            ..addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(center: offset, width: 250, height: 100),
                Radius.circular(h * 0.5))),
          Colors.black,
          10,
          false);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: offset, width: 250, height: 100),
              Radius.circular(h * 0.5)),
          Paint()..color = buttonBackgroundColor);
    }

    rotateBackground(double angle) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);
      // icon
      drawBackground();
      canvas.restore();
    }

    drawText(String text, Offset offset, double opacity) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 32,
              color: Colors.white.withOpacity(opacity),
              fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // background
    rotateBackground(rotation);

    // circle
    Offset circleOffset =
        Offset(offset.dx + w * slideMotion.dx, offset.dy + h * slideMotion.dy);
    canvas.drawCircle(circleOffset, w * 0.13, Paint()..color = buttonColor);

    // off text
    drawText('off'.toUpperCase(),
        Offset(offset.dx + w * 0.15, offset.dy - h * 0.06), opacity2);
    // on text
    drawText('on'.toUpperCase(),
        Offset(offset.dx - w * 0.33, offset.dy - h * 0.06), opacity1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
