import 'package:mobiledevelopment2025/services/i_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionService implements ISessionService {
  static const String _sessionKey = 'current_user_email';

  @override
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  @override
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}