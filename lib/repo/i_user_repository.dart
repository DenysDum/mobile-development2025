import 'package:mobiledevelopment2025/models/user_model.dart';

abstract class IUserRepository {
  Future<User?> getUser(String email);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String email);
}