import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.size,
    required this.buttonText,
    required this.buttonTextColor,
    required this.buttonBgColor,
    this.onTap,
  });
  final Size size;
  final String buttonText;
  final Color buttonBgColor;

  final Color buttonTextColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.height,
        color: buttonBgColor,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: buttonTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
