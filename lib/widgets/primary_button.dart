import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity, // Адаптивність - кнопка на всю ширину
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text.toUpperCase()),
        ),
      ),
    );
  }
}