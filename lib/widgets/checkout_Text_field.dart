import 'package:flutter/material.dart';

class CheckoutTextField extends StatelessWidget {
  final String lable;
  final IconData icon;
  const CheckoutTextField({
    super.key,
    required TextEditingController nameController, required this.lable, required this.icon,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(
        fontFamily: "RobotoR",
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[400],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          fontFamily: "PlayfairDisplay",
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
