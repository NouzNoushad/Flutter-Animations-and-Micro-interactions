import 'package:flutter/material.dart';

class SubmitButtonAnimation extends StatefulWidget {
  const SubmitButtonAnimation({super.key});

  @override
  State<SubmitButtonAnimation> createState() => _SubmitButtonAnimationState();
}

class _SubmitButtonAnimationState extends State<SubmitButtonAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  late Animation<double> shrinkAnimation;
  late Animation<double> loadingAnimation;
  late Animation<double> enlargeAnimation;
  late Animation<double> formCircleAnimation;
  late Animation<double> reverseAnimation;

  bool isSubmitted = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    shrinkAnimation = Tween<double>(begin: 0.5, end: 0.25).animate(controller);
    loadingAnimation = Tween<double>(begin: 0.1, end: 0.75).animate(
        CurvedAnimation(parent: controller1, curve: Curves.slowMiddle));
    enlargeAnimation =
        Tween<double>(begin: 0.25, end: 0.5).animate(controller2);
    formCircleAnimation =
        Tween<double>(begin: 0.8, end: 0.27).animate(controller2);
    reverseAnimation =
        Tween<double>(begin: 0.27, end: 0.8).animate(controller3);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.forward();
      }
    });
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.forward();
      }
    });
    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          controller3.forward();
          setState(() {
            isSubmitted = false;
          });
        });
      }
    });
    controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller1.reset();
        controller2.reset();
        controller3.reset();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: [
          AnimatedBuilder(
              animation: Listenable.merge(
                  [controller, controller1, controller2, controller3]),
              builder: (context, child) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: SubmitButtonPainter(
                        controller: controller,
                        controller1: controller1,
                        controller2: controller2,
                        controller3: controller3,
                        buttonHeight: shrinkAnimation.value,
                        loadingWidth: loadingAnimation.value,
                        buttonExpand: enlargeAnimation.value,
                        buttonWidth: formCircleAnimation.value,
                        resetWidth: reverseAnimation.value,
                        isSubmitted: isSubmitted),
                  ),
                );
              }),
          if (!isSubmitted)
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSubmitted = true;
                  });
                  controller.forward();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      'Submit'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 23,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ))
        ],
      )),
    );
  }
}

class SubmitButtonPainter extends CustomPainter {
  SubmitButtonPainter(
      {required this.controller,
      required this.controller1,
      required this.controller2,
      required this.controller3,
      required this.buttonHeight,
      required this.loadingWidth,
      required this.buttonExpand,
      required this.buttonWidth,
      required this.resetWidth,
      required this.isSubmitted});

  final AnimationController controller;
  final AnimationController controller1;
  final AnimationController controller2;
  final AnimationController controller3;

  final double buttonHeight;
  final double loadingWidth;
  final double buttonExpand;
  final double buttonWidth;
  final double resetWidth;

  final bool isSubmitted;

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // first animation ,third animation and fourth animation
    drawButtonBorder(double width, double height) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset(w * 0.5, h * 0.5),
                  width: w * width,
                  height: h * height),
              const Radius.circular(40)),
          paint);
    }

    if (controller2.isCompleted) {
      drawButtonBorder(resetWidth, 0.5);
    } else if (controller1.isCompleted) {
      drawButtonBorder(buttonWidth, buttonExpand);
    } else {
      drawButtonBorder(0.8, buttonHeight);
    }

    // second animation
    if (controller.isCompleted && controller1.isAnimating) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(w * 0.125, h * 0.425, w * loadingWidth, h * 0.15),
              const Radius.circular(40)),
          Paint()..color = Colors.black);
    }
    
    // submitted icon
    if (controller2.isCompleted && isSubmitted) {
      canvas.drawPath(
          Path()
            ..moveTo(w * 0.45, h * 0.52)
            ..lineTo(w * 0.48, h * 0.57)
            ..lineTo(w * 0.55, h * 0.42),
          paint
            ..strokeWidth = 5.5
            ..strokeCap = StrokeCap.square);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
