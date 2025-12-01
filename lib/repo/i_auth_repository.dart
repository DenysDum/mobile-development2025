import 'package:mobiledevelopment2025/models/user_model.dart';

abstract class IAuthRepository {
  Future<User?> login(String email, String password);
  Future<bool> register(User user);
}