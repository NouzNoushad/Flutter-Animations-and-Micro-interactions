import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(151, 62, 95, 1);
const Color switchColor = Color.fromRGBO(61, 8, 28, 1);
const Color handColor = Color.fromRGBO(245, 218, 210, 1);
const Color handBorderColor = Color.fromRGBO(250, 199, 184, 1);
const Color shirtColor = Color.fromRGBO(54, 125, 245, 1);

class HandSwitchScreen extends StatefulWidget {
  const HandSwitchScreen({super.key});

  @override
  State<HandSwitchScreen> createState() => _HandSwitchScreenState();
}

class _HandSwitchScreenState extends State<HandSwitchScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;

  late Animation<double> handAnimation;
  late Animation<double> switchAnimation;
  bool changeDirection = false;

  @override
  void initState() {
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    initAnimation() {
      handAnimation = Tween<double>(begin: -0.1, end: 0.8).animate(controller1);
      switchAnimation = Tween<double>(begin: 60, end: -60).animate(controller2);
    }

    initAnimation();
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
        controller2.forward();
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            changeDirection = !changeDirection;
          });
          if (changeDirection) {
            switchAnimation =
                Tween<double>(begin: -60, end: 60).animate(controller2);
            handAnimation =
                Tween<double>(begin: 1.1, end: 0.2).animate(controller1);
          } else {
            initAnimation();
          }
          controller2.reset();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge([controller1, controller2]),
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                controller1.reset();
                controller1.forward();
              },
              child: Center(
                child: Container(
                  height: size.height * 0.14,
                  width: size.width * 0.6,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: HandSwitchPainter(
                        handPosition: handAnimation.value,
                        switchPosition: switchAnimation.value,
                        changeDirection: changeDirection),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class HandSwitchPainter extends CustomPainter {
  HandSwitchPainter(
      {required this.handPosition,
      required this.switchPosition,
      required this.changeDirection});
  final double handPosition;
  final double switchPosition;
  final bool changeDirection;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = handBorderColor;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint handPaint = Paint()..color = handColor;
    Paint shirtPaint = Paint()..color = shirtColor;

    // switch background
    RRect rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: offset, width: w, height: h),
        Radius.circular(h * 0.5));

    canvas.clipRRect(rRect);
    canvas.drawRRect(rRect, Paint()..color = switchColor);

    // drawHand
    Offset handOffset = Offset(w * handPosition, h * 0.5);

    drawHand(Paint paint, int direction) {
      canvas.drawPath(
          Path()
            ..moveTo(
                handOffset.dx - w * 0.32 * direction, handOffset.dy - h * 0.2)
            ..lineTo(handOffset.dx - direction * 10, handOffset.dy - h * 0.2)
            ..quadraticBezierTo(
                handOffset.dx + direction * 5,
                handOffset.dy - h * 0.21,
                handOffset.dx - direction * 8,
                handOffset.dy - h * 0.1)
            ..lineTo(handOffset.dx - direction * 30, handOffset.dy - h * 0.1)
            ..lineTo(handOffset.dx + direction * 8, handOffset.dy - h * 0.1)
            ..quadraticBezierTo(
                handOffset.dx + direction * 10,
                handOffset.dy - h * 0.03,
                handOffset.dx - direction * 5,
                handOffset.dy - h * 0.0)
            ..lineTo(handOffset.dx - direction * 30, handOffset.dy - h * 0.0)
            ..lineTo(handOffset.dx + direction * 5, handOffset.dy - h * 0.0)
            ..quadraticBezierTo(
                handOffset.dx + direction * 10,
                handOffset.dy - h * -0.03,
                handOffset.dx - direction * 5,
                handOffset.dy - h * -0.1)
            ..lineTo(handOffset.dx - direction * 30, handOffset.dy - h * -0.1)
            ..lineTo(handOffset.dx - direction * 5, handOffset.dy - h * -0.1)
            ..quadraticBezierTo(
                handOffset.dx + direction * 5,
                handOffset.dy - h * -0.12,
                handOffset.dx - direction * 12,
                handOffset.dy - h * -0.2)
            ..lineTo(
                handOffset.dx - direction * w * 0.25, handOffset.dy - h * -0.2)
            ..quadraticBezierTo(
                handOffset.dx - direction * w * 0.28,
                handOffset.dy - h * -0.2,
                handOffset.dx - direction * w * 0.32,
                handOffset.dy - h * -0.1)
            ..lineTo(
                handOffset.dx - direction * w * 0.32, handOffset.dy - h * 0.2),
          paint);
    }

    drawThump(Paint paint, int direction) {
      canvas.drawPath(
          Path()
            ..moveTo(
                handOffset.dx - direction * w * 0.20, handOffset.dy - h * 0.1)
            ..lineTo(
                handOffset.dx - direction * 1 * 28, handOffset.dy - h * 0.1)
            ..quadraticBezierTo(
                handOffset.dx - direction * 5,
                handOffset.dy - h * 0.1,
                handOffset.dx - direction * 25,
                handOffset.dy - h * 0.0)
            ..lineTo(
                handOffset.dx - direction * w * 0.25, handOffset.dy - h * 0.0),
          paint);
    }

    drawShirt(int direction) {
      // inner shirt
      canvas.drawPath(
          Path()
            ..moveTo(
                handOffset.dx - direction * w * 0.32, handOffset.dy - h * 0.2)
            ..lineTo(
                handOffset.dx - direction * w * 0.32, handOffset.dy - h * -0.1)
            ..lineTo(
                handOffset.dx - direction * w * 0.4, handOffset.dy - h * -0.1)
            ..lineTo(
                handOffset.dx - direction * w * 0.4, handOffset.dy - h * 0.2)
            ..close(),
          Paint()..color = Colors.white);

      // outer shirt
      canvas.drawPath(
          Path()
            ..moveTo(
                handOffset.dx - direction * w * 0.4, handOffset.dy - h * 0.2)
            ..lineTo(
                handOffset.dx - direction * w * 0.4, handOffset.dy - h * -0.2)
            ..lineTo(
                handOffset.dx - direction * w * 0.9, handOffset.dy - h * -0.2)
            ..lineTo(
                handOffset.dx - direction * w * 0.9, handOffset.dy - h * 0.2)
            ..close(),
          shirtPaint);
    }

    // hand
    int direction = changeDirection ? -1 : 1;

    drawHand(handPaint, direction);
    drawHand(paint, direction);

    // switch
    canvas.drawCircle(
        Offset(offset.dx + switchPosition, offset.dy),
        w * 0.18, // -70 -> +70
        Paint()..color = backgroundColor);

    drawThump(handPaint, direction);
    drawThump(paint, direction);

    drawShirt(direction);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
