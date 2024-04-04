import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(228, 241, 245, 1);
const Color pencilFrontColor = Color.fromRGBO(245, 230, 192, 1);
const Color pencilMidColor = Color.fromRGBO(191, 225, 234, 1);
const Color pencilBackColor = Color.fromRGBO(245, 98, 98, 1);
const Color cutterColor = Color.fromRGBO(245, 245, 245, 1);

class PencilCutterScreen extends StatefulWidget {
  const PencilCutterScreen({super.key});

  @override
  State<PencilCutterScreen> createState() => _PencilCutterScreenState();
}

class _PencilCutterScreenState extends State<PencilCutterScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late AnimationController _controller6;
  late AnimationController _controller7;

  late Animation<Offset> pencilOffset;
  late Animation<double> pencilAngle;
  late Animation<Offset> lineOffset;
  late Animation<Offset> cutterOffset;
  late Animation<Offset> waveOffset;
  late Animation<Offset> pencilInvertedOffset;
  late Animation<double> pencilInvertedAngle;

  bool showLine = false;
  bool showLineWave = false;

  initAnimation() {
    pencilOffset = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.64, 0.03))
        .animate(_controller1);

    pencilAngle = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller1, curve: const Interval(0.5, 1.0)),
    );

    lineOffset = Tween<Offset>(
            begin: const Offset(-0.25, 0.1), end: const Offset(0.25, 0.1))
        .animate(_controller2);

    cutterOffset = Tween<Offset>(
            begin: const Offset(0.0, -0.55), end: const Offset(0.0, 0.1))
        .animate(_controller3);

    waveOffset = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.1), end: const Offset(0.0, 0.15)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.15), end: const Offset(0.0, 0.05)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.05), end: const Offset(0.0, 0.1)),
          weight: 1),
    ]).animate(
        CurvedAnimation(parent: _controller4, curve: const Interval(0.0, 0.8)));

    pencilInvertedOffset = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(0.64, 0.05))
        .animate(_controller5);

    pencilInvertedAngle = Tween<double>(begin: 0.0, end: -0.1).animate(
      CurvedAnimation(parent: _controller5, curve: const Interval(0.5, 1.0)),
    );
  }

  @override
  void initState() {
    super.initState();

    int duration = 300;
    _controller1 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller2 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller3 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller4 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller5 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller6 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));
    _controller7 = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: duration,
        ));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLine = true;
        });
        pencilOffset = Tween<Offset>(
                begin: const Offset(-0.64, 0.03), end: const Offset(-0.14, 0.0))
            .animate(_controller2);
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLine = false;
          showLineWave = true;
        });
        pencilOffset = Tween<Offset>(
                begin: const Offset(-0.14, 0.0), end: const Offset(0.0, 0.0))
            .animate(_controller3);
        pencilAngle = Tween<double>(begin: 0.1, end: 0.0).animate(
          CurvedAnimation(
              parent: _controller3, curve: const Interval(0.6, 1.0)),
        );
        _controller3.forward();
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cutterOffset = Tween<Offset>(
                begin: const Offset(0.0, 0.1), end: const Offset(0.0, -0.1))
            .animate(_controller4);
        _controller4.forward();
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cutterOffset = Tween<Offset>(
                begin: const Offset(0.0, -0.1), end: const Offset(0.0, -0.25))
            .animate(_controller5);
        _controller5.forward();
      }
    });

    _controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLine = true;
          showLineWave = false;
        });
        pencilInvertedOffset = Tween<Offset>(
                begin: const Offset(0.64, 0.05), end: const Offset(0.14, 0.02))
            .animate(_controller6);

        lineOffset = Tween<Offset>(
                begin: const Offset(0.25, 0.1), end: const Offset(-0.25, 0.1))
            .animate(_controller6);
        cutterOffset = Tween<Offset>(
                begin: const Offset(0.0, -0.25), end: const Offset(0.0, -0.3))
            .animate(_controller6);
        _controller6.forward();
      }
    });

    _controller6.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLine = false;
        });
        pencilInvertedOffset = Tween<Offset>(
                begin: const Offset(0.14, 0.02), end: const Offset(0.0, 0.0))
            .animate(_controller7);
        pencilInvertedAngle = Tween<double>(begin: -0.1, end: 0.0).animate(
          CurvedAnimation(
              parent: _controller7, curve: const Interval(0.6, 1.0)),
        );
        cutterOffset = Tween<Offset>(
                begin: const Offset(0.0, -0.3), end: const Offset(0.0, 0.65))
            .animate(_controller7);
        _controller7.forward();
      }
    });

    _controller7.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showLine = false;
      showLineWave = false;
    });
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
    _controller5.reset();
    _controller6.reset();
    _controller7.reset();
    initAnimation();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            _controller1.reset();
            _controller1.forward();
          },
          label: const Text(
            'animate',
            style: TextStyle(color: Colors.black),
          )),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            _controller1,
            _controller2,
            _controller3,
            _controller4,
            _controller5,
            _controller6,
            _controller7,
          ]),
          builder: (context, child) {
            return CustomPaint(
              painter: PencilCutterPainter(
                pencilAngle: pencilAngle.value,
                pencilMovement: pencilOffset.value,
                lineMovement: lineOffset.value,
                showLine: showLine,
                showLineWave: showLineWave,
                cutterMovement: cutterOffset.value,
                waveMovement: waveOffset.value,
                pencilInvertedAngle: pencilInvertedAngle.value,
                pencilInvertedMovement: pencilInvertedOffset.value,
              ),
              size: MediaQuery.of(context).size,
            );
          }),
    );
  }
}

