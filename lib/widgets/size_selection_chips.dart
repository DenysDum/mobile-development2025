import 'package:flutter/material.dart';

class SizeSelectionChips extends StatelessWidget {
  const SizeSelectionChips({super.key});

  @override
  Widget build(BuildContext context) {
    // В реальному додатку це був би StatefulWidget,
    // але для UI-лаби достатньо StatelessWidget
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('S'),
          selected: false,
          onSelected: (value) {},
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('M'),
          selected: true, // Просто для візуалізації
          selectedColor: Colors.orange.shade100,
          onSelected: (value) {},
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('L'),
          selected: false,
          onSelected: (value) {},
        ),
      ],
    );
  }
}