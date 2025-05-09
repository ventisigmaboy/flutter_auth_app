import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? buttonColor;
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.textColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: MediaQuery.of(context).size.width,
      onPressed: onPressed,
      color: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}