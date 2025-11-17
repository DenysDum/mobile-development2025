import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/menu_item_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Меню Піци')),
        body: SafeArea(child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return MenuItemCard(
            name: 'Піца ${index + 1}',
            price: (180 + index * 10).toString(),
            imageUrl: 'https://picsum.photos/id/1${index}2/300/200',
            onTap: () {
              Navigator.pushNamed(context, '/product');
            },
          );
        },
      ),
        ),
    );
  }
}