class PencilCutterPainter extends CustomPainter {
  PencilCutterPainter({
    required this.pencilAngle,
    required this.pencilMovement,
    required this.lineMovement,
    required this.showLine,
    required this.showLineWave,
    required this.cutterMovement,
    required this.waveMovement,
    required this.pencilInvertedAngle,
    required this.pencilInvertedMovement,
  });
  final Offset pencilMovement;
  final double pencilAngle;
  final Offset lineMovement;
  final bool showLine;
  final bool showLineWave;
  final Offset cutterMovement;
  final Offset waveMovement;
  final Offset pencilInvertedMovement;
  final double pencilInvertedAngle;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    drawPencil(Offset pencilOffset) {
      // front
      drawPencilFront(Paint paint) {
        canvas.drawPath(
            Path()
              ..moveTo(pencilOffset.dx + w * 0.4, pencilOffset.dy + h * 0.08)
              ..lineTo(pencilOffset.dx + w * 0.34, pencilOffset.dy + h * 0.05)
              ..lineTo(pencilOffset.dx + w * 0.34, pencilOffset.dy + h * 0.02)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy + h * 0.02)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy + h * 0.05)
              ..close(),
            paint);

        canvas.drawPath(
            Path()
              ..moveTo(pencilOffset.dx + w * 0.4, pencilOffset.dy + h * 0.08)
              ..lineTo(pencilOffset.dx + w * 0.41, pencilOffset.dy + h * 0.072)
              ..lineTo(pencilOffset.dx + w * 0.39, pencilOffset.dy + h * 0.072),
            paint);
      }

      drawPencilMid(Paint paint) {
        // mid
        canvas.drawPath(
            Path()
              ..moveTo(pencilOffset.dx + w * 0.34, pencilOffset.dy + h * 0.02)
              ..lineTo(pencilOffset.dx + w * 0.34, pencilOffset.dy - h * 0.12)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy - h * 0.12)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy + h * 0.02)
              ..close(),
            paint);
      }

      drawPencilBack(Paint paint) {
        // back
        canvas.drawPath(
            Path()
              ..moveTo(pencilOffset.dx + w * 0.34, pencilOffset.dy - h * 0.12)
              ..lineTo(pencilOffset.dx + w * 0.34, pencilOffset.dy - h * 0.16)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy - h * 0.16)
              ..lineTo(pencilOffset.dx + w * 0.46, pencilOffset.dy - h * 0.12)
              ..close(),
            paint);
      }

      drawPencilFront(Paint()..color = pencilFrontColor);
      drawPencilFront(paint);

      drawPencilMid(Paint()..color = pencilMidColor);
      drawPencilMid(paint);

      drawPencilBack(Paint()..color = pencilBackColor);
      drawPencilBack(paint);
    }

    drawPencilInverted(Offset pencilInvertedOffset) {
      drawPencilBack(Paint paint) {
        // back
        canvas.drawPath(
            Path()
              ..moveTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy + h * 0.02)
              ..lineTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy + h * 0.06)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy + h * 0.06)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy + h * 0.02)
              ..close(),
            paint);
      }

      drawPencilMid(Paint paint) {
        // mid
        canvas.drawPath(
            Path()
              ..moveTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy + h * 0.02)
              ..lineTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy - h * 0.12)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy - h * 0.12)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy + h * 0.02)
              ..close(),
            paint);
      }

      drawPencilFront(Paint paint) {
        // front
        canvas.drawPath(
            Path()
              ..moveTo(pencilInvertedOffset.dx - w * 0.4,
                  pencilInvertedOffset.dy - h * 0.18)
              ..lineTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy - h * 0.15)
              ..lineTo(pencilInvertedOffset.dx - w * 0.34,
                  pencilInvertedOffset.dy - h * 0.12)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy - h * 0.12)
              ..lineTo(pencilInvertedOffset.dx - w * 0.46,
                  pencilInvertedOffset.dy - h * 0.15)
              ..close(),
            paint);

        canvas.drawPath(
            Path()
              ..moveTo(pencilInvertedOffset.dx - w * 0.4,
                  pencilInvertedOffset.dy - h * 0.18)
              ..lineTo(pencilInvertedOffset.dx - w * 0.41,
                  pencilInvertedOffset.dy - h * 0.172)
              ..lineTo(pencilInvertedOffset.dx - w * 0.39,
                  pencilInvertedOffset.dy - h * 0.172),
            paint);
      }

      drawPencilBack(Paint()..color = pencilBackColor);
      drawPencilBack(paint);

      drawPencilMid(Paint()..color = pencilMidColor);
      drawPencilMid(paint);

      drawPencilFront(Paint()..color = pencilFrontColor);
      drawPencilFront(paint);
    }

    drawCutter(Offset cutterOffset) {
      paintCutter(Paint paint) {
        canvas.drawPath(
            Path()
              ..moveTo(cutterOffset.dx - w * 0.075, cutterOffset.dy)
              ..lineTo(cutterOffset.dx - w * 0.075, cutterOffset.dy - h * 0.03)
              ..quadraticBezierTo(
                  cutterOffset.dx - w * 0.03,
                  cutterOffset.dy - h * 0.055,
                  cutterOffset.dx - w * 0.075,
                  cutterOffset.dy - h * 0.08)
              ..lineTo(cutterOffset.dx - w * 0.075, cutterOffset.dy - h * 0.11)
              ..lineTo(cutterOffset.dx + w * 0.075, cutterOffset.dy - h * 0.11)
              ..lineTo(cutterOffset.dx + w * 0.075, cutterOffset.dy - h * 0.08)
              ..quadraticBezierTo(
                  cutterOffset.dx + w * 0.03,
                  cutterOffset.dy - h * 0.055,
                  cutterOffset.dx + w * 0.075,
                  cutterOffset.dy - h * 0.03)
              ..lineTo(cutterOffset.dx + w * 0.075, cutterOffset.dy)
              ..close(),
            paint);
      }

      paintCutter(Paint()..color = cutterColor);
      paintCutter(paint);
    }

    rotatePencil(Offset pencilOffset, double angle) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);
      drawPencil(pencilOffset);
      canvas.restore();
    }

    rotatePencilInverted(Offset pencilOffset, double angle) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);
      drawPencilInverted(pencilOffset);
      canvas.restore();
    }

    if (showLine) {
      // line
      canvas.drawLine(
          Offset(offset.dx - w * 0.25, offset.dy + h * 0.1),
          Offset(
              offset.dx + w * lineMovement.dx, offset.dy + h * lineMovement.dy),
          paint);
    }

    if (showLineWave) {
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx - w * 0.25, offset.dy + h * 0.1)
            ..quadraticBezierTo(
                offset.dx + w * waveMovement.dx,
                offset.dy + h * waveMovement.dy, //0.13 -> 0.07
                offset.dx + w * 0.25,
                offset.dy + h * 0.1),
          paint);
    }

    // pencil
    Offset pencilOffset = Offset(
        offset.dx + w * pencilMovement.dx, offset.dy + h * pencilMovement.dy);
    rotatePencil(pencilOffset, pencilAngle);

    // pencil inverted
    Offset pencilInvertedOffset = Offset(
        offset.dx + w * pencilInvertedMovement.dx,
        offset.dy + h * pencilInvertedMovement.dy);
    rotatePencilInverted(pencilInvertedOffset, pencilInvertedAngle);

    // cutter
    Offset cutterOffset = Offset(
        offset.dx + w * cutterMovement.dx, offset.dy + h * cutterMovement.dy);
    drawCutter(cutterOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
