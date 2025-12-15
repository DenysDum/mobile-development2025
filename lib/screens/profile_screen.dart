// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Додаємо Provider
import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/services/auth_service.dart';
import 'package:mobiledevelopment2025/services/user_service.dart';
import 'package:mobiledevelopment2025/screens/login_screen.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';
import 'package:mobiledevelopment2025/widgets/profile_list_item.dart';

class ProfileScreen extends StatefulWidget {
  // Прибрали параметри
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Отримуємо UserService через Provider
    final userService = context.read<UserService>();
    final user = await userService.getCurrentUser();

    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    // Отримуємо AuthService через Provider
    final authService = context.read<AuthService>();
    await authService.logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentUser == null
            ? const Center(child: Text('Не вдалося завантажити профіль.'))
            : Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://picsum.photos/id/1005/200/200'),
            ),
            const SizedBox(height: 12),
            Text(
              _currentUser!.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _currentUser!.email,
              style: const TextStyle(
                  fontSize: 16, color: Colors.grey),
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
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}