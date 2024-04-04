import 'package:flutter/material.dart';

class MonsterEatsScreen extends StatefulWidget {
  const MonsterEatsScreen({super.key});

  @override
  State<MonsterEatsScreen> createState() => _MonsterEatsScreenState();
}

class _MonsterEatsScreenState extends State<MonsterEatsScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;

  late Animation<double> mouth1Animation;
  late Animation<double> eye1Animation;

  late Animation<double> liftFormAnimation;

  Animation<double>? mouth2Animation;
  Animation<double>? formEatingAnimation;

  initAnimation() {
    mouth1Animation = Tween<double>(begin: 0.25, end: 0.3).animate(controller);
    eye1Animation = Tween<double>(begin: 0.012, end: 0.018).animate(controller);

    liftFormAnimation =
        Tween<double>(begin: 0.00, end: 0.02).animate(controller1);

    mouth2Animation =
        Tween<double>(begin: 0.05, end: 0.08).animate(controller2);
    formEatingAnimation =
        Tween<double>(begin: 0.06, end: 0.6).animate(controller3);
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller4 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    initAnimation();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        mouth1Animation =
            Tween<double>(begin: 0.3, end: 0.35).animate(controller1);
        eye1Animation =
            Tween<double>(begin: 0.018, end: 0.023).animate(controller1);
      }
    });

    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        mouth1Animation =
            Tween<double>(begin: 0.35, end: 0.75).animate(controller2);
        liftFormAnimation =
            Tween<double>(begin: 0.02, end: 0.06).animate(controller2);
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        liftFormAnimation =
            Tween<double>(begin: 0.06, end: 0.1).animate(controller3);
      }
    });

    controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller4.forward();
        mouth1Animation =
            Tween<double>(begin: 0.7, end: 0.2).animate(controller4);
        mouth2Animation =
            Tween<double>(begin: 0.08, end: 0.02).animate(controller4);
        eye1Animation =
            Tween<double>(begin: 0.023, end: 0.012).animate(controller4);
      }
    });

    controller4.addStatusListener((status) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        reset();
      });
    });
    super.initState();
  }

  reset() {
    controller.reset();
    controller1.reset();
    controller2.reset();
    controller3.reset();
    controller4.reset();
    initAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(93, 60, 135, 1),
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [controller, controller1, controller2, controller3, controller4]),
          builder: (context, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    CustomPaint(
                      painter: MonsterPainter(
                          mouthScaleWidth: mouth1Animation.value,
                          eyeScaleWidth: eye1Animation.value,
                          liftHeight: liftFormAnimation.value,
                          mouthScaleHeight: mouth2Animation?.value ?? 0.05,
                          formEatingHeight: formEatingAnimation?.value ?? 0.06),
                      size: size,
                    ),
                    Positioned(
                      left: size.width * 0.15,
                      bottom: size.height * (0.07 + liftFormAnimation.value),
                      child: liftFormAnimation.value > 0.06
                          ? Container(
                              height: size.height * 0.5,
                              width: size.width * 0.7,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.5, color: Colors.transparent),
                              ))
                          : Container(
                              height: size.height * 0.5,
                              width: size.width * 0.7,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.transparent)),
                              padding: const EdgeInsets.all(30),
                              child: Column(children: [
                                const Text.rich(TextSpan(
                                    text: 'monster',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'eats',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepPurple),
                                      )
                                    ])),
                                const SizedBox(
                                  height: 20,
                                ),
                                MonsterTextField(
                                    text: 'username',
                                    onTap: () {
                                      controller.reset();
                                      controller.forward();
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                MonsterTextField(
                                    text: 'password',
                                    onTap: () {
                                      if (controller.isCompleted) {
                                        controller1.forward();
                                      }
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    height: size.height * 0.075,
                                    width: size.width * 0.6,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (controller1.isCompleted) {
                                            controller2.forward();

                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              controller3.forward();
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            )),
                                        child: const Text(
                                          'om nom',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        )))
                              ]),
                            ),
                    ),
                  ],
                ),
                Container(
                  height: size.height * 0.2,
                  width: double.infinity,
                  color: const Color.fromRGBO(93, 60, 135, 1),
                ),
              ],
            );
          }),
    );
  }
}

class MonsterTextField extends StatelessWidget {
  const MonsterTextField({super.key, required this.text, required this.onTap});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey.shade600,
        decorationThickness: 0,
      ),
      decoration: InputDecoration(
        hintText: text,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}

class MonsterPainter extends CustomPainter {
  const MonsterPainter({
    required this.mouthScaleWidth,
    required this.eyeScaleWidth,
    required this.liftHeight,
    required this.mouthScaleHeight,
    required this.formEatingHeight,
  });
  final double mouthScaleWidth;
  final double eyeScaleWidth;
  final double liftHeight;
  final double mouthScaleHeight;
  final double formEatingHeight;

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    // Offset offset = Offset(w * 0.5, h * 0.5);
    // Paint paint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2
    //   ..color = Colors.black;

