import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_auth_repository.dart';
import 'package:mobiledevelopment2025/services/i_session_service.dart';
import 'package:mobiledevelopment2025/util/validation_utils.dart';

class AuthService {
  final IAuthRepository _authRepository;
  final ISessionService _sessionService;

  const AuthService(this._authRepository, this._sessionService);

  Future<String?> login(String email, String password) async {
    final user = await _authRepository.login(email, password);
    if (user != null) {
      await _sessionService.saveSession(user.email);
      return null; // Немає помилки
    } else {
      return 'Неправильний email або пароль';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    String? nameError = ValidationUtils.validateName(name);
    if (nameError != null) return nameError;

    String? emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) return emailError;

    String? passError = ValidationUtils.validatePassword(password);
    if (passError != null) return passError;

    final user = User(name: name, email: email, password: password);
    final success = await _authRepository.register(user);

    if (success) {
      return null; // Немає помилки
    } else {
      return 'Користувач з таким email вже існує';
    }
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
  }
}