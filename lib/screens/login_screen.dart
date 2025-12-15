import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Додаємо Provider
import 'package:mobiledevelopment2025/services/auth_service.dart';
// UserService тут потрібен лише якщо ви плануєте його десь використовувати,
// але для самої логіки логіну він не критичний, хіба що для навігації далі.
import 'package:mobiledevelopment2025/screens/registration_screen.dart';
import 'package:mobiledevelopment2025/widgets/custom_text_field.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  // 2. Прибрали поля та конструктор з параметрами
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 3. Отримуємо доступ до сервісу через Provider
    // listen: false, тому що нам потрібно лише викликати метод, а не слухати зміни
    final authService = Provider.of<AuthService>(context, listen: false);

    final error = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      // Новий код веде на Головну (маршрут '/home' прописаний у main.dart)
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Вхід у PizzaApp',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Пароль',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                  text: 'Увійти',
                  onPressed: _login,
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Навігація без параметрів
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text('Немає акаунту? Зареєструватися'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}