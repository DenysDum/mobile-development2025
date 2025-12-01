import 'package:mobiledevelopment2025/models/user_model.dart';
import 'package:mobiledevelopment2025/repo/i_user_repository.dart';
import 'package:mobiledevelopment2025/services/i_session_service.dart';

class UserService {
  final IUserRepository _userRepository;
  final ISessionService _sessionService;

  const UserService(this._userRepository, this._sessionService);

  Future<User?> getCurrentUser() async {
    final email = await _sessionService.getSession();
    if (email == null) return null;
    return _userRepository.getUser(email);
  }

  Future<void> updateUser(User user) async {
    await _userRepository.updateUser(user);
  }

  Future<void> deleteCurrentUser() async {
    final email = await _sessionService.getSession();
    if (email != null) {
      await _userRepository.deleteUser(email);
      await _sessionService.clearSession();
    }
  }
}