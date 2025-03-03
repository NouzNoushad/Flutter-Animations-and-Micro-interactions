import 'dart:math';

import 'package:flutter/material.dart';

Color backgroundColor = const Color.fromRGBO(253, 134, 134, 1);
Color cardColor = Colors.white;
Color faceColor = const Color.fromRGBO(231, 0, 75, 1);
Color leafColor = const Color.fromRGBO(189, 198, 43, 1);
Color eyebrowColor = const Color.fromRGBO(118, 16, 48, 1);
Color eyeColor = const Color.fromRGBO(43, 41, 41, 1);

class RatingAnimation extends StatefulWidget {
  const RatingAnimation({super.key});

  @override
  State<RatingAnimation> createState() => _RatingAnimationState();
}

class _RatingAnimationState extends State<RatingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  late Animation<Offset> _topEyelidOffset;
  late Animation<Offset> _eyebrowOffset;
  late Animation<Offset> _leafOffset;
  late Animation<Offset> _mouthMovement;
  late Animation<Offset> _mouthOffset1;
  late Animation<Offset> _mouthOffset2;
  late Animation<Offset> _mouthOffset3;
  late Animation<Offset> _mouthOffset4;
  late Animation<Offset> _mouthOffset5;
  late Animation<Offset> _mouthOffset6;
  late Animation<Offset> _mouthOffset7;
  late Animation<Offset> _mouthOffset8;
  late Animation<Offset> _eyebrowRightEndOffset;
  late Animation<Offset> _eyebrowLeftEndOffset;
  late Animation<Offset> _eyeOffset;
  late Animation<Offset> _bottomEyelidOffset;

  bool _showTeeth = false;

  // click actions
  int _rating = 0;

  // initialize animations
  initAnimations() {
    _topEyelidOffset =
        Tween<Offset>(begin: const Offset(0, 32), end: const Offset(0, -35))
            .animate(_controller1);
    _eyebrowOffset =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -20))
            .animate(_controller1);
    _leafOffset =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -10))
            .animate(_controller1);
    _mouthMovement =
        Tween<Offset>(begin: const Offset(0, 60), end: const Offset(0, 50))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0, 0.5)));
    _eyeOffset =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -2))
            .animate(_controller1);

    _mouthOffset1 =
        Tween<Offset>(begin: const Offset(-12, 6), end: const Offset(-16, 6))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset2 =
        Tween<Offset>(begin: const Offset(0, 6), end: const Offset(0, 6))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset3 =
        Tween<Offset>(begin: const Offset(12, 6), end: const Offset(16, 6))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset4 =
        Tween<Offset>(begin: const Offset(12, 13), end: const Offset(16, 13))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset5 =
        Tween<Offset>(begin: const Offset(12, 13), end: const Offset(16, 13))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset6 =
        Tween<Offset>(begin: const Offset(0, 13), end: const Offset(0, 13))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset7 =
        Tween<Offset>(begin: const Offset(-12, 13), end: const Offset(-16, 13))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));
    _mouthOffset8 =
        Tween<Offset>(begin: const Offset(-12, 13), end: const Offset(-16, 13))
            .animate(CurvedAnimation(
                parent: _controller1, curve: const Interval(0.5, 1)));

    _eyebrowRightEndOffset =
        Tween<Offset>(begin: const Offset(60, 20), end: const Offset(60, 17))
            .animate(_controller2);
    _eyebrowLeftEndOffset =
        Tween<Offset>(begin: const Offset(30, 15), end: const Offset(30, 17))
            .animate(_controller2);

    _bottomEyelidOffset =
        Tween<Offset>(begin: const Offset(0, 55), end: const Offset(0, 30))
            .animate(_controller3);
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _controller5 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    initAnimations();

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _showTeeth = true;
        });
        _leafOffset = Tween<Offset>(
                begin: const Offset(0, -10), end: const Offset(0, -15))
            .animate(_controller2);
        _eyeOffset =
            Tween<Offset>(begin: const Offset(0, -2), end: const Offset(0, -4))
                .animate(_controller2);

        _mouthOffset1 = Tween<Offset>(
                begin: const Offset(-16, 6), end: const Offset(-12, 0))
            .animate(_controller2);
        _mouthOffset2 =
            Tween<Offset>(begin: const Offset(0, 6), end: const Offset(0, 3))
                .animate(_controller2);
        _mouthOffset3 =
            Tween<Offset>(begin: const Offset(16, 6), end: const Offset(12, 0))
                .animate(_controller2);
        _mouthOffset4 =
            Tween<Offset>(begin: const Offset(16, 13), end: const Offset(25, 6))
                .animate(_controller2);
        _mouthOffset5 = Tween<Offset>(
                begin: const Offset(16, 13), end: const Offset(15, 15))
            .animate(_controller2);
        _mouthOffset6 =
            Tween<Offset>(begin: const Offset(0, 13), end: const Offset(0, 20))
                .animate(_controller2);
        _mouthOffset7 = Tween<Offset>(
                begin: const Offset(-16, 13), end: const Offset(-15, 15))
            .animate(_controller2);
        _mouthOffset8 = Tween<Offset>(
                begin: const Offset(-16, 13), end: const Offset(-25, 6))
            .animate(_controller2);
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _eyeOffset =
            Tween<Offset>(begin: const Offset(0, -4), end: const Offset(0, -8))
                .animate(_controller3);
        _eyebrowOffset = Tween<Offset>(
                begin: const Offset(0, -20), end: const Offset(0, -28))
            .animate(_controller3);
        _mouthMovement =
            Tween<Offset>(begin: const Offset(0, 50), end: const Offset(0, 40))
                .animate(CurvedAnimation(
                    parent: _controller3, curve: const Interval(0, 0.5)));
        _leafOffset = Tween<Offset>(
                begin: const Offset(0, -15), end: const Offset(0, -20))
            .animate(_controller3);

        _mouthOffset4 =
            Tween<Offset>(begin: const Offset(25, 6), end: const Offset(28, 10))
                .animate(_controller3);
        _mouthOffset5 = Tween<Offset>(
                begin: const Offset(15, 15), end: const Offset(16, 20))
            .animate(_controller3);
        _mouthOffset6 =
            Tween<Offset>(begin: const Offset(0, 20), end: const Offset(0, 25))
                .animate(_controller3);
        _mouthOffset7 = Tween<Offset>(
                begin: const Offset(-15, 15), end: const Offset(-16, 20))
            .animate(_controller3);
        _mouthOffset8 = Tween<Offset>(
                begin: const Offset(-25, 6), end: const Offset(-28, 10))
            .animate(_controller3);
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _leafOffset = Tween<Offset>(
                begin: const Offset(0, -20), end: const Offset(0, -25))
            .animate(_controller4);
        _eyebrowOffset = Tween<Offset>(
                begin: const Offset(0, -28), end: const Offset(0, -33))
            .animate(_controller4);
        _eyeOffset =
            Tween<Offset>(begin: const Offset(0, -8), end: const Offset(0, -12))
                .animate(_controller4);
        _bottomEyelidOffset =
            Tween<Offset>(begin: const Offset(0, 30), end: const Offset(0, 20))
                .animate(_controller4);
        _mouthMovement =
            Tween<Offset>(begin: const Offset(0, 40), end: const Offset(0, 35))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0, 0.5)));

        _mouthOffset1 = Tween<Offset>(
                begin: const Offset(-12, 0), end: const Offset(-12, 0))
            .animate(CurvedAnimation(
                parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset2 =
            Tween<Offset>(begin: const Offset(0, 3), end: const Offset(0, 16))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset3 =
            Tween<Offset>(begin: const Offset(12, 0), end: const Offset(12, 0))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset4 =
            Tween<Offset>(begin: const Offset(28, 10), end: const Offset(15, 4))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset5 =
            Tween<Offset>(begin: const Offset(16, 20), end: const Offset(12, 8))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset6 =
            Tween<Offset>(begin: const Offset(0, 25), end: const Offset(0, 20))
                .animate(CurvedAnimation(
                    parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset7 = Tween<Offset>(
                begin: const Offset(-16, 20), end: const Offset(-12, 8))
            .animate(CurvedAnimation(
                parent: _controller4, curve: const Interval(0.5, 1)));
        _mouthOffset8 = Tween<Offset>(
                begin: const Offset(-28, 10), end: const Offset(-15, 4))
            .animate(CurvedAnimation(
                parent: _controller4, curve: const Interval(0.5, 1)));
      }

      if (status == AnimationStatus.completed) {
        setState(() {
          _showTeeth = false;
        });
      }
    });

    _controller5.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _leafOffset = Tween<Offset>(
                begin: const Offset(0, -25), end: const Offset(0, -35))
            .animate(_controller5);
        _eyebrowOffset = Tween<Offset>(
                begin: const Offset(0, -33), end: const Offset(0, -42))
            .animate(_controller5);
        _eyeOffset = Tween<Offset>(
                begin: const Offset(0, -12), end: const Offset(0, -22))
            .animate(_controller5);
        _bottomEyelidOffset =
            Tween<Offset>(begin: const Offset(0, 20), end: const Offset(0, 5))
                .animate(_controller5);
        _mouthMovement =
            Tween<Offset>(begin: const Offset(0, 35), end: const Offset(0, 15))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0, 0.5)));

        _mouthOffset1 = Tween<Offset>(
                begin: const Offset(-12, 0), end: const Offset(-20, 0))
            .animate(CurvedAnimation(
                parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset2 =
            Tween<Offset>(begin: const Offset(0, 16), end: const Offset(0, 35))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset3 =
            Tween<Offset>(begin: const Offset(12, 0), end: const Offset(20, 0))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset4 =
            Tween<Offset>(begin: const Offset(15, 4), end: const Offset(20, -8))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset5 =
            Tween<Offset>(begin: const Offset(12, 8), end: const Offset(20, 8))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset6 =
            Tween<Offset>(begin: const Offset(0, 20), end: const Offset(0, 40))
                .animate(CurvedAnimation(
                    parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset7 = Tween<Offset>(
                begin: const Offset(-12, 8), end: const Offset(-20, 8))
            .animate(CurvedAnimation(
                parent: _controller5, curve: const Interval(0.5, 1)));
        _mouthOffset8 = Tween<Offset>(
                begin: const Offset(-15, 4), end: const Offset(-20, -8))
            .animate(CurvedAnimation(
                parent: _controller5, curve: const Interval(0.5, 1)));
      }
    });
  }

  // set rating
  void setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  // update star rating
  void _updateStarRating(int index) {
    if (index == 0) {
      resetAllAnimations();
      _controller1.forward();
      setRating(1);
    } else if (index == 1) {
      _controller2.forward();
      setRating(2);
    } else if (index == 2) {
      _controller3.forward();
      setRating(3);
    } else if (index == 3) {
      _controller4.forward();
      setRating(4);
    } else {
      _controller5.forward();
      setRating(5);
    }
    return;
  }

  // reset animations
  resetAllAnimations() {
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
    _controller5.reset();
    setState(() {
      _showTeeth = false;
    });
    initAnimations();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge([
            _controller1,
            _controller2,
            _controller3,
            _controller4,
            _controller5,
          ]),
          builder: (context, child) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cardColor,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.transparent,
                        child: CustomPaint(
                          painter: EmotionPainter(
                            topEyelidOffset: _topEyelidOffset.value,
                            eyebrowOffset: _eyebrowOffset.value,
                            leafMovement: _leafOffset.value,
                            eyebrowRightEndMovement:
                                _eyebrowRightEndOffset.value,
                            eyebrowLeftEndMovement: _eyebrowLeftEndOffset.value,
                            mouthMovement: _mouthMovement.value,
                            mouthOffset1: _mouthOffset1.value,
                            mouthOffset2: _mouthOffset2.value,
                            mouthOffset3: _mouthOffset3.value,
                            mouthOffset4: _mouthOffset4.value,
                            mouthOffset5: _mouthOffset5.value,
                            mouthOffset6: _mouthOffset6.value,
                            mouthOffset7: _mouthOffset7.value,
                            mouthOffset8: _mouthOffset8.value,
                            eyeOffset: _eyeOffset.value,
                            bottomEyelidOffset: _bottomEyelidOffset.value,
                            showTeeth: _showTeeth,
                          ),
                          size: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    _updateStarRating(index);
                                  },
                                  child: Icon(
                                    Icons.star_rounded,
                                    size: 50,
                                    color: index >= _rating
                                        ? Colors.grey.shade200
                                        : Colors.amber,
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 4,
                              );
                            },
                            itemCount: 5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class EmotionPainter extends CustomPainter {
  EmotionPainter({
    required this.topEyelidOffset,
    required this.eyebrowOffset,
    required this.leafMovement,
    required this.eyebrowRightEndMovement,
    required this.eyebrowLeftEndMovement,
    required this.mouthMovement,
    required this.mouthOffset1,
    required this.mouthOffset2,
    required this.mouthOffset3,
    required this.mouthOffset4,
    required this.mouthOffset5,
    required this.mouthOffset6,
    required this.mouthOffset7,
    required this.mouthOffset8,
    required this.eyeOffset,
    required this.bottomEyelidOffset,
    required this.showTeeth,
  });

  final Offset topEyelidOffset;
  final Offset eyebrowOffset;
  final Offset leafMovement;
  final Offset eyebrowRightEndMovement;
  final Offset eyebrowLeftEndMovement;
  final Offset mouthMovement;
  final Offset mouthOffset1;
  final Offset mouthOffset2;
  final Offset mouthOffset3;
  final Offset mouthOffset4;
  final Offset mouthOffset5;
  final Offset mouthOffset6;
  final Offset mouthOffset7;
  final Offset mouthOffset8;
  final Offset eyeOffset;
  final Offset bottomEyelidOffset;

  final bool showTeeth;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);

    Paint eyebrowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = eyebrowColor;

    // emotion face
    canvas.drawCircle(offset, w * 0.32, Paint()..color = faceColor);

    // left eye
    Offset leftEyeOffset =
        Offset(offset.dx + eyeOffset.dx, offset.dy + eyeOffset.dy);
    canvas.drawCircle(Offset(leftEyeOffset.dx - 40, leftEyeOffset.dy + 30),
        w * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(leftEyeOffset.dx - 40, leftEyeOffset.dy + 30),
        w * 0.058, Paint()..color = eyeColor);

    // right eye
    Offset rightEyeOffset =
        Offset(offset.dx + eyeOffset.dx, offset.dy + eyeOffset.dy);
    canvas.drawCircle(Offset(rightEyeOffset.dx + 40, rightEyeOffset.dy + 30),
        w * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(rightEyeOffset.dx + 40, rightEyeOffset.dy + 30),
        w * 0.058, Paint()..color = eyeColor);

    // top left eye lid
    Offset topLeftEyelidOffset =
        Offset(offset.dx + topEyelidOffset.dx, offset.dy + topEyelidOffset.dy);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(topLeftEyelidOffset.dx - 40, topLeftEyelidOffset.dy),
            width: 50,
            height: 50),
        0,
        -pi,
        false,
        Paint()..color = faceColor);

    // top right eye lid
    Offset topRightEyelidOffset =
        Offset(offset.dx + topEyelidOffset.dx, offset.dy + topEyelidOffset.dy);
    canvas.drawArc(
        Rect.fromCenter(
            center:
                Offset(topRightEyelidOffset.dx + 40, topRightEyelidOffset.dy),
            width: 50,
            height: 50),
        0,
        -pi,
        false,
        Paint()..color = faceColor);

    // bottom left eye lid
    Offset bottomLeftEyelidOffset = Offset(
        offset.dx + bottomEyelidOffset.dx, offset.dy + bottomEyelidOffset.dy);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(
                bottomLeftEyelidOffset.dx - 36, bottomLeftEyelidOffset.dy),
            width: 50,
            height: 50),
        0,
        pi,
        false,
        Paint()..color = faceColor);

    // bottom right eye lid
    Offset bottomRightEyelidOffset = Offset(
        offset.dx + bottomEyelidOffset.dx, offset.dy + bottomEyelidOffset.dy);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(
                bottomRightEyelidOffset.dx + 36, bottomRightEyelidOffset.dy),
            width: 50,
            height: 50),
        0,
        pi,
        false,
        Paint()..color = faceColor);

    // left eye brow
    Offset leftEyebrowOffset =
        Offset(offset.dx + eyebrowOffset.dx, offset.dy + eyebrowOffset.dy);
    canvas.drawLine(
        Offset(leftEyebrowOffset.dx - eyebrowRightEndMovement.dx,
            leftEyebrowOffset.dy + eyebrowRightEndMovement.dy),
        Offset(leftEyebrowOffset.dx - eyebrowLeftEndMovement.dx,
            leftEyebrowOffset.dy + eyebrowLeftEndMovement.dy),
        eyebrowPaint);

    // right eye brow
    Offset rightEyebrowOffset =
        Offset(offset.dx + eyebrowOffset.dx, offset.dy + eyebrowOffset.dy);
    canvas.drawLine(
        Offset(rightEyebrowOffset.dx + eyebrowRightEndMovement.dx,
            rightEyebrowOffset.dy + eyebrowRightEndMovement.dy),
        Offset(rightEyebrowOffset.dx + eyebrowLeftEndMovement.dx,
            rightEyebrowOffset.dy + eyebrowLeftEndMovement.dy),
        eyebrowPaint);

    // leaf
    Offset leafOffset =
        Offset(offset.dx + leafMovement.dx, offset.dy + leafMovement.dy);
    canvas.drawPath(
        Path()
          ..moveTo(leafOffset.dx, leafOffset.dy - 60)
          ..quadraticBezierTo(leafOffset.dx - 75, leafOffset.dy - 90,
              leafOffset.dx - 110, leafOffset.dy + 10)
          ..quadraticBezierTo(leafOffset.dx - 20, leafOffset.dy - 10,
              leafOffset.dx, leafOffset.dy - 60),
        Paint()..color = leafColor);

    // mouth
    Offset mouthOffset =
        Offset(offset.dx + mouthMovement.dx, offset.dy + mouthMovement.dy);

    Path mouthPath = Path()
      ..moveTo(
          mouthOffset.dx + mouthOffset1.dx, mouthOffset.dy + mouthOffset1.dy)
      ..quadraticBezierTo(
          mouthOffset.dx + mouthOffset2.dx,
          mouthOffset.dy + mouthOffset2.dy,
          mouthOffset.dx + mouthOffset3.dx,
          mouthOffset.dy + mouthOffset3.dy)
      ..quadraticBezierTo(
          mouthOffset.dx + mouthOffset4.dx,
          mouthOffset.dy + mouthOffset4.dy,
          mouthOffset.dx + mouthOffset5.dx,
          mouthOffset.dy + mouthOffset5.dy)
      ..quadraticBezierTo(
          mouthOffset.dx + mouthOffset6.dx,
          mouthOffset.dy + mouthOffset6.dy,
          mouthOffset.dx + mouthOffset7.dx,
          mouthOffset.dy + mouthOffset7.dy)
      ..quadraticBezierTo(
          mouthOffset.dx + mouthOffset8.dx,
          mouthOffset.dy + mouthOffset8.dy,
          mouthOffset.dx + mouthOffset1.dx,
          mouthOffset.dy + mouthOffset1.dy)
      ..close();

    // cut background
    canvas.clipPath(
      mouthPath,
    );

    // mouth outside
    canvas.drawPath(
        mouthPath,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = eyebrowColor);

    // teeth
    drawTeeth(Offset offset) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: offset, width: 9, height: 10),
              const Radius.circular(3)),
          Paint()..color = Colors.white);
    }

    if (showTeeth) {
      // left teeth
      drawTeeth(Offset(mouthOffset.dx - 7, mouthOffset.dy + 2));
      // right teeth
      drawTeeth(Offset(mouthOffset.dx + 7, mouthOffset.dy + 2));
    }

    // mouth inside
    canvas.drawPath(
        mouthPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = eyebrowColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
