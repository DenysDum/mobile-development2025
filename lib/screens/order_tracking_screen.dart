// lib/screens/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobiledevelopment2025/providers/mqtt_provider.dart';
import 'package:mobiledevelopment2025/widgets/info_card.dart';
import 'package:mobiledevelopment2025/widgets/section_header.dart';
import 'package:mobiledevelopment2025/widgets/status_step.dart';
import 'package:mobiledevelopment2025/widgets/primary_button.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  // Допоміжна функція для визначення номеру активного етапу
  int _getStepIndex(String status) {
    // Статуси, які приходять по MQTT
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 0;
      case 'baking':
        return 1;
      case 'delivering':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Отримуємо дані з MQTT провайдера
    final mqttProvider = Provider.of<MqttProvider>(context);
    final currentStatus = mqttProvider.orderStatus;
    final currentIndex = _getStepIndex(currentStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Замовлення #1024'),
        actions: [
          // Індикатор підключення до MQTT
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.circle,
              size: 12,
              color: mqttProvider.isConnected ? Colors.green : Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SectionHeader(title: 'Статус замовлення'),
                  const SizedBox(height: 16),

                  // Блок з кроками
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        StatusStep(
                          title: 'Замовлення підтверджено',
                          time: '10:30',
                          isActive: currentIndex == 0,
                          isCompleted: currentIndex > 0,
                        ),
                        StatusStep(
                          title: 'Готується в печі',
                          time: 'Орієнтовно 15 хв',
                          isActive: currentIndex == 1,
                          isCompleted: currentIndex > 1,
                        ),
                        StatusStep(
                          title: 'Кур\'єр в дорозі',
                          time: 'Буде через 10 хв',
                          isActive: currentIndex == 2,
                          isCompleted: currentIndex > 2,
                        ),
                        StatusStep(
                          title: 'Замовлення доставлено',
                          time: 'Смачного!',
                          isActive: currentIndex == 3,
                          isCompleted: currentIndex > 3,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Інформація про кур'єра (з'являється тільки коли статус delivering)
                  if (currentIndex >= 2) ...[
                    const SectionHeader(title: 'Ваш кур\'єр'),
                    InfoCard(
                      title: 'Олександр М.',
                      icon: Icons.directions_bike,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: const Text('Yamaha Aerox'),
                        subtitle: const Text('AA 1234 AA'),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Деталі доставки
                  const SectionHeader(title: 'Деталі доставки'),
                  InfoCard(
                    title: 'Адреса',
                    icon: Icons.location_on_outlined,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('вул. Степана Бандери, 28'),
                    ),
                  ),
                ],
              ),
            ),

            // Кнопка внизу
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: currentIndex == 3 ? 'Залишити відгук' : 'Повернутися на головну',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
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