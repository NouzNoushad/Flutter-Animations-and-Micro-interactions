import 'package:flutter/material.dart';

class ToggleOnOff extends StatefulWidget {
  const ToggleOnOff({super.key});

  @override
  State<ToggleOnOff> createState() => _ToggleOnOffState();
}

class _ToggleOnOffState extends State<ToggleOnOff>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> switchPositionAnimation;
  late Animation<double> switchShapeAnimation;
  Color backgroundColor = Colors.white;
  Color foregroundColor = Colors.black;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    switchPositionAnimation =
        Tween<double>(begin: 0.3, end: 0.7).animate(controller);

    switchShapeAnimation =
        Tween<double>(begin: 0.08, end: 0.03).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    height: size.height * 0.25,
                    width: size.width * 0.7,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: TogglePainter(
                          switchPosition: switchPositionAnimation.value,
                          switchShape: switchShapeAnimation.value,
                          backgroundColor: backgroundColor,
                          foregroundColor: foregroundColor),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isCompleted) {
                        backgroundColor = Colors.white;
                        foregroundColor = Colors.black;
                        Future.delayed(const Duration(milliseconds: 200), () {
                          controller.reverse();
                        });
                      } else {
                        backgroundColor = Colors.black;
                        foregroundColor = Colors.white;
                        Future.delayed(const Duration(milliseconds: 200), () {
                          controller.forward();
                        });
                      }
                    },
                    child: Container(
                      height: size.height * 0.15,
                      width: size.width * 0.6,
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

class TogglePainter extends CustomPainter {
  TogglePainter({
    required this.switchPosition,
    required this.switchShape,
    required this.backgroundColor,
    required this.foregroundColor,
  });
  final double switchPosition;
  final double switchShape;
  final Color backgroundColor;
  final Color foregroundColor;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);

    // shadow
    canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: offset, width: w * 0.65, height: h * 0.35),
              Radius.circular(h * 0.35))),
        Colors.black,
        20,
        true);

    // background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: w * 0.65, height: h * 0.35),
            Radius.circular(h * 0.35)),
        Paint()..color = backgroundColor);

    // outer switch
    canvas.drawCircle(Offset(w * switchPosition, h * 0.5), w * 0.09,
        Paint()..color = foregroundColor);

    // inner switch
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(w * switchPosition, h * 0.5),
                width: w * switchShape,
                height: h * 0.11),
            const Radius.circular(20)),
        Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
