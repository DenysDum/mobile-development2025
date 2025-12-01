import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/services/auth_service.dart';
import 'package:mobiledevelopment2025/util/validation_utils.dart';
// ЗНОВУ ВИКОРИСТОВУЄМО НАШ ВІДЖЕТ
import 'package:mobiledevelopment2025/widgets/custom_text_field.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';

class RegistrationScreen extends StatefulWidget {
  final AuthService authService;

  const RegistrationScreen({super.key, required this.authService});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _apiError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // ... (вся логіка _register() залишається ТАКОЮ Ж САМОЮ)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final error = await widget.authService.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _apiError = error;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Успішно зареєстровано! Увійдіть.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // === ПОВЕРНУЛИ CustomTextField ===
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Ваше ім\'я',
                    icon: Icons.person_outline,
                    validator: ValidationUtils.validateName,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationUtils.validateEmail,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Пароль',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: ValidationUtils.validatePassword,
                  ),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Підтвердіть пароль',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Паролі не збігаються';
                      }
                      return null;
                    },
                  ),
                  // ==================================
                  if (_apiError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        _apiError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                    text: 'Зареєструватися',
                    onPressed: _register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}