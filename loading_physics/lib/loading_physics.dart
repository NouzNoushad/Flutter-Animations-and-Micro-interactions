import 'dart:math';

import 'package:flutter/material.dart';

class LoadingPhysicsScreen extends StatefulWidget {
  const LoadingPhysicsScreen({super.key});

  @override
  State<LoadingPhysicsScreen> createState() => _LoadingPhysicsScreenState();
}

class _LoadingPhysicsScreenState extends State<LoadingPhysicsScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> secondCenterLeftAnimation;
  late Animation<double> firstCenterLeftAnimation;
  late Animation<double> firstCenterRightAnimation;
  late Animation<double> secondCenterRightAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    secondCenterLeftAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 160.0, end: 90.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 90.0, end: 95.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 95.0, end: 90.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0, 1)));

    firstCenterLeftAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 90.0, end: 93.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 93.0, end: 90.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.3, 1)));

    firstCenterRightAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 90.0, end: 87.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 87.0, end: 90.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.4, 1)));

    secondCenterRightAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 90.0, end: 20.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 20.0, end: 90.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 90.0, end: 87.0), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 87.0, end: 90.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0.3, 1)));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            controller.reset();
            controller.forward();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            controller,
          ]),
          builder: (context, child) {
            return Center(
                child: Container(
              height: size.height * 0.3,
              width: size.width * 0.8,
              color: Colors.transparent,
              child: CustomPaint(
                painter: PhysicsBall(
                  secondLeftCenterAngle: secondCenterLeftAnimation.value,
                  firstLeftCenterAngle: firstCenterLeftAnimation.value,
                  firstRightCenterAngle: firstCenterRightAnimation.value,
                  secondRightCenterAngle: secondCenterRightAnimation.value,
                ),
              ),
            ));
          }),
    );
  }
}

class PhysicsBall extends CustomPainter {
  PhysicsBall({
    required this.secondLeftCenterAngle,
    required this.firstLeftCenterAngle,
    required this.firstRightCenterAngle,
    required this.secondRightCenterAngle,
  });
  final double secondLeftCenterAngle;
  final double firstLeftCenterAngle;
  final double firstRightCenterAngle;
  final double secondRightCenterAngle;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint fillPaint = Paint()..color = Colors.white;
    double topHeight = h * 0.2;
    double stringHeight = w * 0.4;
    double centerWidth = w * 0.5;
    double radius = 10;

    // top line
    canvas.drawLine(
        Offset(w * 0.2, topHeight), Offset(w * 0.8, topHeight), paint);

    // center
    double i = 1 * 90;
    double centerX = centerWidth;
    double centerY = topHeight;
    double endX = centerX + stringHeight * cos(i * pi / 180);
    double endY = centerY + stringHeight * sin(i * pi / 180);

    canvas.drawLine(Offset(centerWidth, topHeight), Offset(endX, endY), paint);
    canvas.drawCircle(Offset(endX, endY), radius, fillPaint);

    // center-left-first
    centerWidth = centerWidth - 2 * radius;

    i = firstLeftCenterAngle;
    centerX = centerWidth;
    centerY = topHeight;
    endX = centerX + stringHeight * cos(i * pi / 180);
    endY = centerY + stringHeight * sin(i * pi / 180);

    canvas.drawLine(Offset(centerWidth, topHeight), Offset(endX, endY), paint);
    canvas.drawCircle(Offset(endX, endY), radius, fillPaint);

    // center-left-second
    centerWidth = centerWidth - 2 * radius;

    i = secondLeftCenterAngle;
    centerX = centerWidth;
    centerY = topHeight;
    endX = centerX + stringHeight * cos(i * pi / 180);
    endY = centerY + stringHeight * sin(i * pi / 180);

    canvas.drawLine(Offset(centerWidth, topHeight), Offset(endX, endY), paint);
    canvas.drawCircle(Offset(endX, endY), radius, fillPaint);

    // set width to center
    centerWidth = w * 0.5;

    // center-right-first
    centerWidth = centerWidth + 2 * radius;

    i = firstRightCenterAngle;
    centerX = centerWidth;
    centerY = topHeight;
    endX = centerX + stringHeight * cos(i * pi / 180);
    endY = centerY + stringHeight * sin(i * pi / 180);

    canvas.drawLine(Offset(centerWidth, topHeight), Offset(endX, endY), paint);
    canvas.drawCircle(Offset(endX, endY), radius, fillPaint);

    // center-right-second
    centerWidth = centerWidth + 2 * radius;

    i = secondRightCenterAngle;
    centerX = centerWidth;
    centerY = topHeight;
    endX = centerX + stringHeight * cos(i * pi / 180);
    endY = centerY + stringHeight * sin(i * pi / 180);

    canvas.drawLine(Offset(centerWidth, topHeight), Offset(endX, endY), paint);
    canvas.drawCircle(Offset(endX, endY), radius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
