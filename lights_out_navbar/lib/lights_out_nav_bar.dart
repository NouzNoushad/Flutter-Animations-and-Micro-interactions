import 'package:flutter/material.dart';

class LightsOutNavScreen extends StatefulWidget {
  const LightsOutNavScreen({super.key});

  @override
  State<LightsOutNavScreen> createState() => _LightsOutNavScreenState();
}

class _LightsOutNavScreenState extends State<LightsOutNavScreen> {
  List<IconData> icons = [
    Icons.home_outlined,
    Icons.bookmark_outline,
    Icons.add_circle_outline,
    Icons.person_outline,
    Icons.settings_outlined,
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: size.height * 0.12,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Stack(children: [
            Positioned.fill(
                child: CustomPaint(
              painter: LightPainter(index: selectedIndex),
            )),
            Positioned.fill(
                child: Center(
              child: SizedBox(
                width: size.width,
                // padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    children: icons.map((e) {
                  int index = icons.indexOf(e);
                  return AnimatedContainer(
                    width: size.width * 0.2,
                    color: Colors.transparent,
                    duration: const Duration(milliseconds: 800),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          print(selectedIndex);
                        },
                        icon: Icon(
                          e,
                          size: 32,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.grey,
                        )),
                  );
                }).toList()),
              ),
            )),
          ]),
        ),
      ),
    );
  }
}

class LightPainter extends CustomPainter {
  LightPainter({required this.index});
  final int index;
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Offset offset = Offset(w * (0.1 + 0.2 * index), h * 0.042);
    double lightW = w * 0.145;
    double lightH = h * 0.08;
    double radius = 5;

    Paint glowAreaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(64, 255, 255, 255),
          Color.fromARGB(50, 255, 255, 255),
        ],
        tileMode: TileMode.clamp,
      ).createShader(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.5), width: lightW, height: lightH));

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: lightW, height: lightH),
            Radius.circular(radius)),
        Paint()..color = Colors.white);

    canvas.drawPath(
        Path()
          ..moveTo(offset.dx + lightW * 0.5 - radius, offset.dy + lightH * 0.5)
          ..lineTo(offset.dx + lightW * 0.5 + w * 0.025, offset.dy + h * 0.9)
          ..lineTo(offset.dx - lightW * 0.5 - w * 0.025, offset.dy + h * 0.9)
          ..lineTo(offset.dx - lightW * 0.5 + radius, offset.dy + lightH * 0.5)
          ..close(),
        glowAreaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
