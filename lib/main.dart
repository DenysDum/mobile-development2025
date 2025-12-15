import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// === Ваші імпорти моделей та сервісів ===
import 'package:mobiledevelopment2025/providers/mqtt_provider.dart';
import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_auth_repository.dart';
import 'package:mobiledevelopment2025/repo/i_user_repository.dart';
import 'package:mobiledevelopment2025/repo/local_auth_repository.dart';
import 'package:mobiledevelopment2025/repo/local_user_repository.dart';
import 'package:mobiledevelopment2025/services/auth_service.dart';
import 'package:mobiledevelopment2025/services/i_session_service.dart';
import 'package:mobiledevelopment2025/services/local_session_service.dart';
import 'package:mobiledevelopment2025/services/user_service.dart';

// === Імпорти екранів піцерії ===
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Ініціалізація Hive (як у вашому коді)
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  // 2. Ініціалізація шару даних та бізнес-логіки
  final IAuthRepository authRepository = LocalAuthRepository();
  final IUserRepository userRepository = LocalUserRepository();
  final ISessionService sessionService = LocalSessionService();

  final authService = AuthService(authRepository, sessionService);
  final userService = UserService(userRepository, sessionService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<UserService>.value(value: userService),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: const PizzaApp(),
    ),
  );
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо сервіси через Provider для передачі в Initializer
    final sessionService = LocalSessionService(); // Або також через Provider, якщо зареєстрували

    return MaterialApp(
      title: 'Pizza Delivery',
      debugShowCheckedModeBanner: false,

      // === Ваша тема оформлення ===
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange, // Для сумісності з вашим кодом
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // === Логіка авто-входу ===
      // Ми не використовуємо initialRoute, ми використовуємо home з логікою
      home: const AppInitializer(),

      // === Маршрути ===
      routes: {
        // '/login': (context) => ... (LoginScreen викликається через AppInitializer)
        '/home': (context) => const HomeScreen(),
        '/menu': (context) => const MenuScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(), // Тут вже можна без аргументів, якщо використовувати Provider всередині
        '/checkout': (context) => const CheckoutScreen(),
        '/tracking': (context) => const OrderTrackingScreen()
      },
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<String?> _sessionFuture;

  // Тут ми можемо створити локальний екземпляр сервісу сесій або отримати з контексту,
  // але оскільки init state синхронний, краще використати той, що був створений в main
  // або створити новий екземпляр (Hive це дозволяє).
  final ISessionService _sessionService = LocalSessionService();

  @override
  void initState() {
    super.initState();
    _sessionFuture = _sessionService.getSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.orange)),
          );
        }

        final bool isLoggedIn = snapshot.hasData && snapshot.data != null;

        if (isLoggedIn) {
          // Якщо є сесія -> йдемо на ГРИВНИЙ екран (HomeScreen)
          return const HomeScreen();
        } else {
          // Якщо немає -> на Логін
          // Важливо: Тепер LoginScreen має брати authService з Provider
          return const LoginScreen();
        }
      },
    );
  }
}