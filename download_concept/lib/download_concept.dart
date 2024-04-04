import 'dart:math';

import 'package:flutter/material.dart';

class DownloadConceptScreen extends StatefulWidget {
  const DownloadConceptScreen({super.key});

  @override
  State<DownloadConceptScreen> createState() => _DownloadConceptScreenState();
}

class _DownloadConceptScreenState extends State<DownloadConceptScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> movement1;
  late Animation<Offset> movement2;
  late Animation<Offset> movement3;
  late Animation<Offset> movement4;
  late Animation<Offset> movement5;
  late Animation<Offset> movement6;
  late Animation<Offset> movement7;

  late Animation<Offset> iconFallAnimation;
  late Animation<double> iconRotateAnimation;
  late Animation<int> textProgress;
  late Animation<double> linearProgress;

  bool showProgress = false;
  bool showDownload = true;
  bool showCompleted = false;

  initAnimation() {
    movement1 = Tween<Offset>(
            begin: const Offset(0.0, -0.08), end: const Offset(-0.36, 0.08))
        .animate(_controller1);
    movement2 = Tween<Offset>(
            begin: const Offset(-0.22, -0.075), end: const Offset(-0.27, 0.08))
        .animate(_controller1);
    movement3 = Tween<Offset>(
            begin: const Offset(-0.22, 0.075), end: const Offset(-0.18, 0.08))
        .animate(_controller1);
    movement4 = Tween<Offset>(
            begin: const Offset(0.22, 0.075), end: const Offset(0.18, 0.08))
        .animate(_controller1);
    movement5 = Tween<Offset>(
            begin: const Offset(0.22, -0.075), end: const Offset(0.27, 0.08))
        .animate(_controller1);
    movement6 = Tween<Offset>(
            begin: const Offset(0.0, -0.08), end: const Offset(0.36, 0.08))
        .animate(_controller1);

    iconFallAnimation = Tween<Offset>(
            begin: const Offset(0.5, 0.5), end: const Offset(0.5, 0.45))
        .animate(_controller1); // 0.45 - 0.8
    iconRotateAnimation = Tween<double>(begin: 2, end: 1).animate(_controller1);

    movement7 = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.08), end: const Offset(0.0, 0.05)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.05), end: const Offset(0.0, 0.08)),
          weight: 1),
    ]).animate(_controller2);

    textProgress = IntTween(begin: 0, end: 100).animate(_controller3);
    linearProgress =
        Tween<double>(begin: -0.36, end: 0.36).animate(_controller3);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        movement3 = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(-0.18, 0.08),
                  end: const Offset(-0.18, 0.06)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(-0.18, 0.06),
                  end: const Offset(-0.18, 0.08)),
              weight: 1),
        ]).animate(_controller2);
        movement4 = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.18, 0.08),
                  end: const Offset(0.18, 0.06)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.18, 0.06),
                  end: const Offset(0.18, 0.08)),
              weight: 1),
        ]).animate(_controller2);
        iconFallAnimation = Tween<Offset>(
                begin: const Offset(0.5, 0.45), end: const Offset(0.5, 0.7))
            .animate(_controller2);
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showProgress = true;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          iconFallAnimation = TweenSequence([
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: const Offset(0.5, 0.7),
                    end: const Offset(0.45, 0.65)),
                weight: 1),
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: const Offset(0.45, 0.65),
                    end: const Offset(0.5, 0.6)),
                weight: 1),
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: const Offset(0.5, 0.6),
                    end: const Offset(0.55, 0.55)),
                weight: 1),
            TweenSequenceItem(
                tween: Tween<Offset>(
                    begin: const Offset(0.55, 0.55),
                    end: const Offset(0.5, 0.45)),
                weight: 1),
          ]).animate(
              CurvedAnimation(parent: _controller3, curve: Curves.linear));

          _controller3.forward();
        });
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            showDownload = false;
            showCompleted = true;
          });
        });

        // reset all
        Future.delayed(const Duration(milliseconds: 1800), () {
          setState(() {
            showProgress = false;
            showDownload = true;
            showCompleted = false;
          });
          initAnimation();
          _controller1.reset();
          _controller2.reset();
          _controller3.reset();
        });
      }
    });
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
      backgroundColor: const Color.fromRGBO(38, 80, 245, 1),
      body: Stack(
        children: [
          AnimatedBuilder(
              animation:
                  Listenable.merge([_controller1, _controller2, _controller3]),
              builder: (context, child) {
                return CustomPaint(
                  painter: DownloadConceptPainter(
                    movement1: movement1.value,
                    movement2: movement2.value,
                    movement3: movement3.value,
                    movement4: movement4.value,
                    movement5: movement5.value,
                    movement6: movement6.value,
                    movement7: movement7.value,
                    iconFall: iconFallAnimation.value,
                    iconRotate: iconRotateAnimation.value,
                    showProgress: showProgress,
                    textProgress: textProgress.value,
                    linearProgress: linearProgress.value,
                    showCompleted: showCompleted,
                    showDownload: showDownload,
                  ),
                  size: size,
                );
              }),
          Center(
            child: GestureDetector(
              onTap: () {
                _controller1.reset();
                _controller1.forward();
              },
              child: Container(
                height: size.height * 0.3,
                width: size.width * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DownloadConceptPainter extends CustomPainter {
  const DownloadConceptPainter(
      {required this.movement1,
      required this.movement2,
      required this.movement3,
      required this.movement4,
      required this.movement5,
      required this.movement6,
      required this.movement7,
      required this.iconFall,
      required this.iconRotate,
      required this.showProgress,
      required this.textProgress,
      required this.linearProgress,
      required this.showDownload,
      required this.showCompleted});
  final Offset movement1;
  final Offset movement2;
  final Offset movement3;
  final Offset movement4;
  final Offset movement5;
  final Offset movement6;
  final Offset movement7;
  final Offset iconFall;
  final double iconRotate;
  final bool showProgress;
  final int textProgress;
  final double linearProgress;
  final bool showDownload;
  final bool showCompleted;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white;

    rotateDownloadIcon(double angle, Offset iconOffset) {
      drawDownloadIcon() {
        // download icon
        double iconEdge = 0.05;
        double iconCorner = 0.022;
        double iconHeight = 0.03;
        double iconEnd = 0.04;

        canvas.drawPath(
            Path()
              ..moveTo(iconOffset.dx, iconOffset.dy + h * iconEnd)
              ..lineTo(iconOffset.dx - w * iconEdge, iconOffset.dy)
              ..lineTo(iconOffset.dx - w * iconCorner, iconOffset.dy)
              ..lineTo(iconOffset.dx - w * iconCorner,
                  iconOffset.dy - h * iconHeight)
              ..lineTo(iconOffset.dx + w * iconCorner,
                  iconOffset.dy - h * iconHeight)
              ..lineTo(iconOffset.dx + w * iconCorner, iconOffset.dy)
              ..lineTo(iconOffset.dx + w * iconEdge, iconOffset.dy)
              ..close(),
            Paint()..color = Colors.white);

        if (showProgress) {
          // parachute
          canvas.drawPath(
              Path()
                ..moveTo(iconOffset.dx, iconOffset.dy + h * iconEnd)
                ..lineTo(iconOffset.dx, iconOffset.dy + h * 0.07)
                ..lineTo(iconOffset.dx - w * 0.04, iconOffset.dy + h * 0.07)
                ..lineTo(iconOffset.dx, iconOffset.dy + h * iconEnd)
                ..lineTo(iconOffset.dx + w * 0.04, iconOffset.dy + h * 0.07)
                ..lineTo(iconOffset.dx, iconOffset.dy + h * 0.07),
              paint);
          canvas.drawPath(
              Path()
                ..moveTo(iconOffset.dx - w * 0.045, iconOffset.dy + h * 0.07)
                ..cubicTo(
                    iconOffset.dx - w * 0.035,
                    iconOffset.dy + h * 0.1,
                    iconOffset.dx + w * 0.035,
                    iconOffset.dy + h * 0.1,
                    iconOffset.dx + w * 0.045,
                    iconOffset.dy + h * 0.07),
              Paint()..color = Colors.white);
        }
      }

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      canvas.translate(-offset.dx, -offset.dy);
      // icon
      drawDownloadIcon();
      canvas.restore();
    }

    drawText(String text, Offset offset) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // border
    canvas.drawPath(
        Path()
          ..moveTo(offset.dx + w * movement1.dx,
              offset.dy + h * movement1.dy) // (0, -0.08) -> (-0.36, 0.08)
          ..cubicTo(
              offset.dx + w * movement2.dx, // (-0.18, -0.075) -> (-0.27, 0.08)
              offset.dy + h * movement2.dy,
              offset.dx + w * movement3.dx, // (0.18, 0.075) -> (-0.18, 0.08)
              offset.dy + h * movement3.dy,
              offset.dx + w * movement7.dx,
              offset.dy + h * movement7.dy)
          ..cubicTo(
              offset.dx + w * movement4.dx, // (0.18, 0.075) -> (0.18, 0.08)
              offset.dy + h * movement4.dy,
              offset.dx + w * movement5.dx, // (0.18, -0.075) -> (0.27, 0.08)
              offset.dy + h * movement5.dy,
              offset.dx + w * movement6.dx, // (0.0, -0.08) -> (0.36, 0.08)
              offset.dy + h * movement6.dy),
        paint);

    if (showProgress) {
      // progress
      canvas.drawLine(
          Offset(offset.dx + w * -0.36, offset.dy + h * 0.08),
          Offset(offset.dx + w * linearProgress, offset.dy + h * 0.08),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      // text
      drawText(
          '$textProgress%', Offset(offset.dx - w * 0.05, offset.dy + h * 0.2));
    }

    if (showDownload) {
      // icon
      Offset iconOffset = Offset(w * iconFall.dx, h * iconFall.dy);
      rotateDownloadIcon(pi * iconRotate, iconOffset); // 1.08, -1.08
    }

    if (showCompleted) {
      // complete text
      drawText('Complete', Offset(offset.dx - w * 0.1, offset.dy - h * 0.2));
      // drawCompleteIcon
      canvas.drawPath(
          Path()
            ..moveTo(offset.dx - w * 0.04, offset.dy - h * 0.02)
            ..lineTo(offset.dx, offset.dy)
            ..lineTo(offset.dx + w * 0.08, offset.dy - h * 0.05),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
