import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(235, 235, 235, 1);

class SwitcherScreen extends StatefulWidget {
  const SwitcherScreen({super.key});

  @override
  State<SwitcherScreen> createState() => _SwitcherScreenState();
}

class _SwitcherScreenState extends State<SwitcherScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late AnimationController controller2;

  late Animation<double> leftSlideAnimation;
  late Animation<double> rightSlideAnimation;
  late Animation<double> scaleAnimation;

  bool isButtonTapped = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    leftSlideAnimation = Tween<double>(begin: -41, end: 41).animate(controller);
    rightSlideAnimation =
        Tween<double>(begin: 41, end: -41).animate(controller1);
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(controller2);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge([controller, controller1, controller2]),
          builder: (context, child) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (controller1.isCompleted) {
                    setState(() {
                      isButtonTapped = true;
                    });
                    controller2.forward();
                    controller.reverse();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        isButtonTapped = false;
                      });
                      controller2.reverse();
                      controller1.reverse();
                    });
                  } else {
                    setState(() {
                      isButtonTapped = true;
                    });
                    controller2.forward();
                    controller.forward();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        isButtonTapped = false;
                      });
                      controller2.reverse();
                      controller1.forward();
                    });
                  }
                },
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Container(
                    height: size.height * 0.11,
                    width: size.width * 0.5,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: SwitcherPainter(
                        leftSlideHeight: leftSlideAnimation.value,
                        rightSlideHeight: rightSlideAnimation.value,
                        isTapped: isButtonTapped,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SwitcherPainter extends CustomPainter {
  SwitcherPainter({
    required this.leftSlideHeight,
    required this.rightSlideHeight,
    required this.isTapped,
  });
  final double leftSlideHeight;
  final double rightSlideHeight;
  final bool isTapped;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    // Paint paint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.stroke;

    // box shadow
    canvas.drawShadow(
        Path()..addRect(Rect.fromCenter(center: offset, width: w, height: h)),
        Colors.black,
        isTapped ? 0 : 50,
        false);

    // cut rectangle
    canvas.clipRect(Rect.fromCenter(center: offset, width: w, height: h));

    // left
    double leftHeight = leftSlideHeight;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx - (w * 0.25), offset.dy - (h * 0.5) + leftHeight),
            width: w * 0.5,
            height: h),
        Paint()..color = Colors.white);

    canvas.drawCircle(
        Offset(offset.dx - (w * 0.25), offset.dy - (h * 0.5) + leftHeight),
        w * 0.08,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.black);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx - (w * 0.25), offset.dy + (h * 0.5) + leftHeight),
            width: w * 0.5,
            height: h),
        Paint()..color = Colors.black);

    canvas.drawCircle(
        Offset(offset.dx - (w * 0.25), offset.dy + (h * 0.5) + leftHeight),
        w * 0.08,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.white);

    // right
    double rightHeight = rightSlideHeight;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx + (w * 0.25), offset.dy - (h * 0.5) + rightHeight),
            width: w * 0.5,
            height: h),
        Paint()..color = Colors.white);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx + (w * 0.25), offset.dy - (h * 0.5) + rightHeight),
            width: w * 0.04,
            height: h * 0.4),
        Paint()..color = Colors.black);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx + (w * 0.25), offset.dy + (h * 0.5) + rightHeight),
            width: w * 0.5,
            height: h),
        Paint()..color = Colors.black);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                offset.dx + (w * 0.25), offset.dy + (h * 0.5) + rightHeight),
            width: w * 0.04,
            height: h * 0.4),
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
