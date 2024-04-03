import 'dart:math';

import 'package:flutter/material.dart';

class DevilLoginScreen extends StatefulWidget {
  const DevilLoginScreen({super.key});

  @override
  State<DevilLoginScreen> createState() => _DevilLoginScreenState();
}

class _DevilLoginScreenState extends State<DevilLoginScreen> {
  final Color lightBackground1 = const Color.fromRGBO(248, 148, 39, 1);
  final Color mediumBackground1 = const Color.fromRGBO(249, 167, 35, 1);
  final Color darkBackground1 = const Color.fromRGBO(247, 131, 4, 1);

  final Color lightBackground2 = const Color.fromRGBO(71, 190, 132, 1);
  final Color mediumBackground2 = const Color.fromRGBO(109, 227, 170, 1);
  final Color darkBackground2 = const Color.fromRGBO(27, 134, 82, 1);

  final Color lightBackground3 = const Color.fromRGBO(206, 2, 2, 1);
  final Color mediumBackground3 = const Color.fromRGBO(243, 3, 3, 1);
  final Color darkBackground3 = const Color.fromRGBO(171, 3, 3, 1);

  late Color lightBackground;
  late Color mediumBackground;
  late Color darkBackground;
  late bool isWrong;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    lightBackground = lightBackground1;
    mediumBackground = mediumBackground1;
    darkBackground = darkBackground1;
    isWrong = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 238, 241),
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                CustomPaint(
                  painter: DevilPainter(
                      lightColor: lightBackground,
                      mediumColor: mediumBackground,
                      darkColor: darkBackground,
                      isWrong: isWrong),
                  size: size,
                ),
                Positioned(
                  bottom: size.height * 0.10,
                  left: size.width * 0.17,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        width: size.width * 0.66,
                        height: size.height * 0.16,
                        child: IntrinsicWidth(
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: emailController,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: InputBorder.none,
                                      hintText: 'Email')),
                              Divider(
                                height: 12,
                                thickness: 4,
                                color: Colors.grey.shade400,
                              ),
                              TextFormField(
                                  controller: passwordController,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: InputBorder.none,
                                      hintText: 'Password')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      GestureDetector(
                        onTap: () {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          if (email == 'john@gmail.com' && password == '1234') {
                            setState(() {
                              lightBackground = lightBackground2;
                              mediumBackground = mediumBackground2;
                              darkBackground = darkBackground2;
                              isWrong = false;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                lightBackground = lightBackground1;
                                mediumBackground = mediumBackground1;
                                darkBackground = darkBackground1;
                              });
                            });
                          } else {
                            setState(() {
                              lightBackground = lightBackground3;
                              mediumBackground = mediumBackground3;
                              darkBackground = darkBackground3;
                              isWrong = true;
                            });
                          }
                          emailController.clear();
                          passwordController.clear();
                        },
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width * 0.25,
                          color: Colors.transparent,
                          child: const Center(
                              child: Text(
                            'go',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: double.infinity,
            color: mediumBackground,
          ),
        ],
      ),
    );
  }
}

class DevilPainter extends CustomPainter {
  const DevilPainter({
    required this.lightColor,
    required this.mediumColor,
    required this.darkColor,
    required this.isWrong,
  });
  final Color lightColor;
  final Color mediumColor;
  final Color darkColor;
  final bool isWrong;

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;

    // Paint paint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3
    //   ..color = Colors.black;

    Paint darkFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = darkColor;
    Paint darkStrokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = darkColor;
    Paint lightFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = mediumColor;

    // welcome text
    const textStyle = TextStyle(
        color: Colors.white, fontSize: 80, fontWeight: FontWeight.w300);
    const textSpan = TextSpan(
      text: 'Welcome',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) * 0.5;
    final yCenter = (size.height - textPainter.height) * 0.15;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

