import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobiledevelopment2025/widgets/info_card.dart'; // Замініть package_name
import 'package:mobiledevelopment2025/widgets/primary_button.dart';
import 'package:mobiledevelopment2025/widgets/section_header.dart';
import 'package:mobiledevelopment2025/providers/mqtt_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оформлення замовлення')),
      body: SafeArea( child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Перевикористання InfoCard для Адреси
                InfoCard(
                  title: 'Адреса доставки',
                  icon: Icons.location_on_outlined,
                  child: ListTile(
                    title: const Text('вул. Степана Бандери, 28'),
                    subtitle: const Text('Львів, 79013'),
                    trailing: TextButton(
                      child: const Text('Змінити'),
                      onPressed: () {},
                    ),
                  ),
                ),
                // Перевикористання InfoCard для Оплати
                InfoCard(
                  title: 'Метод оплати',
                  icon: Icons.payment_outlined,
                  child: ListTile(
                    title: const Text('Готівкою при отриманні'),
                    leading: const Icon(Icons.money, color: Colors.green),
                    trailing: TextButton(
                      child: const Text('Змінити'),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(title: 'Сума замовлення'),
                _buildSummaryRow('Сума товарів:', '400 грн'),
                _buildSummaryRow('Доставка:', '50 грн'),
                _buildSummaryRow(
                  'Всього до сплати:',
                  '450 грн',
                  isBold: true,
                ),
              ],
            ),
          ),
          // Кнопка внизу екрану
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: 'Підтвердити замовлення',
              onPressed: () async {
                final mqttProvider = Provider.of<MqttProvider>(context, listen: false);

                // 1. Переконуємось, що ми підключені (якщо ні - пробуємо ще раз)
                if (!mqttProvider.isConnected) {
                  await mqttProvider.connect();
                }

                // 2. Підписуємось на конкретне замовлення
                // Для тесту використовуємо ID 101, як в прикладі OrderTrackingScreen
                if (mqttProvider.isConnected) {
                  mqttProvider.subscribeToOrder('101');

                  // 3. Перехід на екран трекінгу
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/tracking',
                      ModalRoute.withName('/home')
                  );
                } else {
                  // Показати помилку користувачу
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Не вдалося підключитися до сервера')),
                  );
                }
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  // Приватний віджет для рядка з сумою
  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}