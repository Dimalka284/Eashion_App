import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String lable;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  const AppTextField({
    super.key,
    required this.lable,
    required this.controller,
    required this.isPassword,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: lable,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
