abstract class ISessionService {
  Future<void> saveSession(String email);
  Future<String?> getSession();
  Future<void> clearSession();
}