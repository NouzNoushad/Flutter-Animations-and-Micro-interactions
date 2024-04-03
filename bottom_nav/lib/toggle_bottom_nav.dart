import 'package:flutter/material.dart';

const List<Map<String, dynamic>> icons = [
  {'icon': Icons.home, 'title': 'Home'},
  {'icon': Icons.person, 'title': 'About'},
  {'icon': Icons.menu, 'title': 'Menu'},
  {'icon': Icons.settings, 'title': 'Setting'},
];

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int selectedIndex = -1;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(95, 186, 154, 1),
      body: Center(
        child: Container(
          height: size.height * 0.13,
          width: size.width * 0.9,
          color: Colors.transparent,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height * 0.1,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(size.height * 0.05),
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: icons.map((e) {
                    int index = icons.indexOf(e);
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          controller.reset();
                          controller.forward();
                        },
                        child: Container(
                          height: size.height * 0.13,
                          width: size.width * 0.15,
                          color: Colors.transparent,
                          child: selectedIndex == index
                              ? SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(0, 0.1),
                                          end: const Offset(0, -0.1))
                                      .animate(controller),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            e['icon'],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        e['title'].toString().toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : Align(
                                  alignment: const Alignment(0, 0.5),
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      e['icon'],
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
