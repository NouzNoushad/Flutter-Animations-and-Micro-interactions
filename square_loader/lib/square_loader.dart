import 'dart:math';

import 'package:flutter/material.dart';

class SquareLoaderScreen extends StatefulWidget {
  const SquareLoaderScreen({super.key});

  @override
  State<SquareLoaderScreen> createState() => _SquareLoaderScreenState();
}

class _SquareLoaderScreenState extends State<SquareLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> topRight1Animation;
  late Animation<double> topRight2Animation;

  late AnimationController controller1;
  late Animation<double> bottomRight1Animation;
  late Animation<double> bottomRight2Animation;

  late AnimationController controller2;
  late Animation<double> bottomLeft1Animation;
  late Animation<double> bottomLeft2Animation;

  late AnimationController controller3;
  late Animation<double> topLeft1Animation;
  late Animation<double> topLeft2Animation;

  late AnimationController controllerUnfold;
  late Animation<double> topRightUnfold1Animation;
  late Animation<double> topRightUnfold2Animation;

  late AnimationController controllerUnfold1;
  late Animation<double> bottomRightUnfold1Animation;
  late Animation<double> bottomRightUnfold2Animation;

  late AnimationController controllerUnfold2;
  late Animation<double> bottomLeftUnfold1Animation;
  late Animation<double> bottomLeftUnfold2Animation;

  bool hideTopRightSquare = false;
  bool hideBottomRightSquare = false;
  bool hideBottomLeftSquare = false;
  bool hideTopLeftSquare = false;

  bool visibleTopRight = false;
  bool visibleBottomRight = false;
  bool visibleBottomLeft = false;

  double position = 0.364;
  double squareSize = 80;
  int duration = 300;
  double entry = 0.002;
  Color color = Colors.white;

  @override
  void initState() {
    // top - right animation
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    topRight1Animation = Tween<double>(begin: 0, end: pi / 2).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    topRight2Animation = Tween<double>(begin: pi / 2, end: pi).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // bottom - right animation
    controller1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    bottomRight1Animation = Tween<double>(begin: 0, end: pi / 2).animate(
        CurvedAnimation(
            parent: controller1,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    bottomRight2Animation = Tween<double>(begin: pi / 2, end: pi).animate(
        CurvedAnimation(
            parent: controller1,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // bottom - left animation
    controller2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    bottomLeft1Animation = Tween<double>(begin: 0, end: -pi / 2).animate(
        CurvedAnimation(
            parent: controller2,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    bottomLeft2Animation = Tween<double>(begin: -pi / 2, end: -pi).animate(
        CurvedAnimation(
            parent: controller2,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // top - left animation
    controller3 = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    topLeft1Animation = Tween<double>(begin: 0, end: -pi / 2).animate(
        CurvedAnimation(
            parent: controller3,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    topLeft2Animation = Tween<double>(begin: -pi / 2, end: -pi).animate(
        CurvedAnimation(
            parent: controller3,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // top - right unfold animation
    controllerUnfold = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    topRightUnfold1Animation = Tween<double>(begin: 0, end: pi / 2).animate(
        CurvedAnimation(
            parent: controllerUnfold,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    topRightUnfold2Animation = Tween<double>(begin: pi / 2, end: pi).animate(
        CurvedAnimation(
            parent: controllerUnfold,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // bottom - right unfold animation
    controllerUnfold1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    bottomRightUnfold1Animation = Tween<double>(begin: 0, end: pi / 2).animate(
        CurvedAnimation(
            parent: controllerUnfold1,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    bottomRightUnfold2Animation = Tween<double>(begin: pi / 2, end: pi).animate(
        CurvedAnimation(
            parent: controllerUnfold1,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // bottom - left unfold animation
    controllerUnfold2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
    bottomLeftUnfold1Animation = Tween<double>(begin: 0, end: -pi / 2).animate(
        CurvedAnimation(
            parent: controllerUnfold2,
            curve: const Interval(0.0, 0.5, curve: Curves.linear)));
    bottomLeftUnfold2Animation = Tween<double>(begin: -pi / 2, end: -pi)
        .animate(CurvedAnimation(
            parent: controllerUnfold2,
            curve: const Interval(0.5, 1, curve: Curves.linear)));

    // controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller1.forward();
        setState(() {
          hideTopRightSquare = true;
        });
      }
    });

    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reset();
        controller2.forward();
        setState(() {
          hideBottomRightSquare = true;
        });
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.reset();
        controller3.forward();
        setState(() {
          hideBottomLeftSquare = true;
        });
      }
    });

    controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleTopRight = true;
        });
        controllerUnfold.forward();
      }
    });

    controllerUnfold.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleBottomRight = true;
        });

        controllerUnfold1.forward();
      }
    });

    controllerUnfold1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleBottomLeft = true;
        });

        controllerUnfold2.forward();
      }
    });

    controllerUnfold2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        reset();
      }
    });

    super.initState();
  }

  reset() {
    controller.reset();
    controller1.reset();
    controller2.reset();
    controller3.reset();
    controllerUnfold.reset();
    controllerUnfold1.reset();
    controllerUnfold2.reset();
    hideTopRightSquare = false;
    hideBottomRightSquare = false;
    hideBottomLeftSquare = false;
    hideTopLeftSquare = false;
    visibleTopRight = false;
    visibleBottomRight = false;
    visibleBottomLeft = false;

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controllerUnfold.dispose();
    controllerUnfold1.dispose();
    controllerUnfold2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 163, 151, 1),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            reset();
          },
          label: const Text('animate')),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          color: Colors.transparent,
          child: Transform(
            transform: Matrix4.rotationZ(-pi / 4),
            alignment: Alignment.center,
            child: AnimatedBuilder(
                animation: Listenable.merge([
                  controller,
                  controller1,
                  controller2,
                  controller3,
                  controllerUnfold,
                  controllerUnfold1,
                  controllerUnfold2,
                ]),
                builder: (context, child) {
                  return Stack(children: [
                    // top-right square
                    hideTopRightSquare
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(topRight1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(topRight2Animation.value),
                            alignment: Alignment(position, -position)),
                    // bottom-right square
                    hideBottomRightSquare
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(bottomRight1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(bottomRight2Animation.value),
                            alignment: Alignment(position, position)),
                    // bottom-left square
                    hideBottomLeftSquare
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(bottomLeft1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(bottomLeft2Animation.value),
                            alignment: Alignment(-position, position)),
                    // top-left square
                    hideTopLeftSquare
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(topLeft1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(topLeft2Animation.value),
                            alignment: Alignment(-position, -position)),

                    // top-right square
                    !visibleTopRight
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(topRightUnfold1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(topRightUnfold2Animation.value),
                            alignment: Alignment(position, -position)),
                    // bottom-right square
                    !visibleBottomRight
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(bottomRightUnfold1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateY(bottomRightUnfold2Animation.value),
                            alignment: Alignment(position, position)),
                    // bottom-left square
                    !visibleBottomLeft
                        ? const SizedBox.shrink()
                        : squareContainer(
                            transform1: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(bottomLeftUnfold1Animation.value),
                            transform2: Matrix4.identity()
                              ..setEntry(3, 2, entry)
                              ..rotateX(bottomLeftUnfold2Animation.value),
                            alignment: Alignment(-position, position)),
                  ]);
                }),
          ),
        ),
      ),
    );
  }

  Widget squareContainer(
          {required Matrix4 transform1,
          required Matrix4 transform2,
          required Alignment alignment}) =>
      Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: transform1,
            child: Align(
              alignment: alignment,
              child: Container(
                height: squareSize,
                width: squareSize,
                decoration: BoxDecoration(color: color.withOpacity(0.9)),
              ),
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: transform2,
            child: Align(
              alignment: alignment,
              child: Container(
                height: squareSize,
                width: squareSize,
                decoration: BoxDecoration(color: color.withOpacity(0.9)),
              ),
            ),
          ),
        ],
      );
}
