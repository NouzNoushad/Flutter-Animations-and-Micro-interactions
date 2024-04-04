import 'package:flutter/material.dart';

const Color backgroundColor = Color.fromRGBO(28, 36, 43, 1);
const Color primaryColor = Color.fromRGBO(69, 239, 120, 1);

class SmoothSquareScreen extends StatefulWidget {
  const SmoothSquareScreen({super.key});

  @override
  State<SmoothSquareScreen> createState() => _SmoothSquareScreenState();
}

class _SmoothSquareScreenState extends State<SmoothSquareScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;
  late AnimationController controller5;

  late Animation<Offset> square1Animation;
  late Animation<Offset> square2Animation;
  late Animation<Offset> square3Animation;
  late Animation<Offset> square4Animation;

  bool isFirstPaint = false;
  bool isSecondPaint = true;
  bool isThirdPaint = true;
  bool isFourthPaint = true;

  double leftX = 0.26;
  double middleX = 0.5;
  double rightX = 0.74;
  double topY = 0.22;
  double middleY = 0.5;
  double bottomY = 0.78;

  int controllerDuration = 1;
  int duration = 0;

  @override
  void initState() {
    duration = 720 + (700 * (controllerDuration - 1));

    controller1 = AnimationController(
        vsync: this, duration: Duration(seconds: controllerDuration));
    controller2 = AnimationController(
        vsync: this, duration: Duration(seconds: controllerDuration));
    controller3 = AnimationController(
        vsync: this, duration: Duration(seconds: controllerDuration));
    controller4 = AnimationController(
        vsync: this, duration: Duration(seconds: controllerDuration));
    controller5 = AnimationController(
        vsync: this, duration: Duration(seconds: controllerDuration));

    setSquare1Animation() {
      square1Animation = TweenSequence([
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(leftX, middleY), end: Offset(leftX, bottomY)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(leftX, bottomY), end: Offset(middleX, bottomY)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(middleX, bottomY), end: Offset(middleX, middleY)),
            weight: 1),
      ]).animate(controller1);
    }

    setSquare1Animation();
    square2Animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(middleX, middleY), end: Offset(middleX, topY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(middleX, topY), end: Offset(rightX, topY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(rightX, topY), end: Offset(rightX, middleY)),
          weight: 1),
    ]).animate(controller2);

    square3Animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(rightX, middleY), end: Offset(rightX, bottomY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(rightX, bottomY), end: Offset(middleX, bottomY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(middleX, bottomY), end: Offset(middleX, middleY)),
          weight: 1),
    ]).animate(controller3);

    resetSquare1Animation() {
      square1Animation = TweenSequence([
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(middleX, middleY), end: Offset(middleX, topY)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(middleX, topY), end: Offset(leftX, topY)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(leftX, topY), end: Offset(leftX, middleY)),
            weight: 1),
      ]).animate(controller4);
    }

    square4Animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(leftX, middleY), end: Offset(leftX, bottomY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(leftX, bottomY), end: Offset(middleX, bottomY)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: Offset(middleX, bottomY), end: Offset(middleX, middleY)),
          weight: 1),
    ]).animate(controller5);

    controller1.addStatusListener((status) {
      setSquare1Animation();
      if (status == AnimationStatus.forward) {
        Future.delayed(Duration(milliseconds: duration), () {
          setState(() {
            isSecondPaint = false;
          });
          controller2.forward();
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          isFirstPaint = true;
        });
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(Duration(milliseconds: duration), () {
          resetSquare1Animation();
          setState(() {
            isThirdPaint = false;
          });
          controller3.forward();
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          isSecondPaint = true;
        });
      }
    });

    controller3.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(Duration(milliseconds: duration), () {
          setState(() {
            isFirstPaint = false;
          });
          controller4.forward();
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          isThirdPaint = true;
        });
      }
    });

    controller4.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(Duration(milliseconds: duration), () {
          setState(() {
            isFourthPaint = false;
          });
          controller5.forward();
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          isFirstPaint = true;
        });
      }
    });

    controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        resetAll();
      }
    });

    super.initState();
  }

  resetAll() {
    controller1.reset();
    controller2.reset();
    controller3.reset();
    controller4.reset();
    controller5.reset();

    isFirstPaint = false;
    isSecondPaint = true;
    isThirdPaint = true;
    isFourthPaint = true;

    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            resetAll();
          },
          label: const Text('animate')),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            controller1,
            controller2,
            controller3,
            controller4,
            controller5
          ]),
          builder: (context, child) {
            return Center(
              child: Container(
                height: size.height * 0.4,
                width: size.width * 0.8,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: SquarePainter(
                      firstMovement: square1Animation.value,
                      secondMovement: square2Animation.value,
                      thirdMovement: square3Animation.value,
                      fourthMovement: square4Animation.value,
                      isFirstPaint: isFirstPaint,
                      isSecondPaint: isSecondPaint,
                      isThirdPaint: isThirdPaint,
                      isFourthPaint: isFourthPaint),
                ),
              ),
            );
          }),
    );
  }
}

class SquarePainter extends CustomPainter {
  SquarePainter(
      {required this.firstMovement,
      required this.secondMovement,
      required this.thirdMovement,
      required this.fourthMovement,
      required this.isFirstPaint,
      required this.isSecondPaint,
      required this.isThirdPaint,
      required this.isFourthPaint});
  final Offset firstMovement;
  final Offset secondMovement;
  final Offset thirdMovement;
  final Offset fourthMovement;
  final bool isFirstPaint;
  final bool isSecondPaint;

  final bool isThirdPaint;
  final bool isFourthPaint;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    Paint fillPaint = Paint()..color = primaryColor;
    double squareLength = w * 0.2;

    // mover
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w * firstMovement.dx, h * firstMovement.dy),
            width: squareLength,
            height: squareLength),
        isFirstPaint ? fillPaint : paint);

    // middle square
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w * secondMovement.dx, h * secondMovement.dy),
            width: squareLength,
            height: squareLength),
        isSecondPaint ? fillPaint : paint);

    // right square
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w * thirdMovement.dx, h * thirdMovement.dy),
            width: squareLength,
            height: squareLength),
        isThirdPaint ? fillPaint : paint);

    // left square
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w * fourthMovement.dx, h * fourthMovement.dy),
            width: squareLength,
            height: squareLength),
        isFourthPaint ? fillPaint : paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
