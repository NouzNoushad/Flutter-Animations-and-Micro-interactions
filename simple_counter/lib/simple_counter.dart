import 'dart:math';

import 'package:flutter/material.dart';

class SimpleCounterAnimation extends StatefulWidget {
  const SimpleCounterAnimation({super.key});

  @override
  State<SimpleCounterAnimation> createState() => _SimpleCounterAnimationState();
}

class _SimpleCounterAnimationState extends State<SimpleCounterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> leftRotation;
  late Animation<double> rightRotation;
  double angle = 0.0;
  bool isLeftRotating = false;
  int count = 0;
  bool hideCounter = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    leftRotation = Tween<double>(begin: pi, end: 0).animate(controller);
    rightRotation = Tween<double>(begin: -pi, end: 0).animate(controller);
    controller.addListener(() {
      angle = isLeftRotating ? leftRotation.value : rightRotation.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 110, 108, 1),
      body: Center(
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.005)
                    ..rotateY(angle),
                  child: Container(
                    height: size.height * 0.1,
                    width: size.width * 0.5,
                    color: Colors.white,
                    child: Row(children: [
                      Expanded(
                          child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    controller.reset();
                                    setState(() {
                                      isLeftRotating = false;
                                      hideCounter = true;
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        count--;
                                        hideCounter = false;
                                      });
                                    });
                                    controller.forward();
                                  },
                                  icon: const Icon(Icons.remove)))),
                      Expanded(
                          flex: 2,
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            child: Center(
                                child: hideCounter
                                    ? const SizedBox.shrink()
                                    : Text(
                                        '$count',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                          )),
                      Expanded(
                          child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    controller.reset();
                                    setState(() {
                                      isLeftRotating = true;
                                      hideCounter = true;
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        count++;
                                        hideCounter = false;
                                      });
                                    });

                                    controller.forward();
                                  },
                                  icon: const Icon(Icons.add))))
                    ]),
                  ),
                );
              })),
    );
  }
}
