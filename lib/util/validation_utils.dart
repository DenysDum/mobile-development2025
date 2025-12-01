class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email не може бути порожнім';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Введіть коректний email';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Ім\'я не повинно містити цифр';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    if (value.length < 6) {
      return 'Пароль має бути > 6 символів';
    }
    return null;
  }
}