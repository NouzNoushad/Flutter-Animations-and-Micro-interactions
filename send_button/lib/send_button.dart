import 'dart:math';

import 'package:flutter/material.dart';

class SendButtonScreen extends StatefulWidget {
  const SendButtonScreen({super.key});

  @override
  State<SendButtonScreen> createState() => _SendButtonScreenState();
}

class _SendButtonScreenState extends State<SendButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> sendAnimation;
  late Animation<double> ringAnimation;
  late Animation<double> progressAnimation;
  late Animation<int> textAnimation;

  bool showSendIcon = true;
  bool showProgress = false;
  bool showComplete = false;

  initAnimation() {
    sendAnimation = Tween<double>(begin: 0.0, end: 0.12).animate(_controller1);
    ringAnimation = Tween<double>(begin: 0.14, end: 0.18).animate(
      CurvedAnimation(parent: _controller1, curve: const Interval(0.4, 1.0)),
    );
    progressAnimation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_controller2);
    textAnimation = IntTween(begin: 0, end: 100).animate(_controller2);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    initAnimation();
    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showSendIcon = false;
          showProgress = true;
        });
        _controller2.forward();
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ringAnimation = Tween<double>(begin: 0.18, end: 0.14).animate(
          CurvedAnimation(
              parent: _controller3, curve: const Interval(0.4, 1.0)),
        );
        _controller3.forward();
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showProgress = false;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            showComplete = true;
          });
        });

        Future.delayed(const Duration(milliseconds: 1500), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showSendIcon = true;
      showProgress = false;
      showComplete = false;
    });
    initAnimation();
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
      body: AnimatedBuilder(
          animation:
              Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: SendPainter(
                    sendIconMovement: sendAnimation.value,
                    ringExpand: ringAnimation.value,
                    showSendIcon: showSendIcon,
                    progress: progressAnimation.value,
                    text: textAnimation.value,
                    showComplete: showComplete,
                  ),
                  size: size,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      reset();
                      _controller1.forward();
                    },
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: showProgress == true
                          ? Text(
                              textAnimation.value.toString(),
                              style: const TextStyle(
                                  fontSize: 42,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class SendPainter extends CustomPainter {
  SendPainter({
    required this.sendIconMovement,
    required this.ringExpand,
    required this.showSendIcon,
    required this.progress,
    required this.text,
    required this.showComplete,
  });
  final double sendIconMovement;
  final double ringExpand;
  bool showSendIcon;
  final double progress;
  final int text;
  final bool showComplete;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    // Paint paint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;

    drawSendIcon(Offset iconOffset) {
      canvas.drawPath(
          Path()
            ..moveTo(iconOffset.dx - w * 0.08, iconOffset.dy + h * 0.012)
            ..lineTo(iconOffset.dx + w * 0.04, iconOffset.dy - h * 0.04)
            ..lineTo(iconOffset.dx + w * 0.04, iconOffset.dy + h * 0.028)
            ..lineTo(iconOffset.dx, iconOffset.dy + h * 0.022)
            ..lineTo(iconOffset.dx - w * 0.02, iconOffset.dy + h * 0.045)
            ..lineTo(iconOffset.dx - w * 0.02, iconOffset.dy + h * 0.02)
            ..lineTo(iconOffset.dx + w * 0.02, iconOffset.dy - h * 0.018)
            ..lineTo(iconOffset.dx - w * 0.035, iconOffset.dy + h * 0.017)
            ..lineTo(iconOffset.dx - w * 0.08, iconOffset.dy + h * 0.012),
          Paint()..color = Colors.white);
    }

    drawCompleteIcon(Offset completeOffset) {
      canvas.drawPath(
          Path()
            ..moveTo(completeOffset.dx - w * 0.06, completeOffset.dy + h * 0.01)
            ..lineTo(completeOffset.dx - w * 0.02, completeOffset.dy + h * 0.03)
            ..lineTo(
                completeOffset.dx + w * 0.06, completeOffset.dy - h * 0.03),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8);
    }

    // border
    canvas.drawCircle(
        offset,
        w * ringExpand,
        Paint()
          ..color = const Color.fromRGBO(128, 159, 213, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8);

    // progress
    canvas.drawArc(
        Rect.fromCircle(center: offset, radius: w * ringExpand),
        -1.6,
        pi * progress,
        false,
        Paint()
          ..color = const Color.fromRGBO(76, 99, 160, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);

    // cut background
    canvas.clipRRect(
      RRect.fromRectAndRadius(Rect.fromCircle(center: offset, radius: w * 0.15),
          Radius.circular(h * 0.5)),
    );

    // background
    canvas.drawCircle(offset, w * 0.15,
        Paint()..color = const Color.fromRGBO(76, 99, 160, 1));

    if (showComplete) {
      // complete icon
      Offset completeOffset = Offset(w * 0.5, h * 0.5);
      drawCompleteIcon(completeOffset);
    }

    if (showSendIcon) {
      // icon
      Offset iconOffset = Offset(w * (0.5 + sendIconMovement),
          h * (0.5 - sendIconMovement)); // 0.0 -> 0.12
      drawSendIcon(iconOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
