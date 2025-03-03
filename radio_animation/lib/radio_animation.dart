import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(238, 245, 253, 1);
const Color primaryColor = Color.fromRGBO(79, 156, 245, 1);

class RadioAnimation extends StatefulWidget {
  const RadioAnimation({super.key});

  @override
  State<RadioAnimation> createState() => _RadioAnimationState();
}

class _RadioAnimationState extends State<RadioAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  late Animation<Offset> _radioOffset;

  initAnimation() {
    _radioOffset =
        Tween(begin: const Offset(1.665, 0.34), end: const Offset(1.665, 1))
            .animate(
                CurvedAnimation(parent: _controller1, curve: Curves.bounceOut));
  }

  lastAnimation() {
    _radioOffset =
        Tween(begin: const Offset(1.665, 1.67), end: const Offset(1.665, 1))
            .animate(
                CurvedAnimation(parent: _controller3, curve: Curves.bounceOut));
  }

  @override
  void initState() {
    super.initState();
    int milliseconds = 800;
    _controller1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: milliseconds));
    _controller2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: milliseconds));
    _controller3 = AnimationController(
        vsync: this, duration: Duration(milliseconds: milliseconds));
    _controller4 = AnimationController(
        vsync: this, duration: Duration(milliseconds: milliseconds));

    initAnimation();

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _radioOffset = Tween(
                begin: const Offset(1.665, 1), end: const Offset(1.665, 1.67))
            .animate(
                CurvedAnimation(parent: _controller2, curve: Curves.bounceOut));
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        lastAnimation();
      }
    });

    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _radioOffset = Tween(
                begin: const Offset(1.665, 1), end: const Offset(1.665, 0.34))
            .animate(
                CurvedAnimation(parent: _controller4, curve: Curves.bounceOut));
      }
    });
  }

  resetControllers() {
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
  }

  resetInitAnimation() {
    resetControllers();
    initAnimation();
  }

  resetLastAnimation() {
    resetControllers();
    lastAnimation();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();

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
          ]),
          builder: (context, child) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(222, 237, 255, 1),
                          offset: Offset(10, 10),
                          blurRadius: 20.0,
                          spreadRadius: 0)
                    ]),
                padding: const EdgeInsets.all(50),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent,
                        child: CustomPaint(
                          painter:
                              RadioPainter(radioOffset: _radioOffset.value),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _buildTexts(),
                                  _buildRadioButtons(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildRadioButtons() => Expanded(
          child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              ClipPath(
                clipper: CircleHoleClipper(),
                child: Container(
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                  child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_radioOffset.value.dy >= 1) {
                      _controller4.forward();
                      Future.delayed(const Duration(seconds: 1), () {
                        resetInitAnimation();
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: primaryColor)),
                  ),
                ),
              ))
            ],
          )),
          Expanded(
              child: Stack(
            children: [
              ClipPath(
                clipper: CircleHoleClipper(),
                child: Container(
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                  child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_radioOffset.value.dy >= 1.67) {
                      _controller3.forward();
                    } else {
                      _controller1.forward();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: primaryColor)),
                  ),
                ),
              ))
            ],
          )),
          Expanded(
              child: Stack(
            children: [
              ClipPath(
                clipper: CircleHoleClipper(),
                child: Container(
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                  child: Center(
                child: GestureDetector(
                  onTap: () {
                    _controller2.forward();
                    Future.delayed(const Duration(seconds: 1), () {
                      resetLastAnimation();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: primaryColor)),
                  ),
                ),
              ))
            ],
          )),
        ],
      ));

  Widget _buildTexts() => Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: const Text(
                "One",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: const Text(
                "Two",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: const Text(
                "Three",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
          ),
        ],
      ));
}

class CircleHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: 20,
      ),
    );
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RadioPainter extends CustomPainter {
  const RadioPainter({
    required this.radioOffset,
  });
  final Offset radioOffset;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);

    canvas.drawCircle(
        Offset(offset.dx * radioOffset.dx, offset.dy * radioOffset.dy),
        13,
        Paint()..color = primaryColor); // 0.34, 1, 1.67
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
