// lib/widgets/status_step.dart
import 'package:flutter/material.dart';

class StatusStep extends StatelessWidget {
  final String title;
  final String time;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  const StatusStep({
    super.key,
    required this.title,
    required this.time,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Кружечок
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isActive || isCompleted ? Colors.orange : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? Colors.orange.shade700 : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            // Лінія вниз (якщо не останній елемент)
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.orange : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Текст
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive || isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              if (isActive)
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              const SizedBox(height: 30), // Відступ для вирівнювання з лінією
            ],
          ),
        ),
      ],
    );
  }
}