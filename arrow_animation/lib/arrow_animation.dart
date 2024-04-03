import 'dart:math';

import 'package:flutter/material.dart';

class ArrowAnimationScreen extends StatefulWidget {
  const ArrowAnimationScreen({super.key});

  @override
  State<ArrowAnimationScreen> createState() => _ArrowAnimationScreenState();
}

class _ArrowAnimationScreenState extends State<ArrowAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;

  late Animation<double> slideAnimation;
  late Animation<double> iconAnimation;
  late Animation<double> arcAnimation;

  bool changeArcPosition = false;
  bool isRightClicked = false;

  initAnimation() {
    slideAnimation = Tween<double>(begin: 0.3, end: 0.45).animate(controller1);
    iconAnimation = Tween<double>(begin: 5.0, end: 0.0).animate(controller1);

    arcAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(controller2);
  }

  @override
  void initState() {
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    initAnimation();
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.forward();
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        arcAnimation =
            Tween<double>(begin: -1.0, end: 0.0).animate(controller3);
        setState(() {
          changeArcPosition = true;
        });
        controller3.forward();
      }
    });

    controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          changeArcPosition = false;
        });
        slideAnimation =
            Tween<double>(begin: 0.15, end: 0.3).animate(controller4);
        iconAnimation =
            Tween<double>(begin: 0.0, end: 5.0).animate(controller4);
        controller4.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 93, 245, 1),
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [controller1, controller2, controller3, controller4]),
          builder: (context, child) {
            return Center(
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.15,
                    width: size.width * 0.7,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: ArrowPainter(
                          iconPosition: slideAnimation.value,
                          iconSize: iconAnimation.value,
                          arcLength: arcAnimation.value,
                          changeArc: changeArcPosition,
                          isRightClicked: isRightClicked),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.15,
                    width: size.width * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRightClicked = false;
                            });

                            controller1.reset();
                            controller1.reset();
                            controller2.reset();
                            controller3.reset();
                            controller4.reset();
                            initAnimation();

                            controller1.forward();
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRightClicked = true;
                            });

                            controller1.reset();
                            controller2.reset();
                            controller3.reset();
                            controller4.reset();
                            initAnimation();

                            controller1.forward();
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ArrowPainter extends CustomPainter {
  ArrowPainter(
      {required this.iconPosition,
      required this.iconSize,
      required this.arcLength,
      required this.changeArc,
      required this.isRightClicked});
  final double iconPosition;
  final double iconSize;
  final double arcLength;
  final bool changeArc;
  final bool isRightClicked;
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white38;

    Paint iconPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    double iconLeftPosition = 0.3;
    double iconRightPosition = 0.3;
    double iconLeftSize = 5.0;
    double iconRightSize = 5.0;

    if (isRightClicked) {
      iconRightPosition = iconPosition;
      iconRightSize = iconSize;
    } else {
      iconLeftPosition = iconPosition;
      iconLeftSize = iconSize;
    }

    drawIcon(double iconPosition, double iconSize, int direction) {
      // circle
      canvas.drawCircle(
          Offset(offset.dx + direction * w * 0.3, offset.dy), w * 0.15, paint);
      // icon
      Offset leftOffset =
          Offset(offset.dx + direction * w * iconPosition, offset.dy);
      canvas.drawPath(
          Path()
            ..moveTo(leftOffset.dx - direction * 2 * iconSize,
                leftOffset.dy - 3 * iconSize)
            ..lineTo(leftOffset.dx + direction * 2 * iconSize, leftOffset.dy)
            ..lineTo(leftOffset.dx - direction * 2 * iconSize,
                leftOffset.dy + 3 * iconSize),
          iconPaint);
    }

    drawArc(double startAngle, int direction) {
      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(offset.dx + direction * w * 0.3, offset.dy),
              radius: w * 0.15),
          startAngle,
          pi * arcLength,
          false,
          iconPaint);

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(offset.dx + direction * w * 0.3, offset.dy),
              radius: w * 0.15),
          startAngle,
          pi * -arcLength,
          false,
          iconPaint);
    }

    // left icon
    drawIcon(iconLeftPosition, iconLeftSize, -1);
    // right icon
    drawIcon(iconRightPosition, iconRightSize, 1);

    if (isRightClicked) {
      // right arc
      drawArc(changeArc ? pi : 0, 1);
    } else {
      // left arc
      drawArc(changeArc ? 0 : pi, -1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
