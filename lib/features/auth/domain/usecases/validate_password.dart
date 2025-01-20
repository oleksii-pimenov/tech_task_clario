// Project imports:
import '../value_objects/password.dart';

class ValidatePassword {
  ValidationResult call(String password) {
    final passwordObject = Password.create(password);

    return ValidationResult(
      isValid: passwordObject != null,
      isMinLengthValid: password.length >= 6,
      isMaxLengthValid: password.length <= 64,
      hasUppercase: password.contains(RegExp(r'[A-Z]')),
      hasDigit: password.contains(RegExp(r'[0-9]')),
      errorMessage: _getErrorMessage(password),
    );
  }

  String? _getErrorMessage(String password) {
    // used as hack to keep form validation working
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password.length > 64) return 'Password must be at most 64 characters';
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }
}

class ValidationResult {
  final bool isValid;
  final bool isMinLengthValid;
  final bool isMaxLengthValid;
  final bool hasUppercase;
  final bool hasDigit;
  final String? errorMessage;

  const ValidationResult({
    required this.isValid,
    required this.isMinLengthValid,
    required this.isMaxLengthValid,
    required this.hasUppercase,
    required this.hasDigit,
    this.errorMessage,
  });
}