    // body
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.05, h * 0.3)
          ..lineTo(w * 0.05, h)
          ..lineTo(w * 0.95, h)
          ..lineTo(w * 0.95, h * 0.3)
          ..cubicTo(w * 0.9, h * 0, w * 0.1, h * 0, w * 0.05, h * 0.3),
        Paint()..color = const Color.fromRGBO(195, 228, 242, 1));

    // left eye
    canvas.drawCircle(
        Offset(w * 0.25, h * 0.28), w * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.25, h * 0.28), w * eyeScaleWidth,
        Paint()..color = Colors.black);

    // right eye
    canvas.drawCircle(
        Offset(w * 0.75, h * 0.28), w * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.75, h * 0.28), w * eyeScaleWidth,
        Paint()..color = Colors.black);

    // body spots
    canvas.drawCircle(Offset(w * 0.8, h * 0.96), w * 0.035,
        Paint()..color = const Color.fromRGBO(152, 201, 226, 1));
    canvas.drawCircle(Offset(w * 0.85, h * 0.88), w * 0.08,
        Paint()..color = const Color.fromRGBO(152, 201, 226, 1));

    // mouth
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * 0.5, h * 0.38),
                width: w * mouthScaleWidth,
                height: h * mouthScaleHeight),
            const Radius.circular(40)),
        Paint()..color = const Color.fromRGBO(57, 121, 148, 1));

    // form
    double formHeight = liftHeight;
    if (liftHeight > 0.06) {
      formHeight = formEatingHeight;
      canvas.clipRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * 0.5, h * 0.68),
                width: w * 1,
                height: h * 0.6),
            const Radius.circular(20)),
      );
    }

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * 0.5, h * (0.68 - formHeight)),
                width: w * 0.7,
                height: h * 0.5),
            const Radius.circular(50)),
        Paint()..color = Colors.white);

    // left hands
    Offset leftHandCenter = Offset(w * 0.1, h * (0.86 - liftHeight));
    canvas.drawPath(
        Path()
          ..moveTo(leftHandCenter.dx - 35, leftHandCenter.dy - 40)
          ..lineTo(leftHandCenter.dx - 20, leftHandCenter.dy + 40)
          ..cubicTo(
              leftHandCenter.dx - 20,
              leftHandCenter.dy + 60,
              leftHandCenter.dx + 50,
              leftHandCenter.dy + 70,
              leftHandCenter.dx + 45,
              leftHandCenter.dy + 20)
          ..lineTo(leftHandCenter.dx + 20, leftHandCenter.dy - 60)
          ..cubicTo(
              leftHandCenter.dx - 20,
              leftHandCenter.dy - 80,
              leftHandCenter.dx - 40,
              leftHandCenter.dy - 40,
              leftHandCenter.dx - 35,
              leftHandCenter.dy - 40),
        Paint()..color = const Color.fromRGBO(195, 228, 242, 1));

    // right hand
    Offset rightHandCenter = Offset(w * 0.9, h * (0.86 - liftHeight));
    canvas.drawPath(
        Path()
          ..moveTo(rightHandCenter.dx + 35, rightHandCenter.dy - 40)
          ..lineTo(rightHandCenter.dx + 20, rightHandCenter.dy + 40)
          ..cubicTo(
              rightHandCenter.dx + 20,
              rightHandCenter.dy + 60,
              rightHandCenter.dx - 50,
              rightHandCenter.dy + 70,
              rightHandCenter.dx - 45,
              rightHandCenter.dy + 20)
          ..lineTo(rightHandCenter.dx - 20, rightHandCenter.dy - 60)
          ..cubicTo(
              rightHandCenter.dx + 20,
              rightHandCenter.dy - 80,
              rightHandCenter.dx + 40,
              rightHandCenter.dy - 40,
              rightHandCenter.dx + 35,
              rightHandCenter.dy - 40),
        Paint()..color = const Color.fromRGBO(195, 228, 242, 1));

    // tooth cut
    canvas.clipRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(w * 0.5, h * 0.38),
              width: w * mouthScaleWidth,
              height: h * mouthScaleHeight),
          const Radius.circular(20)),
    );
    // tooth
    canvas.drawPath(
        Path()
          ..moveTo(w * (mouthScaleWidth + 0.3), h * 0.405)
          ..lineTo(w * (mouthScaleWidth + 0.3), h * 0.39)
          ..lineTo(w * (mouthScaleWidth + 0.33), h * 0.405)
          ..close(),
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
