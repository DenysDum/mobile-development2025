import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';
import 'package:mobiledevelopment2025/widgets/size_selection_chips.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі Піци')),
        body: SafeArea(child: Column(
        children: [
          Image.network(
            'https://picsum.photos/id/102/600/400',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Маргарита',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Класичний томатний соус, моцарела та свіжий базилік.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // ПЕРЕВИКОРИСТАННЯ ВІДЖЕТА
          const SizeSelectionChips(),
          const Spacer(),
          PrimaryButton(
            text: 'Додати в кошик - 180 грн',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Додано в кошик!')),
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
        ),
    );
  }
}