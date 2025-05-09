import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final bool isVisible;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.isVisible,
    required this.hintText,
    this.suffixIcon,
    this.controller,
    this.onChanged, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isVisible,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade900),
        ),
      ),
    );
  }
}