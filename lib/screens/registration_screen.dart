import 'package:flutter/material.dart';
import 'package:mobiledevelopment2025/widgets/custom_text_field.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomTextField(
                hintText: 'Ваше ім\'я',
                icon: Icons.person_outline,
              ),
              const CustomTextField(
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              const CustomTextField(
                hintText: 'Пароль',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const CustomTextField(
                hintText: 'Підтвердіть пароль',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Зареєструватися',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}