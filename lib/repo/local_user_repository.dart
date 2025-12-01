import 'package:hive/hive.dart';
import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_user_repository.dart';

class LocalUserRepository implements IUserRepository {
  final Box<User> _userBox = Hive.box('users');

  @override
  Future<User?> getUser(String email) async {
    return _userBox.get(email);
  }

  @override
  Future<void> updateUser(User user) async {
    // 'put' оновить запис, якщо він існує, або створить новий.
    await _userBox.put(user.email, user);
  }

  @override
  Future<void> deleteUser(String email) async {
    await _userBox.delete(email);
  }
}