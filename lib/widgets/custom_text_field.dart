import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool obscureText;

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    required this.controller, // Тепер обов'язковий
    this.validator,           // Необов'язковий
    this.keyboardType,        // Необов'язковий
  });

  @override
  Widget build(BuildContext context) {
    // Обгортаємо в Padding, як у вас і було
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        ),
      ),
    );
  }
}