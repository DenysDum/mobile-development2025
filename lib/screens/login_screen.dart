import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/services/auth_service.dart';
import 'package:mobiledevelopment2025/services/user_service.dart';
import 'package:mobiledevelopment2025/screens/registration_screen.dart';
import 'package:mobiledevelopment2025/screens/profile_screen.dart';
import 'package:mobiledevelopment2025/widgets/custom_text_field.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final UserService userService;

  const LoginScreen({
    super.key,
    required this.authService,
    required this.userService,
  });

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

    final error = await widget.authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            authService: widget.authService,
            userService: widget.userService,
          ),
        ),
      );
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
                // === ПОВЕРНУЛИ CustomTextField ===
                CustomTextField(
                  controller: _emailController, // Передаємо контролер
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passwordController, // Передаємо контролер
                  hintText: 'Пароль',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                // ==================================
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
                  onPressed: _isLoading ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(
                          authService: widget.authService,
                        ),
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