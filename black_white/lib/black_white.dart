import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(245, 245, 245, 1);
const Color primaryColor = Colors.black;
const Color secondaryColor = Colors.white;

class BlackWhiteScreen extends StatefulWidget {
  const BlackWhiteScreen({super.key});

  @override
  State<BlackWhiteScreen> createState() => _BlackWhiteScreenState();
}

class _BlackWhiteScreenState extends State<BlackWhiteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500))
      ..repeat();
    slideAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: -0.5, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: -0.5), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BlackWhitePainter(circleXPosition: slideAnimation.value),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class BlackWhitePainter extends CustomPainter {
  const BlackWhitePainter({
    required this.circleXPosition,
  });
  final double circleXPosition;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = primaryColor;
    Offset offset = Offset(w * 0.5, h * 0.5);

    // rectangle
    canvas.drawRect(
        Rect.fromCenter(center: offset, width: w * 0.4, height: h * 0.6),
        Paint()..color = primaryColor);
    canvas.drawRect(
        Rect.fromCenter(center: offset, width: w * 0.4, height: h * 0.6),
        paint);

    // circle
    canvas.drawCircle(
        Offset(offset.dx + offset.dx * circleXPosition, offset.dy),
        w * 0.2,
        Paint()
          ..color = Color.fromARGB((1.0 * 255).round(), 255, 255, 255)
          ..blendMode = BlendMode.difference);
    canvas.drawCircle(
        Offset(offset.dx + offset.dx * circleXPosition, offset.dy),
        w * 0.2,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
