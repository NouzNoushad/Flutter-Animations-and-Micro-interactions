import 'dart:math';

import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(220, 227, 239, 1);
const Color truckContainerColor = Color.fromRGBO(232, 234, 241, 1);
const Color truckDoorColor = Color.fromRGBO(232, 234, 241, 1);
const Color truckMirrorColor = Color.fromRGBO(26, 34, 42, 1);
const Color truckFrontColor = Color.fromRGBO(26, 92, 245, 1);
const Color buttonColor = Color.fromRGBO(25, 32, 44, 1);
const Color boxColor = Color.fromRGBO(216, 184, 123, 1);
const Color boxDividerColor = Color.fromRGBO(181, 152, 94, 1);
const Color truckLightColor = Colors.yellow;

const String completeText = 'Complete Order';
const String placedText = 'Order Placed';

class CompleteOrderScreen extends StatefulWidget {
  const CompleteOrderScreen({super.key});

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  late Animation<double> truckAnimation;
  late Animation<double> boxAnimation;
  late Animation<double> topDoorAnimation;
  late Animation<double> bottomDoorAnimation;
  late Animation<double> roadAnimation;

  String text = completeText;
  bool showBox = true;
  bool showLightBeam = false;
  bool showRoad = false;

  initAnimation() {
    truckAnimation = Tween<double>(begin: 1.1, end: 0.5).animate(_controller1);
    boxAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(_controller1);
    topDoorAnimation = Tween<double>(begin: 90, end: 200).animate(
        CurvedAnimation(parent: _controller1, curve: const Interval(0.4, 1)));
    bottomDoorAnimation = Tween<double>(begin: 270, end: 160).animate(
        CurvedAnimation(parent: _controller1, curve: const Interval(0.7, 1)));

    roadAnimation = Tween<double>(begin: 0.85, end: 0.0).animate(_controller4);
  }

