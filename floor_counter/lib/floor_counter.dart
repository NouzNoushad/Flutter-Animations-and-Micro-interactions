import 'package:flutter/material.dart';

class FloorCounterScreen extends StatefulWidget {
  const FloorCounterScreen({super.key});

  @override
  State<FloorCounterScreen> createState() => _FloorCounterScreenState();
}

class _FloorCounterScreenState extends State<FloorCounterScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;

  Animation<double>? counter1Animation;
  Animation<double>? counter2Animation;

  Animation<double>? opacityAnimation;
  Animation<double>? opacityReverseAnimation;

  int counter = 5;
  int subCounter = 5;

  bool disableUpArrow = false;
  bool disableDownArrow = false;

  @override
  void initState() {
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    controller1.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        counter1Animation =
            Tween<double>(begin: -50, end: 0).animate(controller1);
        counter2Animation =
            Tween<double>(begin: 0, end: 50).animate(controller1);

        opacityAnimation = Tween<double>(begin: 0, end: 1).animate(controller1);
        opacityReverseAnimation =
            Tween<double>(begin: 1, end: 0).animate(controller1);
      }
    });

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        counter1Animation =
            Tween<double>(begin: 0, end: -50).animate(controller2);
        counter2Animation =
            Tween<double>(begin: 50, end: 0).animate(controller2);

        opacityAnimation = Tween<double>(begin: 1, end: 0).animate(controller2);
        opacityReverseAnimation =
            Tween<double>(begin: 0, end: 1).animate(controller2);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
          animation: Listenable.merge([controller1, controller2]),
          builder: (context, child) {
            return Center(
              child: Container(
                width: size.width * 0.2,
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.white),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                      bottom: Radius.circular(50),
                    )),
                child: FittedBox(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        disableUpArrow
                            ? const SizedBox(
                                height: 10,
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller1.reset();
                                  controller1.forward();

                                  setState(() {
                                    subCounter = counter + 1;
                                    counter = subCounter;
                                    if (counter >= 9) {
                                      disableUpArrow = true;
                                    }
                                    if (counter <= 9) {
                                      disableDownArrow = false;
                                    }
                                  });
                                },
                                child: const Icon(
                                  Icons.expand_less,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                        Stack(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                  0, counter1Animation?.value ?? 0, 0),
                              child: Text(
                                counter.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.greenAccent.withOpacity(
                                    opacityAnimation?.value ?? 1,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  0, counter2Animation?.value ?? 50, 0),
                              child: Text(
                                subCounter.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.greenAccent.withOpacity(
                                    opacityReverseAnimation?.value ?? 0,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        disableDownArrow
                            ? const SizedBox(
                                height: 10,
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller2.reset();
                                  controller2.forward();

                                  setState(() {
                                    subCounter = counter - 1;
                                    counter = subCounter;
                                    if (counter >= 1) {
                                      disableUpArrow = false;
                                    }
                                    if (counter <= 1) {
                                      disableDownArrow = true;
                                    }
                                  });
                                },
                                child: const Icon(
                                  Icons.expand_more,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                      ]),
                ),
              ),
            );
          }),
    );
  }
}
