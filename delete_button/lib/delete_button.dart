import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(224, 226, 241, 1);
const Color primaryColor = Color.fromRGBO(25, 26, 43, 1);

const String delete = 'Delete Post';
const String deleted = 'Deleted';

class DeleteButtonScreen extends StatefulWidget {
  const DeleteButtonScreen({super.key});

  @override
  State<DeleteButtonScreen> createState() => _DeleteButtonScreenState();
}

class _DeleteButtonScreenState extends State<DeleteButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  late Animation<Offset> iconOffset;
  late Animation<double> opacity;

  late Animation<Offset> trashTopOffset;
  late Animation<Offset> trashPaperOffset;

  bool showTrashPaper = false;
  String text = delete;

  initAnimation() {
    iconOffset = Tween<Offset>(
            begin: const Offset(0.15, 0.5), end: const Offset(0.85, 0.5))
        .animate(_controller1);
    opacity = Tween<double>(begin: 1, end: 0.0).animate(
        CurvedAnimation(parent: _controller1, curve: const Interval(0.0, 0.8)));

    trashTopOffset = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0.09, 0.0)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.09, 0.0), end: const Offset(0.0, 0.0)),
          weight: 1),
    ]).animate(
        CurvedAnimation(parent: _controller2, curve: const Interval(0.0, 0.6)));

    trashPaperOffset = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.85, 0.1), end: const Offset(0.85, 0.5)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.85, 0.5), end: const Offset(0.5, 0.5)),
          weight: 1),
    ]).animate(
        CurvedAnimation(parent: _controller2, curve: const Interval(0.0, 1.0)));
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showTrashPaper = true;
        });
        iconOffset = Tween<Offset>(
                begin: const Offset(0.85, 0.5), end: const Offset(0.5, 0.5))
            .animate(CurvedAnimation(
                parent: _controller2, curve: const Interval(0.5, 1.0)));

        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        trashTopOffset = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.0, 0.0), end: const Offset(-0.09, 0.0)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(-0.09, 0.0), end: const Offset(0.0, 0.0)),
              weight: 1),
        ]).animate(CurvedAnimation(
            parent: _controller3, curve: const Interval(0.0, 0.6)));

        trashPaperOffset = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.5, 0.1), end: const Offset(0.5, 0.5)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.5, 0.5), end: const Offset(0.25, 0.5)),
              weight: 1),
        ]).animate(CurvedAnimation(
            parent: _controller3, curve: const Interval(0.0, 1.0)));

        iconOffset = Tween<Offset>(
                begin: const Offset(0.5, 0.5), end: const Offset(0.25, 0.5))
            .animate(CurvedAnimation(
                parent: _controller3, curve: const Interval(0.5, 1.0)));

        _controller3.forward();
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          text = deleted;
        });
        opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _controller4, curve: const Interval(0.0, 0.8)));

        trashTopOffset = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.0, 0.0), end: const Offset(-0.09, 0.0)),
              weight: 1),
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(-0.09, 0.0), end: const Offset(0.0, 0.0)),
              weight: 1),
        ]).animate(CurvedAnimation(
            parent: _controller4, curve: const Interval(0.0, 0.6)));

        trashPaperOffset = TweenSequence([
          TweenSequenceItem(
              tween: Tween<Offset>(
                  begin: const Offset(0.25, 0.1), end: const Offset(0.25, 0.5)),
              weight: 1),
        ]).animate(CurvedAnimation(
            parent: _controller4, curve: const Interval(0.0, 0.5)));

        _controller4.forward();
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          reset();
        });
      }
    });
  }

  reset() {
    setState(() {
      showTrashPaper = false;
      text = delete;
    });
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
    initAnimation();
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
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [_controller1, _controller2, _controller3, _controller4]),
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    height: size.height * 0.1,
                    width: size.width * 0.6,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: DeletePainter(
                          deleteMovement: iconOffset.value,
                          opacity: opacity.value,
                          trashPaper: trashPaperOffset.value,
                          trashTop: trashTopOffset.value,
                          showTrashPaper: showTrashPaper,
                          text: text),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller1.reset();
                    _controller1.forward();
                  },
                  child: Center(
                    child: Container(
                      height: size.height * 0.1,
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

class DeletePainter extends CustomPainter {
  DeletePainter({
    required this.deleteMovement,
    required this.trashTop,
    required this.trashPaper,
    required this.opacity,
    required this.showTrashPaper,
    required this.text,
  });
  final Offset deleteMovement;
  final Offset trashTop;
  final Offset trashPaper;
  final double opacity;
  final bool showTrashPaper;
  final String text;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    drawText(Offset offset) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              letterSpacing: 1,
              fontSize: 23,
              color: Colors.white.withOpacity(opacity),
              fontWeight: FontWeight.w400),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: w, height: h),
            const Radius.circular(15)),
        Paint()..color = primaryColor);

    // trash
    Offset trashOffset = Offset(w * deleteMovement.dx, h * deleteMovement.dy);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromCenter(
                center: Offset(trashOffset.dx, trashOffset.dy + h * 0.05),
                width: w * 0.07,
                height: h * 0.3),
            bottomLeft: const Radius.circular(3),
            bottomRight: const Radius.circular(3)),
        Paint()..color = Colors.white);

    Offset trashTopOffset = Offset(
        trashOffset.dx + w * trashTop.dx, trashOffset.dy + h * trashTop.dy);
    canvas.drawLine(
        Offset(trashTopOffset.dx - w * 0.04, trashTopOffset.dy - h * 0.15),
        Offset(trashTopOffset.dx + w * 0.04, trashTopOffset.dy - h * 0.15),
        paint);
    canvas.drawLine(
        Offset(trashTopOffset.dx - w * 0.02, trashTopOffset.dy - h * 0.17),
        Offset(trashTopOffset.dx + w * 0.02, trashTopOffset.dy - h * 0.17),
        paint);

    drawText(Offset(w * (text == deleted ? 0.4 : 0.3), h * 0.33));

    if (showTrashPaper) {
      // paper trash
      Offset paperOffset = Offset(w * trashPaper.dx, h * trashPaper.dy);
      canvas.drawCircle(paperOffset, w * 0.015, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
