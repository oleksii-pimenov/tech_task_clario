import 'package:flutter/foundation.dart';
import 'package:tech_task_clario/features/auth/domain/usecases/validate_password.dart';

@immutable
class ValidationState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final String? emailError;
  final ValidationResult? passwordValidation;
  final bool hasBeenSubmitted;

  const ValidationState({
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.emailError,
    this.passwordValidation,
    this.hasBeenSubmitted = false,
  });

  ValidationState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    String? emailError,
    ValidationResult? passwordValidation,
    bool? hasBeenSubmitted,
  }) {
    return ValidationState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      emailError: emailError,
      passwordValidation: passwordValidation,
      hasBeenSubmitted: hasBeenSubmitted ?? this.hasBeenSubmitted,
    );
  }
}
