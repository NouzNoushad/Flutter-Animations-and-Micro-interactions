import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(119, 222, 238, 1);
const Color backgroundDarkColor = Color.fromRGBO(72, 196, 216, 1);
const Color droneColor = Color.fromRGBO(242, 183, 6, 1);
const Color backgroundSuccessColor = Color.fromRGBO(110, 241, 195, 1);
const Color backgroundSuccessDarkColor = Color.fromRGBO(72, 209, 165, 1);
const Color textColor = Colors.white;
const Color whiteBorderColor = Colors.white;
const Color blackBorderColor = Colors.black;

class DroneAnimationScreen extends StatefulWidget {
  const DroneAnimationScreen({super.key});

  @override
  State<DroneAnimationScreen> createState() => _DroneAnimationScreenState();
}

class _DroneAnimationScreenState extends State<DroneAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;
  late AnimationController controller5;

  late Animation<Offset> boxAnimation;
  late Animation<Offset> droneAnimation;
  late Animation<double> progressAnimation;
  late Animation<Color?> boxBackgroundColor;
  late Animation<Color?> boxBorderColor;
  Color bgColor = backgroundColor;
  Color bgDarkColor = backgroundDarkColor;

  String text = '';
  bool showDrone = false;
  bool showProgress = false;
  bool showComplete = false;

  initAnimation() {
    text = 'Check out';
    boxAnimation = Tween<Offset>(
            begin: const Offset(0.2, 0.5), end: const Offset(0.2, 0.4))
        .animate(controller1);
    droneAnimation = Tween<Offset>(
            begin: const Offset(0.2, 0.48), end: const Offset(0.2, 0.38))
        .animate(controller1);
    progressAnimation = Tween<double>(begin: 0.4, end: 0.3).animate(
        CurvedAnimation(parent: controller1, curve: const Interval(0.5, 1.0)));
    boxBackgroundColor =
        ColorTween(begin: backgroundDarkColor, end: backgroundColor)
            .animate(controller1);
    boxBorderColor = ColorTween(begin: whiteBorderColor, end: blackBorderColor)
        .animate(controller1);
  }

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    controller5 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    initAnimation();
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          text = 'Processing...';
          showDrone = true;
          showProgress = true;
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          text = 'Delivering...';
        });
        boxAnimation = Tween<Offset>(
                begin: const Offset(0.2, 0.4), end: const Offset(0.85, 0.4))
            .animate(controller2);
        droneAnimation = Tween<Offset>(
                begin: const Offset(0.2, 0.38), end: const Offset(0.85, 0.38))
            .animate(controller2);
        progressAnimation =
            Tween<double>(begin: 0.3, end: -0.35).animate(controller2);
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            text = "it's on the way";
          });
        });
        controller2.forward();
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          bgColor = backgroundSuccessColor;
          bgDarkColor = backgroundSuccessDarkColor;
          text = 'Delivered';
          showComplete = true;
        });
        boxAnimation = Tween<Offset>(
                begin: const Offset(0.85, 0.4), end: const Offset(0.85, 0.43))
            .animate(controller3);
        droneAnimation = Tween<Offset>(
                begin: const Offset(0.85, 0.38), end: const Offset(0.85, 0.41))
            .animate(controller3);
        boxBackgroundColor =
            ColorTween(begin: backgroundColor, end: backgroundSuccessColor)
                .animate(controller3);
        controller3.forward();
      }
    });

    controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxAnimation = Tween<Offset>(
                begin: const Offset(0.85, 0.43), end: const Offset(0.2, 0.43))
            .animate(controller4);
        droneAnimation = Tween<Offset>(
                begin: const Offset(0.85, 0.41), end: const Offset(0.85, 0.3))
            .animate(controller4);
        progressAnimation =
            Tween<double>(begin: -0.35, end: 0.3).animate(controller4);
        boxBackgroundColor =
            ColorTween(begin: backgroundSuccessColor, end: backgroundColor)
                .animate(controller4);
        controller4.forward();
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            showDrone = false;
            bgColor = backgroundColor;
            bgDarkColor = backgroundDarkColor;
          });
        });
      }
    });

    controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showComplete = false;
        });
        boxAnimation = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.2, 0.43), end: const Offset(0.2, 0.35)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.2, 0.35), end: const Offset(0.2, 0.5)),
              weight: 1),
        ]).animate(
            CurvedAnimation(parent: controller5, curve: Curves.easeInOut));
        progressAnimation =
            Tween<double>(begin: 0.3, end: 0.4).animate(controller5);
        controller5.forward();
      }
    });

    controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        resetAll();
      }
    });
  }

  resetAll() {
    setState(() {
      showDrone = false;
      showProgress = false;
      showComplete = false;
    });
    controller1.reset();
    controller2.reset();
    controller3.reset();
    controller4.reset();
    controller5.reset();
    initAnimation();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: Listenable.merge([
            controller1,
            controller2,
            controller3,
            controller4,
            controller5,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: DronePainter(
                    text: text,
                    showDrone: showDrone,
                    showProgress: showProgress,
                    boxOffset: boxAnimation.value,
                    droneOffset: droneAnimation.value,
                    boxBackgroundColor: boxBackgroundColor.value!,
                    boxBorderColor: boxBorderColor.value!,
                    progress: progressAnimation.value,
                    bgColor: bgColor,
                    bgDarkColor: bgDarkColor,
                    showComplete: showComplete,
                  ),
                  size: size,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      controller1.reset();
                      controller1.forward();
                    },
                    child: Container(
                      height: size.height * 0.1,
                      width: size.width * 0.9,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class DronePainter extends CustomPainter {
  const DronePainter({
    required this.showDrone,
    required this.showProgress,
    required this.text,
    required this.boxOffset,
    required this.droneOffset,
    required this.boxBackgroundColor,
    required this.boxBorderColor,
    required this.progress,
    required this.bgColor,
    required this.bgDarkColor,
    required this.showComplete,
  });
  final bool showDrone;
  final bool showProgress;
  final String text;
  final Offset boxOffset;
  final Offset droneOffset;
  final double progress;
  final Color boxBackgroundColor;
  final Color boxBorderColor;
  final Color bgColor;
  final Color bgDarkColor;
  final bool showComplete;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    drawDrone(Offset droneOffset) {
      drawRotor(Offset droneRotorOffset, Paint rotorPaint, Paint legPaint) {
        canvas.drawPath(
            Path()
              ..moveTo(droneRotorOffset.dx - w * 0.018,
                  droneRotorOffset.dy - h * 0.05)
              ..lineTo(droneRotorOffset.dx, droneRotorOffset.dy)
              ..lineTo(droneRotorOffset.dx + w * 0.018,
                  droneRotorOffset.dy - h * 0.05)
              ..quadraticBezierTo(
                  droneRotorOffset.dx,
                  droneRotorOffset.dy - h * 0.06,
                  droneRotorOffset.dx - w * 0.018,
                  droneRotorOffset.dy - h * 0.05),
            legPaint);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(
                        droneRotorOffset.dx, droneRotorOffset.dy - h * 0.042),
                    width: w * 0.09,
                    height: h * 0.01),
                const Radius.circular(10)),
            rotorPaint);
      }

      drawDroneBody(Offset droneOffset, Paint paint) {
        canvas.drawPath(
            Path()
              ..moveTo(droneOffset.dx - w * 0.08, droneOffset.dy - h * 0.024)
              ..lineTo(droneOffset.dx - w * 0.04, droneOffset.dy - h * 0.024)
              ..quadraticBezierTo(droneOffset.dx, droneOffset.dy - h * 0.04,
                  droneOffset.dx + w * 0.04, droneOffset.dy - h * 0.024)
              ..lineTo(droneOffset.dx + w * 0.08, droneOffset.dy - h * 0.024)
              ..lineTo(droneOffset.dx + w * 0.08, droneOffset.dy - h * 0.017)
              ..lineTo(droneOffset.dx + w * 0.03, droneOffset.dy - h * 0.017)
              ..lineTo(droneOffset.dx + w * 0.01, droneOffset.dy - h * 0.007)
              ..lineTo(droneOffset.dx - w * 0.01, droneOffset.dy - h * 0.007)
              ..lineTo(droneOffset.dx - w * 0.03, droneOffset.dy - h * 0.017)
              ..lineTo(droneOffset.dx - w * 0.08, droneOffset.dy - h * 0.017)
              ..close(),
            paint);

        canvas.drawPath(
            Path()
              ..moveTo(droneOffset.dx + w * 0.03, droneOffset.dy - h * 0.017)
              ..lineTo(droneOffset.dx + w * 0.01, droneOffset.dy - h * 0.007)
              ..lineTo(droneOffset.dx - w * 0.01, droneOffset.dy - h * 0.007)
              ..lineTo(droneOffset.dx - w * 0.03, droneOffset.dy - h * 0.017)
              ..close(),
            Paint()..color = Colors.white);
      }

      // right grabber
      canvas.drawPath(
          Path()
            ..moveTo(droneOffset.dx + w * 0.03, droneOffset.dy - h * 0.017)
            ..lineTo(droneOffset.dx + w * 0.052, droneOffset.dy - h * 0.005)
            ..lineTo(droneOffset.dx + w * 0.03, droneOffset.dy + h * 0.008),
          paint);
      // left grabber
      canvas.drawPath(
          Path()
            ..moveTo(droneOffset.dx - w * 0.03, droneOffset.dy - h * 0.017)
            ..lineTo(droneOffset.dx - w * 0.052, droneOffset.dy - h * 0.005)
            ..lineTo(droneOffset.dx - w * 0.03, droneOffset.dy + h * 0.008),
          paint);

      drawDroneBody(droneOffset, paint);
      drawDroneBody(droneOffset, Paint()..color = droneColor);

      Offset droneLeftRotorOffset =
          Offset(droneOffset.dx - w * 0.09, droneOffset.dy);
      drawRotor(droneLeftRotorOffset, paint, paint);
      drawRotor(droneLeftRotorOffset, Paint()..color = droneColor,
          Paint()..color = bgColor);

      Offset droneRightRotorOffset =
          Offset(droneOffset.dx + w * 0.09, droneOffset.dy);
      drawRotor(droneRightRotorOffset, paint, paint);
      drawRotor(droneRightRotorOffset, Paint()..color = droneColor,
          Paint()..color = bgColor);
    }

    drawDeliveryBox(Offset boxOffset, Paint paint) {
      canvas.drawPath(
          Path()
            ..moveTo(boxOffset.dx - w * 0.026, boxOffset.dy - h * 0.015)
            ..lineTo(boxOffset.dx + w * 0.026, boxOffset.dy - h * 0.015)
            ..lineTo(boxOffset.dx + w * 0.018, boxOffset.dy + h * 0.015)
            ..lineTo(boxOffset.dx - w * 0.018, boxOffset.dy + h * 0.015)
            ..close(),
          paint);
    }

    drawIcon(IconData iconData, Offset offset) {
      IconData icon = iconData;
      TextPainter textPainter = TextPainter(
          textAlign: TextAlign.center, textDirection: TextDirection.rtl);
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontSize: 35.0,
              fontFamily: icon.fontFamily,
              color: Colors.white));
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    drawText(String text, Offset offset, Color color) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: 25, color: color, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    if (showProgress) {
      // progress
      canvas.drawLine(
          Offset(offset.dx - w * 0.4, offset.dy - h * 0.055),
          Offset(offset.dx - w * progress, offset.dy - h * 0.055),
          Paint()
            ..color = bgDarkColor
            ..strokeWidth = 6
            ..style = PaintingStyle.stroke);
    }

    if (showDrone) {
      // drone
      Offset dronePosition = Offset(w * droneOffset.dx, h * droneOffset.dy);
      drawDrone(dronePosition);
    }

    canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromCenter(center: offset, width: w * 0.9, height: h * 0.1),
              const Radius.circular(20))),
        Colors.black,
        4,
        false);
    // background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: w * 0.9, height: h * 0.1),
            const Radius.circular(20)),
        Paint()..color = bgColor);

    canvas.drawCircle(Offset(offset.dx - w * 0.3, offset.dy), w * 0.07,
        Paint()..color = bgDarkColor);

    drawText(
        text, Offset(offset.dx - w * 0.15, offset.dy - h * 0.02), textColor);

    // delivery box
    Offset boxPosition = Offset(w * boxOffset.dx, h * boxOffset.dy);
    drawDeliveryBox(boxPosition, Paint()..color = boxBackgroundColor);
    drawDeliveryBox(
        boxPosition,
        Paint()
          ..color = boxBorderColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke);

    if (showComplete) {
      canvas.drawCircle(
          Offset(offset.dx - w * 0.3, offset.dy),
          w * 0.07,
          Paint()
            ..color = whiteBorderColor
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke);
      drawIcon(Icons.done, Offset(offset.dx - w * 0.35, offset.dy - h * 0.02));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
