import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TimerTransitions extends StatefulWidget {
  const TimerTransitions({super.key});

  @override
  State<TimerTransitions> createState() => _TimerTransitionsState();
}

class _TimerTransitionsState extends State<TimerTransitions>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late AnimationController controller2;

  late Animation<double> switchAnimation;
  late Animation<double> ringAnimation;
  late Animation<double> waveAnimation;
  late Animation<double> opacityAnimation;

  Timer? timer;
  double handlePosition = 0.0;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    switchAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 12, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 12), weight: 1),
    ]).animate(controller);

    ringAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.4), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 0.5), weight: 1),
    ]).animate(controller1);

    waveAnimation = Tween<double>(begin: 0, end: 0.6)
        .animate(CurvedAnimation(parent: controller2, curve: Curves.ease));
    opacityAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: controller2, curve: Curves.linear));

    repeatTimes(AnimationController controller, int times) {
      TickerFuture tickerFuture = controller.repeat();
      tickerFuture.timeout(Duration(seconds: times), onTimeout: () {
        controller.forward(from: 0);
        controller.stop(canceled: true);
      });
    }

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
          setState(() {
            handlePosition += 0.5;
          });
          if (handlePosition >= 6) {
            handlePosition = 0.0;
            timer.cancel();
            repeatTimes(controller1, 3);
            repeatTimes(controller2, 3);
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            controller.reset();
            controller.forward();
          },
          label: const Text(
            'animate',
            style: TextStyle(color: Colors.black),
          )),
      body: AnimatedBuilder(
          animation: Listenable.merge([controller, controller1]),
          builder: (context, child) {
            return Center(
                child: RotatedBox(
              quarterTurns: 3,
              child: Container(
                height: size.height * 0.4,
                width: size.width * 0.7,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: TimerClockPainter(
                      switchHeight: switchAnimation.value,
                      handlePosition: handlePosition,
                      ringPosition: ringAnimation.value,
                      backgroundRadius: waveAnimation.value,
                      opacity: opacityAnimation.value),
                ),
              ),
            ));
          }),
    );
  }
}

class TimerClockPainter extends CustomPainter {
  TimerClockPainter(
      {required this.switchHeight,
      required this.handlePosition,
      required this.ringPosition,
      required this.backgroundRadius,
      required this.opacity});
  final double switchHeight;
  final double handlePosition;
  final double ringPosition;
  final double backgroundRadius;
  final double opacity;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);
    double radius = w * 0.2;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white;

    // background wave
    canvas.drawCircle(offset, w * backgroundRadius,
        Paint()..color = Colors.white24.withOpacity(opacity));

    // top line
    double lineCenter = h * ringPosition;
    canvas.drawLine(Offset(offset.dx + radius + 20, lineCenter - 30),
        Offset(offset.dx + radius + 20, lineCenter + 30), paint);

    // circle border
    canvas.drawCircle(offset, radius, Paint()..color = Colors.black);
    canvas.drawCircle(offset, radius, paint);

    // switch
    double si = 0.8 * 60;
    double sNeedleHeight = switchHeight;
    var sNeedleX = offset.dx + w * 0.2 * cos(si * pi / 180);
    var sNeedleY = offset.dy + w * 0.2 * sin(si * pi / 180);
    canvas.drawLine(Offset(sNeedleX, sNeedleY),
        Offset(sNeedleX + sNeedleHeight, sNeedleY + sNeedleHeight), paint);

    // handles
    double i = handlePosition * 60;
    var needleX = offset.dx + w * 0.16 * cos(i * pi / 180);
    var needleY = offset.dy + w * 0.16 * sin(i * pi / 180);
    canvas.drawLine(offset, Offset(needleX, needleY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
