/// String Utility
class StringUtil {
  /// Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate username
  static bool isValidUsername(String username) {
    // Username harus 3-20 karakter, hanya huruf, angka, underscore
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  /// Validate password
  static bool isValidPassword(String password) {
    // Minimal 6 karakter
    return password.length >= 6;
  }

  /// Sanitize username (remove special chars, convert to lowercase)
  static String sanitizeUsername(String username) {
    return username.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
  }

  /// Truncate text
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  /// Check if string is empty or whitespace
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (isEmpty(text)) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}
