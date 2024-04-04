import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(235, 231, 245, 1);
const Color primaryColor = Color.fromRGBO(245, 0, 110, 1);

class ElevatedButtonScreen extends StatefulWidget {
  const ElevatedButtonScreen({super.key});

  @override
  State<ElevatedButtonScreen> createState() => _ElevatedButtonScreenState();
}

class _ElevatedButtonScreenState extends State<ElevatedButtonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> buttonFillWidth;
  late Animation<Color?> buttonColor;
  bool onTapped = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    buttonFillWidth = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    buttonColor =
        ColorTween(begin: primaryColor, end: Colors.white).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Center(
                child: Container(
              height: size.height * 0.08,
              width: size.width * 0.6,
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    onTapped = true;
                  });
                  controller.reset();
                  controller.forward();
                  Future.delayed(const Duration(milliseconds: 700), () {
                    controller.reverse();
                    setState(() {
                      onTapped = false;
                    });
                  });
                },
                child: CustomPaint(
                  painter: HoverButtonPainter(
                    fillWidth: buttonFillWidth.value,
                    onTapped: onTapped,
                  ),
                  child: Center(
                      child: Text(
                    'Continue'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: buttonColor.value,
                      letterSpacing: 1,
                    ),
                  )),
                ),
              ),
            ));
          }),
    );
  }
}

class HoverButtonPainter extends CustomPainter {
  HoverButtonPainter({
    required this.fillWidth,
    required this.onTapped,
  });
  final double fillWidth;
  final bool onTapped;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // background shadow
    canvas.drawShadow(
        Path()..addRect(Rect.fromCenter(center: offset, width: w, height: h)),
        primaryColor,
        onTapped ? 0 : 10,
        false);

    // fill color
    canvas.drawRect(Rect.fromCenter(center: offset, width: w, height: h),
        Paint()..color = backgroundColor);

    // overlay effect
    canvas.drawRect(
        Rect.fromCenter(center: offset, width: w * fillWidth, height: h),
        Paint()..color = primaryColor.withOpacity(fillWidth));

    // border
    canvas.drawRect(
        Rect.fromCenter(center: offset, width: w, height: h), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
