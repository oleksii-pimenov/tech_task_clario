import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_task_clario/features/auth/application/states/validation_state.dart';
import 'package:tech_task_clario/features/auth/domain/usecases/validate_email.dart';
import 'package:tech_task_clario/features/auth/domain/usecases/validate_password.dart';

part 'validation_provider.g.dart';

@riverpod
class Validation extends _$Validation {
  late final _validateEmail = ValidateEmail();
  late final _validatePassword = ValidatePassword();

  @override
  ValidationState build() => const ValidationState();

  void validateEmail(String email) {
    final emailError = _validateEmail(email);
    state = state.copyWith(
      isEmailValid: emailError == null,
      emailError: emailError,
    );
  }

  void validatePassword(String password) {
    final validationResult = _validatePassword(password);
    state = state.copyWith(
      isPasswordValid: validationResult.isValid,
      passwordValidation: validationResult,
    );
  }

  void setSubmitted() {
    state = state.copyWith(hasBeenSubmitted: true);
  }

  void reset() {
    state = const ValidationState();
  }
}
