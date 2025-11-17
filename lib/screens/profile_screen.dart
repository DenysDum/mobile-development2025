import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';
import 'package:mobiledevelopment2025/widgets/profile_list_item.dart'; // Імпорт

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
        body: SafeArea(child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://picsum.photos/id/1005/200/200'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ім\'я Користувача',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ProfileListItem(
            title: 'Мої адреси',
            icon: Icons.location_on_outlined,
            onTap: () {},
          ),
          ProfileListItem(
            title: 'Історія замовлень',
            icon: Icons.history,
            onTap: () {},
          ),
          ProfileListItem(
            title: 'Налаштування',
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: 'Вийти з акаунту',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
        ),
    );
  }
}