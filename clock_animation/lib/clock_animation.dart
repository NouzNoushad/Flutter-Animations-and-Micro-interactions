import 'dart:math';

import 'package:flutter/material.dart';

class ClockAnimationScreen extends StatefulWidget {
  const ClockAnimationScreen({super.key});

  @override
  State<ClockAnimationScreen> createState() => _ClockAnimationScreenState();
}

class _ClockAnimationScreenState extends State<ClockAnimationScreen>
    with TickerProviderStateMixin {
  List<AnimationController> c = [];

  late Animation<double> r1;
  late Animation<double> r2;
  late Animation<double> r3;
  late Animation<double> r4;
  late Animation<double> r5;
  late Animation<double> r6;
  late Animation<double> r7;
  late Animation<double> r8;
  late Animation<double> r9;
  late Animation<double> r10;
  late Animation<double> r11;

  late Animation<double> p1;
  late Animation<double> p2;
  late Animation<double> p3;
  late Animation<double> p4;
  late Animation<double> p5;
  late Animation<double> p6;
  late Animation<double> p7;
  late Animation<double> p8;
  late Animation<double> p9;
  late Animation<double> p10;
  late Animation<double> p11;

  initAnimation() {
    p1 = Tween<double>(begin: 0.20, end: 0.22).animate(
        CurvedAnimation(parent: c[0], curve: const Interval(0.8, 1.0)));
    p2 = Tween<double>(begin: 0.18, end: 0.22).animate(
        CurvedAnimation(parent: c[1], curve: const Interval(0.8, 1.0)));
    p3 = Tween<double>(begin: 0.16, end: 0.22).animate(
        CurvedAnimation(parent: c[2], curve: const Interval(0.8, 1.0)));
    p4 = Tween<double>(begin: 0.14, end: 0.22).animate(
        CurvedAnimation(parent: c[3], curve: const Interval(0.8, 1.0)));
    p5 = Tween<double>(begin: 0.12, end: 0.22).animate(
        CurvedAnimation(parent: c[4], curve: const Interval(0.8, 1.0)));
    p6 = Tween<double>(begin: 0.10, end: 0.22).animate(
        CurvedAnimation(parent: c[5], curve: const Interval(0.8, 1.0)));
    p7 = Tween<double>(begin: 0.08, end: 0.22).animate(
        CurvedAnimation(parent: c[6], curve: const Interval(0.8, 1.0)));
    p8 = Tween<double>(begin: 0.06, end: 0.22).animate(
        CurvedAnimation(parent: c[7], curve: const Interval(0.8, 1.0)));
    p9 = Tween<double>(begin: 0.04, end: 0.22).animate(
        CurvedAnimation(parent: c[8], curve: const Interval(0.8, 1.0)));
    p10 = Tween<double>(begin: 0.02, end: 0.22).animate(
        CurvedAnimation(parent: c[9], curve: const Interval(0.8, 1.0)));
    p11 = Tween<double>(begin: 0.0, end: 0.22).animate(
        CurvedAnimation(parent: c[10], curve: const Interval(0.8, 1.0)));

    r1 = r2 = r3 = r4 = r5 = r6 = r7 =
        r8 = r9 = r10 = r11 = Tween<double>(begin: 0.0, end: 1.0).animate(c[0]);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) {
      c.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 600)));
    }

    initAnimation();

    c[0].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r2 = r3 = r4 = r5 = r6 = r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 1.0, end: 2.0).animate(c[1]);
        c[1].forward();
      }
    });

    c[1].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r3 = r4 = r5 = r6 = r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 2.0, end: 3.0).animate(c[2]);
        c[2].forward();
      }
    });
    c[2].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r4 = r5 = r6 = r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 3.0, end: 4.0).animate(c[3]);
        c[3].forward();
      }
    });
    c[3].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r5 = r6 = r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 4.0, end: 5.0).animate(c[4]);
        c[4].forward();
      }
    });
    c[4].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r6 = r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 5.0, end: 6.0).animate(c[5]);
        c[5].forward();
      }
    });
    c[5].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r7 = r8 =
            r9 = r10 = r11 = Tween<double>(begin: 6.0, end: 7.0).animate(c[6]);
        c[6].forward();
      }
    });
    c[6].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r8 = r9 = r10 = r11 = Tween<double>(begin: 7.0, end: 8.0).animate(c[7]);
        c[7].forward();
      }
    });
    c[7].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r9 = r10 = r11 = Tween<double>(begin: 8.0, end: 9.0).animate(c[8]);
        c[8].forward();
      }
    });
    c[8].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r10 = r11 = Tween<double>(begin: 9.0, end: 10.0).animate(c[9]);
        c[9].forward();
      }
    });
    c[9].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        r11 = Tween<double>(begin: 10.0, end: 11.0).animate(c[10]);
        c[10].forward();
      }
    });
    c[10].addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          reset();
        });
      }
    });
  }

  reset() {
    for (int i = 0; i < 12; i++) {
      c[i].reset();
    }
    initAnimation();
  }

  @override
  void dispose() {
    for (int i = 0; i < 12; i++) {
      c[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            c[0].reset();
            c[0].forward();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge([...c]),
          builder: (context, child) {
            return CustomPaint(
              painter: DesignClock(
                r1: r1.value,
                r2: r2.value,
                r3: r3.value,
                r4: r4.value,
                r5: r5.value,
                r6: r6.value,
                r7: r7.value,
                r8: r8.value,
                r9: r9.value,
                r10: r10.value,
                r11: r11.value,
                p1: p1.value,
                p2: p2.value,
                p3: p3.value,
                p4: p4.value,
                p5: p5.value,
                p6: p6.value,
                p7: p7.value,
                p8: p8.value,
                p9: p9.value,
                p10: p10.value,
                p11: p11.value,
              ),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class DesignClock extends CustomPainter {
  DesignClock({
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.r5,
    required this.r6,
    required this.r7,
    required this.r8,
    required this.r9,
    required this.r10,
    required this.r11,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.p5,
    required this.p6,
    required this.p7,
    required this.p8,
    required this.p9,
    required this.p10,
    required this.p11,
  });
  final double r1;
  final double r2;
  final double r3;
  final double r4;
  final double r5;
  final double r6;
  final double r7;
  final double r8;
  final double r9;
  final double r10;
  final double r11;

  final double p1;
  final double p2;
  final double p3;
  final double p4;
  final double p5;
  final double p6;
  final double p7;
  final double p8;
  final double p9;
  final double p10;
  final double p11;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);

    drawSquare(double position, double r) {
      double i = -90.0 + 30.0 * r;
      var x1 = offset.dx + w * position * cos(i * pi / 180);
      var y1 = offset.dy + w * position * sin(i * pi / 180);

      var x2 = offset.dx + w * (position + 0.02) * cos(i * pi / 180);
      var y2 = offset.dy + w * (position + 0.02) * sin(i * pi / 180);

      canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8);
    }

    double i = r11;
    double position = p11;
    drawSquare(position, i);

    i = r10;
    position = p10;
    drawSquare(position, i);

    i = r9;
    position = p9;
    drawSquare(position, i);

    i = r8;
    position = p8;
    drawSquare(position, i);

    i = r7;
    position = p7;
    drawSquare(position, i);

    i = r6;
    position = p6;
    drawSquare(position, i);

    i = r5;
    position = p5;
    drawSquare(position, i);

    i = r4;
    position = p4;
    drawSquare(position, i);

    i = r3;
    position = p3;
    drawSquare(position, i);

    i = r2;
    position = p2;
    drawSquare(position, i);

    i = r1;
    position = p1;
    drawSquare(position, i);

    i = 0;
    position = 0.22;
    drawSquare(position, i);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
