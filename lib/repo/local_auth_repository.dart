import 'package:hive/hive.dart';
import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_auth_repository.dart';

class LocalAuthRepository implements IAuthRepository {
  final Box<User> _userBox = Hive.box('users');

  @override
  Future<User?> login(String email, String password) async {
    final User? user = _userBox.get(email);

    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  @override
  Future<bool> register(User user) async {
    if (_userBox.containsKey(user.email)) {
      // Користувач з таким email вже існує
      return false;
    }
    await _userBox.put(user.email, user);
    return true;
  }
}