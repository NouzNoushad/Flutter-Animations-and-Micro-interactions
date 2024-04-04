import 'package:flutter/material.dart';

class CardTextField extends StatelessWidget {
  const CardTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      this.focusNode,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.onTap});
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          decorationThickness: 0,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white)));
  }
}
