import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/category_chip.dart';
import 'package:mobiledevelopment2025/widgets/pizza_card.dart';
import 'package:mobiledevelopment2025/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PizzaApp'),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined, color: Colors.orange),
            onPressed: () {
              Navigator.pushNamed(context, '/tracking');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
        body: SafeArea(
          child: ListView(
        children: [
          const SectionHeader(title: 'Категорії'),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24.0),
              children: [
                CategoryChip(
                  title: 'Піца',
                  icon: Icons.local_pizza,
                  onTap: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                ),
                CategoryChip(
                  title: 'Напої',
                  icon: Icons.local_drink,
                  onTap: () {},
                ),
                CategoryChip(
                  title: 'Десерти',
                  icon: Icons.cake,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Популярне'),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PizzaCard(
                  name: 'Маргарита',
                  price: '180',
                  imageUrl: 'https://picsum.photos/id/102/300/200',
                  onTap: () {
                    Navigator.pushNamed(context, '/product');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
        ),
    );
  }
}