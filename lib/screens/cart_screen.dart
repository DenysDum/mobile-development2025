import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/cart_item_tile.dart'; // Імпорт
import 'package:mobiledevelopment2025/widgets/primary_button.dart';
import 'package:mobiledevelopment2025/widgets/section_header.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Кошик')),
      body: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: const [
                // ПЕРЕВИКОРИСТАННЯ ВІДЖЕТА
                CartItemTile(
                  title: 'Маргарита',
                  subtitle: 'Розмір: M',
                  price: '180',
                  imageUrl: 'https://picsum.photos/id/102/100/100',
                ),
                CartItemTile(
                  title: 'Пепероні',
                  subtitle: 'Розмір: L',
                  price: '220',
                  imageUrl: 'https://picsum.photos/id/103/100/100',
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Всього до сплати: 400 грн'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: 'Оформити замовлення',
              onPressed: () {
                // ЗМІНЕНО: ведемо на новий екран
                Navigator.pushNamed(context, '/checkout');
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}