    // body
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 1), radius: 400),
        0, -pi, false, lightFillPaint);

    // left horn
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.3, h * 0.5)
          ..quadraticBezierTo(w * 0.1, h * 0.5, w * 0.05, h * 0.35)
          ..quadraticBezierTo(w * 0.15, h * 0.42, w * 0.3, h * 0.42),
        darkFillPaint);
    // right horn
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.7, h * 0.5)
          ..quadraticBezierTo(w * 0.9, h * 0.5, w * 0.95, h * 0.35)
          ..quadraticBezierTo(w * 0.85, h * 0.42, w * 0.7, h * 0.42),
        darkFillPaint);
    // head
    canvas.drawArc(
        Rect.fromCenter(center: Offset(w / 2, h / 2), width: 200, height: 200),
        pi,
        pi,
        false,
        lightFillPaint);
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.26, h * 0.5)
          ..lineTo(w * 0.26, h * 0.58)
          ..lineTo(w * 0.74, h * 0.58)
          ..lineTo(w * 0.74, h * 0.5),
        lightFillPaint);

    // hair
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.42, h * 0.36)
          ..lineTo(w * 0.42, h * 0.4)
          ..quadraticBezierTo(w * 0.44, h * 0.42, w * 0.46, h * 0.4)
          ..quadraticBezierTo(w * 0.48, h * 0.42, w * 0.5, h * 0.4)
          ..quadraticBezierTo(w * 0.52, h * 0.42, w * 0.54, h * 0.4)
          ..quadraticBezierTo(w * 0.56, h * 0.42, w * 0.58, h * 0.4)
          ..lineTo(w * 0.58, h * 0.36)
          ..quadraticBezierTo(w * 0.5, h * 0.35, w * 0.42, h * 0.36),
        darkFillPaint);

    // eye
    drawEye({required double xPosition, required double yPosition}) {
      canvas.drawCircle(
          Offset(w * xPosition, h * yPosition),
          25,
          Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 8
            ..color = Colors.white);
      canvas.drawCircle(
          Offset(w * xPosition, h * yPosition), 25, darkStrokePaint);
      canvas.drawCircle(
          Offset(w * xPosition, h * yPosition),
          3,
          Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 8
            ..color = Colors.black);
    }

    // right eye
    drawEye(xPosition: 0.58, yPosition: 0.5);
    // left eye
    drawEye(xPosition: 0.42, yPosition: 0.5);

    // angry eye
    if (isWrong) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.35, h * 0.46)
            ..lineTo(w * 0.65, h * 0.46)
            ..lineTo(w * 0.5, h * 0.52)
            ..close(),
          lightFillPaint);
    }

    // mouth
    drawMouth(Paint paint) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset(w / 2, h * 0.66),
                  width: w * 0.7,
                  height: h * 0.18),
              const Radius.circular(20)),
          paint);
    }

    // teeth
    drawMouth(Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill);
    // lips
    drawMouth(Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10);

    // left arm
    canvas.drawPath(
        Path()
          ..moveTo(w * 0, h * 0.7)
          ..quadraticBezierTo(w * 0.1, h * 0.85, w * 0.4, h * 0.85)
          ..lineTo(w * 0.4, h * 0.88)
          ..quadraticBezierTo(w * 0.1, h * 0.88, w * 0, h * 0.75)
          ..lineTo(w * 0, h * 0.7),
        Paint()..color = lightColor);

    // right arm
    canvas.drawPath(
        Path()
          ..moveTo(w * 1, h * 0.7)
          ..quadraticBezierTo(w * 0.9, h * 0.85, w * 0.6, h * 0.85)
          ..lineTo(w * 0.6, h * 0.88)
          ..quadraticBezierTo(w * 0.9, h * 0.88, w * 1, h * 0.75)
          ..lineTo(w * 1, h * 0.7),
        Paint()..color = lightColor);

    // button
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * 0.5, h * 0.86),
                width: w * 0.3,
                height: h * 0.08),
            const Radius.circular(10)),
        Paint()
          ..color = darkColor
          ..style = PaintingStyle.fill);

    // hand
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.35, h * 0.83)
          ..lineTo(w * 0.4, h * 0.83)
          ..quadraticBezierTo(w * 0.42, h * 0.84, w * 0.4, h * 0.85)
          ..quadraticBezierTo(w * 0.42, h * 0.86, w * 0.4, h * 0.87)
          ..quadraticBezierTo(w * 0.42, h * 0.88, w * 0.4, h * 0.89)
          ..lineTo(w * 0.35, h * 0.89)
          ..quadraticBezierTo(w * 0.25, h * 0.86, w * 0.35, h * 0.83),
        Paint()..color = lightColor);
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.65, h * 0.83)
          ..lineTo(w * 0.6, h * 0.83)
          ..quadraticBezierTo(w * 0.58, h * 0.84, w * 0.6, h * 0.85)
          ..quadraticBezierTo(w * 0.58, h * 0.86, w * 0.6, h * 0.87)
          ..quadraticBezierTo(w * 0.58, h * 0.88, w * 0.6, h * 0.89)
          ..lineTo(w * 0.65, h * 0.89)
          ..quadraticBezierTo(w * 0.75, h * 0.86, w * 0.65, h * 0.83),
        Paint()..color = lightColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
