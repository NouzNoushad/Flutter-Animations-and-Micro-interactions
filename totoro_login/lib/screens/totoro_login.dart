import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/check_typing.dart';
import '../widgets/card_button.dart';
import '../widgets/text_field.dart';
import 'totoro_painter.dart';
import '../utils/colors.dart';

class TotoroLoginScreen extends StatefulWidget {
  const TotoroLoginScreen({super.key});

  @override
  State<TotoroLoginScreen> createState() => _TotoroLoginScreenState();
}

class _TotoroLoginScreenState extends State<TotoroLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool isLogin = false;
  bool isTypingPassword = false;
  bool isTypingEmail = false;

  CheckTyping checkTyping = CheckTyping();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: size.height * 1.2,
            width: size.width,
            child: Stack(
              children: [
                CustomPaint(
                  painter: TotoroPainter(
                      isLogin: isLogin,
                      isTypingPassword: isTypingPassword,
                      isTypingEmail: isTypingEmail),
                  size: size,
                ),
                Positioned(
                  top: size.height * 0.47,
                  left: size.width * 0.1,
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.8,
                    child: Column(children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(children: [
                              CardTextField(
                                controller: emailController,
                                hintText: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    isTypingEmail = true;
                                  });
                                  checkTyping.run(() {
                                    setState(() {
                                      isTypingEmail = false;
                                    });
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CardTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (value) {
                                  setState(() {
                                    isTypingEmail = false;
                                    isTypingPassword = true;
                                  });
                                },
                              ),
                            ]),
                          )),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CardButton(
                                    size: size,
                                    buttonText: 'Login',
                                    buttonBgColor: Colors.transparent,
                                    buttonTextColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        isLogin = true;
                                        isTypingPassword = false;
                                        isTypingEmail = false;
                                      });
                                      emailController.text = "";
                                      passwordController.text = "";
                                      Future.delayed(
                                          const Duration(milliseconds: 2000),
                                          () {
                                        setState(() {
                                          isLogin = false;
                                        });
                                      });
                                    },
                                  )),
                                  Expanded(
                                    child: CardButton(
                                      size: size,
                                      buttonText: 'Sign up',
                                      buttonTextColor: Colors.white24,
                                      buttonBgColor: darkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: double.infinity,
            color: backgroundColor,
          ),
        ],
      ),
    );
  }
}


