import 'dart:async';

import 'package:flutter/material.dart';

const Color backgroundColor = Colors.white;
const Color primaryColor = Color.fromARGB(255, 124, 2, 2);
const Color secondaryColor = Color.fromARGB(255, 252, 49, 34);

class CheckTyping {
  final int milliseconds;

  Timer? timer;

  CheckTyping({this.milliseconds = 1000});

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class LoginEyeScreen extends StatefulWidget {
  const LoginEyeScreen({super.key});

  @override
  State<LoginEyeScreen> createState() => _LoginEyeScreenState();
}

class _LoginEyeScreenState extends State<LoginEyeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;

  late Animation<int> lookingAnimation;
  late Animation<double> blinkAnimation;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isNameTyping = false;
  bool isPasswordTyping = false;
  CheckTyping checkTyping = CheckTyping();

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    lookingAnimation = IntTween(begin: 1, end: 6).animate(controller);
    blinkAnimation = Tween<double>(begin: 30, end: 0).animate(controller1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AnimatedBuilder(
              animation: Listenable.merge([controller, controller1]),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CustomPaint(
                      painter: EyePainter(
                          isNameTyping: isNameTyping,
                          isPasswordTyping: isPasswordTyping,
                          blinkHeight: blinkAnimation.value,
                          lookingHeight: lookingAnimation.value),
                      size: size,
                    ),
                    Positioned(
                      bottom: size.height * 0.06,
                      left: size.width * 0.1,
                      child: Container(
                        height: size.height * 0.6,
                        width: size.width * 0.8,
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'You get one shot'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Text(
                                    "Don't Mess Up!",
                                    style: TextStyle(
                                        fontSize: 30,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                children: [
                                  TextField(
                                    controller: nameController,
                                    style: const TextStyle(
                                      decorationThickness: 0,
                                      color: primaryColor,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'What Do We Call You',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: primaryColor,
                                      )),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isPasswordTyping = false;
                                        isNameTyping = true;
                                      });
                                      controller.forward();
                                      checkTyping.run(() {
                                        setState(() {
                                          controller.reverse();
                                        });
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: passwordController,
                                    style: const TextStyle(
                                      decorationThickness: 0,
                                      color: primaryColor,
                                    ),
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "What's The Password?",
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: primaryColor,
                                      )),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isNameTyping = false;
                                        isPasswordTyping = true;
                                      });
                                      controller1.forward();
                                      checkTyping.run(() {
                                        controller1.reverse();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: size.width * 0.8,
                                height: size.height * 0.07,
                                child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordTyping = false;
                                        isNameTyping = false;
                                      });
                                      nameController.text = "";
                                      passwordController.text = "";
                                      controller.reset();
                                      controller1.reset();
                                    },
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: primaryColor,
                                        side: const BorderSide(
                                            color: primaryColor)),
                                    child: Text(
                                      'Submit'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 18, letterSpacing: 1),
                                    )),
                              )
                            ]),
                      ),
                    ),
                  ],
                );
              }),
          Container(
            height: size.height * 0.05,
            width: double.infinity,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

class EyePainter extends CustomPainter {
  EyePainter(
      {required this.isNameTyping,
      required this.isPasswordTyping,
      required this.blinkHeight,
      required this.lookingHeight});
  final bool isNameTyping;
  final bool isPasswordTyping;
  final double blinkHeight;
  final int lookingHeight;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    // Paint paint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..color = Colors.black
    //   ..strokeWidth = 1.2;
    // background
    canvas.drawShadow(
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(w * 0.5, h * 0.62),
                    width: w * 0.85,
                    height: h * 0.68),
                const Radius.circular(20)),
          ),
        Colors.black,
        5,
        true);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * 0.5, h * 0.62),
                width: w * 0.85,
                height: h * 0.68),
            const Radius.circular(20)),
        Paint()..color = Colors.white);

    // eye
    double centerHeight = h * 0.28;
    double maxHeight = centerHeight - 80;
    double minHeight = centerHeight + 80;

    canvas.drawPath(
        Path()
          ..moveTo(w * 0.3, centerHeight)
          ..quadraticBezierTo(w * 0.5, maxHeight, w * 0.7, centerHeight)
          ..quadraticBezierTo(w * 0.5, minHeight, w * 0.3, centerHeight),
        Paint()..color = secondaryColor);

    double x = w * 0.5;
    double y = h * 0.28;
    double sy = y;
    double lr = w * 0.08;
    double sr = w * 0.05;
    if (isNameTyping) {
      y = y + lookingHeight * 1;
      sy = y + lookingHeight * 1.8;
    }
    // eye ball
    canvas.drawCircle(Offset(x, y), lr, Paint()..color = Colors.white);

    canvas.drawCircle(Offset(x, sy), sr, Paint()..color = primaryColor);

    if (isPasswordTyping) {
      maxHeight = centerHeight - 70;
      minHeight = centerHeight + 70;
      double d = blinkHeight;
      double th = centerHeight - d;
      double bh = centerHeight + d;
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.4, th)
            ..quadraticBezierTo(w * 0.5, h * 0.28 - 70 + d, w * 0.6, th)
            ..close(),
          Paint()..color = secondaryColor);

      canvas.drawPath(
          Path()
            ..moveTo(w * 0.6, bh)
            ..quadraticBezierTo(w * 0.5, h * 0.28 + 70 - d, w * 0.4, bh)
            ..close(),
          Paint()..color = secondaryColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