  @override
  void initState() {
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _controller5 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    initAnimation();

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxAnimation =
            Tween<double>(begin: 0.2, end: 0.5).animate(_controller2);
        topDoorAnimation = Tween<double>(begin: 200, end: 90).animate(
            CurvedAnimation(
                parent: _controller2, curve: const Interval(0.7, 1)));
        bottomDoorAnimation = Tween<double>(begin: 160, end: 270).animate(
            CurvedAnimation(
                parent: _controller2, curve: const Interval(0.4, 1)));

        Future.delayed(const Duration(milliseconds: 100), () {
          _controller2.forward();
        });
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showBox = false;
        });
        truckAnimation =
            Tween<double>(begin: 0.5, end: 0.65).animate(_controller3);
        _controller3.forward();
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLightBeam = true;
          showRoad = true;
        });
        truckAnimation =
            Tween<double>(begin: 0.65, end: 0.25).animate(_controller4);

        Future.delayed(const Duration(milliseconds: 200), () {
          _controller4.forward();
        });
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        truckAnimation =
            Tween<double>(begin: 0.25, end: 1.1).animate(_controller5);
        roadAnimation =
            Tween<double>(begin: 0.0, end: -0.5).animate(_controller5);
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller5.forward();
        });
      }
    });

    _controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showRoad = false;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            text = placedText;
          });
        });

        Future.delayed(const Duration(milliseconds: 2500), () {
          setState(() {
            text = completeText;
            showBox = true;
            showLightBeam = false;
            showRoad = false;
          });
          _controller1.reset();
          _controller2.reset();
          _controller3.reset();
          _controller4.reset();
          _controller5.reset();

          initAnimation();
        });
      }
    });

    super.initState();
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge([
            _controller1,
            _controller2,
            _controller3,
            _controller4,
            _controller5
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: TruckPainter(
                      truckMovement: truckAnimation.value,
                      boxMovement: boxAnimation.value,
                      bottomDoorMovement: bottomDoorAnimation.value,
                      topDoorMovement: topDoorAnimation.value,
                      roadMovement: roadAnimation.value,
                      showLightBeam: showLightBeam,
                      showRoad: showRoad,
                      showBox: showBox),
                  size: size,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        text = "";
                      });
                      _controller1.reset();
                      _controller2.reset();
                      _controller1.forward();
                    },
                    child: Container(
                      height: size.height * 0.15,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(size.height * 0.5),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          text == placedText
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.done,
                                    size: 35,
                                    color: Color.fromARGB(255, 1, 189, 7),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class TruckPainter extends CustomPainter {
  TruckPainter(
      {required this.truckMovement,
      required this.bottomDoorMovement,
      required this.topDoorMovement,
      required this.boxMovement,
      required this.roadMovement,
      required this.showLightBeam,
      required this.showRoad,
      required this.showBox});
  final double truckMovement;
  final double boxMovement;
  final double topDoorMovement;
  final double bottomDoorMovement;
  final double roadMovement;
  final bool showLightBeam;
  final bool showRoad;
  final bool showBox;
  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    Offset offset = Offset(w * 0.5, h * 0.5);

    drawTruck(Offset truckOffset) {
      // back container
      canvas.drawPath(
          Path()
            ..moveTo(truckOffset.dx - w * 0.14, truckOffset.dy - h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.14, truckOffset.dy - h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.14, truckOffset.dy + h * 0.05)
            ..lineTo(truckOffset.dx - w * 0.14, truckOffset.dy + h * 0.05)
            ..lineTo(truckOffset.dx - w * 0.14, truckOffset.dy - h * 0.05),
          Paint()..color = truckContainerColor);

      // front
      canvas.drawPath(
          Path()
            ..moveTo(truckOffset.dx + w * 0.15, truckOffset.dy - h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.15, truckOffset.dy + h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.23, truckOffset.dy + h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.26, truckOffset.dy + h * 0.04)
            ..lineTo(truckOffset.dx + w * 0.26, truckOffset.dy - h * 0.04)
            ..lineTo(truckOffset.dx + w * 0.23, truckOffset.dy - h * 0.05)
            ..close(),
          Paint()..color = truckFrontColor);

      // mirror
      canvas.drawPath(
          Path()
            ..moveTo(truckOffset.dx + w * 0.18, truckOffset.dy - h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.18, truckOffset.dy + h * 0.05)
            ..lineTo(truckOffset.dx + w * 0.23, truckOffset.dy + h * 0.03)
            ..lineTo(truckOffset.dx + w * 0.23, truckOffset.dy - h * 0.03)
            ..close(),
          Paint()..color = truckMirrorColor);

      // front light
      // bottom
      canvas.drawLine(
          Offset(truckOffset.dx + w * 0.26, truckOffset.dy + h * 0.04),
          Offset(truckOffset.dx + w * 0.26, truckOffset.dy + h * 0.02),
          Paint()
            ..color = truckLightColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);

      // top
      canvas.drawLine(
          Offset(truckOffset.dx + w * 0.26, truckOffset.dy - h * 0.04),
          Offset(truckOffset.dx + w * 0.26, truckOffset.dy - h * 0.02),
          Paint()
            ..color = truckLightColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);

      if (showLightBeam) {
        // light bean
        // bottom
        canvas.drawPath(
            Path()
              ..moveTo(truckOffset.dx + w * 0.26, truckOffset.dy + h * 0.03)
              ..lineTo(truckOffset.dx + w * 0.4, truckOffset.dy + h * 0.06)
              ..lineTo(truckOffset.dx + w * 0.4, truckOffset.dy + h * 0.0)
              ..close(),
            Paint()..color = const Color.fromARGB(52, 255, 241, 118));

        // top
        canvas.drawPath(
            Path()
              ..moveTo(truckOffset.dx + w * 0.26, truckOffset.dy - h * 0.03)
              ..lineTo(truckOffset.dx + w * 0.4, truckOffset.dy - h * 0.06)
              ..lineTo(truckOffset.dx + w * 0.4, truckOffset.dy - h * 0.0)
              ..close(),
            Paint()..color = const Color.fromARGB(52, 255, 241, 118));
      }
    }

    drawTopDoor(Offset truckOffset) {
      double i = topDoorMovement; // 90 ->  190
      var x = truckOffset.dx - w * 0.14 + w * 0.09 * cos(i * pi / 180);
      var y = truckOffset.dy - h * 0.05 + w * 0.09 * sin(i * pi / 180);
      canvas.drawLine(
          Offset(truckOffset.dx - w * 0.14, truckOffset.dy - h * 0.05),
          Offset(x, y),
          Paint()
            ..color = truckDoorColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);
    }

    drawBottomDoor(Offset truckOffset) {
      double i = bottomDoorMovement; // 270 -> 170
      var x = truckOffset.dx - w * 0.14 + w * 0.09 * cos(i * pi / 180);
      var y = truckOffset.dy + h * 0.05 + w * 0.09 * sin(i * pi / 180);
      canvas.drawLine(
          Offset(truckOffset.dx - w * 0.14, truckOffset.dy + h * 0.05),
          Offset(x, y),
          Paint()
            ..color = truckDoorColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);
    }

    drawBox(Offset boxOffset) {
      // box
      canvas.drawPath(
          Path()
            ..moveTo(boxOffset.dx - w * 0.04, boxOffset.dy - h * 0.025)
            ..lineTo(boxOffset.dx + w * 0.04, boxOffset.dy - h * 0.025)
            ..lineTo(boxOffset.dx + w * 0.04, boxOffset.dy + h * 0.025)
            ..lineTo(boxOffset.dx - w * 0.04, boxOffset.dy + h * 0.025)
            ..lineTo(boxOffset.dx - w * 0.04, boxOffset.dy - h * 0.025),
          Paint()..color = boxColor);
      // mid
      canvas.drawLine(
          Offset(boxOffset.dx + w * 0.04, boxOffset.dy - h * 0.0),
          Offset(boxOffset.dx - w * 0.04, boxOffset.dy - h * 0.0),
          Paint()
            ..color = boxDividerColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }

    drawRoad(Offset roadOffset) {
      for (int i = 0; i <= 20; i++) {
        Offset startOffset4 =
            Offset(roadOffset.dx + w * (i * 0.1), roadOffset.dy);
        Offset endOffset4 =
            Offset(roadOffset.dx + w * (i * 0.1 + 0.04), roadOffset.dy);
        canvas.drawLine(
            startOffset4,
            endOffset4,
            Paint()
              ..style = PaintingStyle.stroke
              ..color = Colors.white
              ..strokeWidth = 5);
      }
    }

    // cut border
    canvas.clipRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: offset, width: w * 0.9, height: h * 0.15),
        Radius.circular(h * 0.5)));

    // border
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: w * 0.9, height: h * 0.15),
            Radius.circular(h * 0.5)),
        Paint()..color = buttonColor);

    if (showRoad) {
      // road
      Offset roadOffset = Offset(w * roadMovement, h * 0.5);
      drawRoad(roadOffset);
    }

    if (showBox) {
      // box
      Offset boxOffset = Offset(w * boxMovement, h * 0.5);
      drawBox(boxOffset);
    }

    // truck
    Offset truckOffset = Offset(w * truckMovement, h * 0.5);
    drawTruck(truckOffset);
    drawTopDoor(truckOffset);
    drawBottomDoor(truckOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
