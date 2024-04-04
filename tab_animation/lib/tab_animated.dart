import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedTabScreen extends StatefulWidget {
  const AnimatedTabScreen({super.key});

  @override
  State<AnimatedTabScreen> createState() => _AnimatedTabScreenState();
}

class _AnimatedTabScreenState extends State<AnimatedTabScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<double>? rotationAnimation;
  Animation<double>? outerRotationAnimation;
  IconData icon = Icons.add;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        rotationAnimation = Tween<double>(begin: pi / 2, end: 0).animate(
            CurvedAnimation(parent: controller, curve: const Interval(0, 1)));
        outerRotationAnimation = TweenSequence([
          TweenSequenceItem(
              tween: Tween<double>(begin: 0, end: -0.05), weight: 1),
          TweenSequenceItem(
              tween: Tween<double>(begin: -0.05, end: 0), weight: 1),
        ]).animate(controller);
      }
      if (status == AnimationStatus.reverse) {
        rotationAnimation = Tween<double>(begin: pi / 2, end: 0).animate(
            CurvedAnimation(parent: controller, curve: const Interval(0, 1)));
        outerRotationAnimation = TweenSequence([
          TweenSequenceItem(
              tween: Tween<double>(begin: 0, end: 0.05), weight: 1),
          TweenSequenceItem(
              tween: Tween<double>(begin: 0.05, end: 0), weight: 1),
        ]).animate(controller);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Center(
              child: GestureDetector(
                child: Transform.rotate(
                  alignment: Alignment.centerLeft,
                  angle: pi * (outerRotationAnimation?.value ?? 0.0),
                  child: ClipRRect(
                    clipper: BorderClipper(),
                    child: Container(
                      height: size.height * 0.095,
                      width: size.width * 0.65,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Transform.rotate(
                        alignment: const Alignment(-0.78, 0.0),
                        angle: rotationAnimation?.value ?? pi / 2,
                        child: Stack(
                          children: [
                            Transform.rotate(
                                alignment: const Alignment(-0.79, 0.0),
                                angle: -pi / 2,
                                child: addMessage(size: size)),
                            addItems(
                                size: size,
                                onTap: () {
                                  if (controller.isCompleted) {
                                    controller.reverse();
                                    setState(() {
                                      icon = Icons.add;
                                    });
                                  } else {
                                    controller.reset();
                                    controller.forward();
                                    setState(() {
                                      icon = Icons.close;
                                    });
                                  }
                                },
                                icon: icon),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget addMessage({required Size size}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
          ),
          Container(
            height: size.height * 0.2,
            width: size.width * 0.425,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.deepPurple.shade200,
            ),
            child: const Center(
                child: Text(
              'Message',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ],
      );

  Widget addItems(
      {required Size size,
      required void Function()? onTap,
      required IconData icon}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.deepPurple.shade200,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
      CircleAvatar(
        radius: 25,
        backgroundColor: Colors.deepPurple.shade200,
        child: const Icon(
          Icons.videocam_outlined,
          color: Colors.white,
        ),
      ),
      CircleAvatar(
        radius: 25,
        backgroundColor: Colors.deepPurple.shade200,
        child: const Icon(
          Icons.photo_camera_outlined,
          color: Colors.white,
        ),
      ),
      CircleAvatar(
        radius: 25,
        backgroundColor: Colors.deepPurple.shade200,
        child: const Icon(
          Icons.image_outlined,
          color: Colors.white,
        ),
      ),
    ]);
  }
}

class BorderClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    double h = size.height;
    double w = size.width;
    return RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w, height: h),
        const Radius.circular(50));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
