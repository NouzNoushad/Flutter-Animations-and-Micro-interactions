import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(232, 232, 232, 1);
const Color switchBackgroundColor = Color.fromRGBO(75, 77, 75, 1);
const Color iconColor = Color.fromRGBO(245, 245, 245, 1);
const Color successColor = Color.fromRGBO(0, 172, 134, 1);
const Color errorColor = Color.fromRGBO(245, 113, 100, 1);

class ToggleSwitchScreen extends StatefulWidget {
  const ToggleSwitchScreen({super.key});

  @override
  State<ToggleSwitchScreen> createState() => _ToggleSwitchScreenState();
}

class _ToggleSwitchScreenState extends State<ToggleSwitchScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late Animation<double> switchSlideAnimation;
  late Animation<Offset> successScaleAnimation;
  late Animation<Offset> errorScaleAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    switchSlideAnimation =
        Tween<double>(begin: -0.25, end: 0.25).animate(controller);
    successScaleAnimation =
        Tween<Offset>(begin: const Offset(0.5, 1), end: const Offset(0, 0))
            .animate(controller1);
    errorScaleAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.5, 1))
            .animate(controller1);
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
                child: GestureDetector(
              onTap: () {
                if (controller.isCompleted) {
                  controller.reverse();
                  controller1.reverse();
                } else {
                  controller.forward();
                  controller1.forward();
                }
              },
              child: Container(
                height: size.height * 0.12,
                width: size.width * 0.5,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: SwitchPainter(
                      switchSlidePosition: switchSlideAnimation.value,
                      successScaleValue: successScaleAnimation.value,
                      errorScaleValue: errorScaleAnimation.value),
                ),
              ),
            ));
          }),
    );
  }
}

class SwitchPainter extends CustomPainter {
  SwitchPainter({
    required this.switchSlidePosition,
    required this.successScaleValue,
    required this.errorScaleValue,
  });
  final double switchSlidePosition;
  final Offset successScaleValue;
  final Offset errorScaleValue;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    // Paint paint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;
    double padding = 10;
    double innerPadding = 8;

    drawIcon(IconData iconData, double offsetWidth, double size) {
      IconData icon = iconData;
      TextPainter textPainter = TextPainter(
          textAlign: TextAlign.center, textDirection: TextDirection.rtl);
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontSize: 35.0 * size,
              fontFamily: icon.fontFamily,
              color: iconColor));
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(offset.dx + offsetWidth, offset.dy - h * 0.16));
    } // offset.dx - w * errorScaleValue.dx * 0.68 // offset.dx + w * successScaleValue.dx * 0.32

    // background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: offset, width: w + padding, height: h + padding),
            const Radius.circular(10)),
        Paint()..color = switchBackgroundColor);

    // error
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(offset.dx - w * 0.25, offset.dy),
                width: w * errorScaleValue.dx - innerPadding,
                height: h * errorScaleValue.dy - innerPadding),
            const Radius.circular(10)),
        Paint()..color = errorColor);

    drawIcon(Icons.close, -w * errorScaleValue.dx * 0.68, errorScaleValue.dy);

    // success
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(offset.dx + w * 0.25, offset.dy),
                width: w * successScaleValue.dx - innerPadding,
                height: h * successScaleValue.dy - innerPadding),
            const Radius.circular(10)),
        Paint()..color = successColor);

    drawIcon(Icons.done, w * successScaleValue.dx * 0.32, successScaleValue.dy);

    // switch
    Offset switchCenter =
        Offset(offset.dx + w * switchSlidePosition, offset.dy);

    // switch background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: switchCenter, width: w * 0.5, height: h),
            const Radius.circular(10)),
        Paint()..color = backgroundColor);

    // switch menu
    double menuPosition = 10;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(switchCenter.dx - menuPosition, switchCenter.dy),
            width: w * 0.02,
            height: h * 0.35),
        Paint()..color = iconColor);
    canvas.drawRect(
        Rect.fromCenter(
            center: switchCenter, width: w * 0.02, height: h * 0.35),
        Paint()..color = iconColor);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(switchCenter.dx + menuPosition, switchCenter.dy),
            width: w * 0.02,
            height: h * 0.35),
        Paint()..color = iconColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
