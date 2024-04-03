import 'package:flutter/material.dart';

class CardAnimation extends StatefulWidget {
  const CardAnimation({super.key});

  @override
  State<CardAnimation> createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> holdAnimation;
  late Animation<double> bottleScaleAnimation;
  late Animation<double> bottleShadowAnimation;
  double elevation = 0.0;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scaleAnimation = Tween<double>(begin: 0, end: 0.07)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    holdAnimation = Tween<double>(begin: -0.2, end: -0.5)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    bottleScaleAnimation = Tween<double>(begin: 1, end: 1.1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    bottleShadowAnimation = Tween<double>(begin: 1, end: 0.8)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 234, 248),
      body: Center(
        child: Container(
          height: size.height * 0.7,
          width: size.width * 0.8,
          color: Colors.transparent,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {
                    if (controller.isCompleted) {
                      controller.reverse();
                      setState(() {
                        elevation = 0.0;
                      });
                    } else {
                      controller.forward();
                      setState(() {
                        elevation = 10.0;
                      });
                    }
                  },
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        color: Colors.white,
                        elevation: elevation,
                        child: SizedBox(
                          height: size.height * 0.55,
                          width: size.width * 0.8,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    color: Colors.white,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'Hogue Cellars',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              color: Colors.black54),
                                        ),
                                        const Text(
                                          '\$29',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          height: size.height *
                                              scaleAnimation.value,
                                          width: size.width * 0.8,
                                          color: Colors.black,
                                          child: Center(
                                            child: Text(
                                              'Add to cart'.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.45),
                      // top: size.height * 0.32,
                      // left: size.width * 0.15,
                      child: AnimatedScale(
                        scale: bottleShadowAnimation.value,
                        duration: const Duration(milliseconds: 100),
                        child: Image.asset(
                          'assets/shadow.png',
                          width: size.width * 0.5,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, holdAnimation.value),
                      // top: size.height * holdAnimation.value,
                      // left: size.width * 0.0,
                      child: AnimatedScale(
                        scale: bottleScaleAnimation.value,
                        duration: const Duration(milliseconds: 100),
                        child: Image.asset(
                          'assets/bottle_image.png',
                          height: size.height * 0.4,
                        ),
                      ),
                    ),
                  ]),
                );
              }),
        ),
      ),
    );
  }
}
