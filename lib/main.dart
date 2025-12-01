import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_auth_repository.dart';
import 'package:mobiledevelopment2025/repo/i_user_repository.dart';
import 'package:mobiledevelopment2025/repo/local_auth_repository.dart';
import 'package:mobiledevelopment2025/repo/local_user_repository.dart';
import 'package:mobiledevelopment2025/services/auth_service.dart';
import 'package:mobiledevelopment2025/services/i_session_service.dart';
import 'package:mobiledevelopment2025/services/local_session_service.dart';
import 'package:mobiledevelopment2025/services/user_service.dart';

import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Рівень Даних
    final IAuthRepository authRepository = LocalAuthRepository();
    final IUserRepository userRepository = LocalUserRepository();
    final ISessionService sessionService = LocalSessionService();

    // Рівень Бізнес-Логіки
    final authService = AuthService(
      authRepository,
      sessionService,
    );
    final userService = UserService(
      userRepository,
      sessionService,
    );
    // === Кінець ініціалізації ===

    return MaterialApp(
      title: 'Auth App Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: _AppInitializer(
        sessionService: sessionService,
        authService: authService,
        userService: userService,
      ),
    );
  }
}

class _AppInitializer extends StatefulWidget {
  final ISessionService sessionService;
  final AuthService authService;
  final UserService userService;

  const _AppInitializer({
    required this.sessionService,
    required this.authService,
    required this.userService,
  });

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  // Використовуємо Future для визначення початкового екрану
  late final Future<String?> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = widget.sessionService.getSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Екран завантаження, поки ми перевіряємо сесію
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isLoggedIn = snapshot.hasData && snapshot.data != null;

        if (isLoggedIn) {
          // Якщо сесія є, одразу кидаємо на Профіль
          return ProfileScreen(
            authService: widget.authService,
            userService: widget.userService,
          );
        } else {
          // Якщо сесії немає, показуємо екран Входу
          return LoginScreen(
            authService: widget.authService,
            userService: widget.userService,
          );
        }
      },
    );
  }
}