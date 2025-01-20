import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tech_task_clario/core/constants/colors.dart';

class PasswordValidatorState {
  final bool isMinLengthValid;
  final bool isMaxLengthValid;
  final bool isUppercaseValid;
  final bool isDigitValid;
  final bool isDirty;

  PasswordValidatorState({
    required this.isMinLengthValid,
    required this.isMaxLengthValid,
    required this.isUppercaseValid,
    required this.isDigitValid,
    this.isDirty = false,
  });

  PasswordValidatorState copyWith({
    bool? isMinLengthValid,
    bool? isMaxLengthValid,
    bool? isUppercaseValid,
    bool? isDigitValid,
    bool? isDirty,
  }) {
    return PasswordValidatorState(
      isMinLengthValid: isMinLengthValid ?? this.isMinLengthValid,
      isMaxLengthValid: isMaxLengthValid ?? this.isMaxLengthValid,
      isUppercaseValid: isUppercaseValid ?? this.isUppercaseValid,
      isDigitValid: isDigitValid ?? this.isDigitValid,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

class PasswordTextFormField extends HookWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isValid;
  final bool enabled;

  const PasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isValid = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBeenValidated = useState(false);
    final isPasswordVisible = useState(false);
    final password = ValueNotifier<String?>(null);
    final passwordValidatorState = useState(PasswordValidatorState(
      isMinLengthValid: false,
      isMaxLengthValid: false,
      isUppercaseValid: false,
      isDigitValid: false,
    ));

    final focusNode = useFocusNode();

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }

      if (value.length > 64) {
        return 'Password must be at most 64 characters';
      } else {}

      if (!value.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain at least one uppercase letter';
      } else {}
      if (!value.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one number';
      } else {}

      return null;
    }

    void customValidator(String? value) {
      if (value == null) {
        return;
      }

      late bool isMinLengthValid;
      late bool isMaxLengthValid;
      late bool isUppercaseValid;
      late bool isDigitValid;

      if (value.length < 6) {
        isMinLengthValid = false;
      } else {
        isMinLengthValid = true;
      }

      if (value.isEmpty || value.length > 64) {
        isMaxLengthValid = false;
      } else {
        isMaxLengthValid = true;
      }

      if (!value.contains(RegExp(r'[A-Z]'))) {
        isUppercaseValid = false;
      } else {
        isUppercaseValid = true;
      }

      if (!value.contains(RegExp(r'[0-9]'))) {
        isDigitValid = false;
      } else {
        isDigitValid = true;
      }

      passwordValidatorState.value = passwordValidatorState.value.copyWith(
        isMinLengthValid: isMinLengthValid,
        isMaxLengthValid: isMaxLengthValid,
        isUppercaseValid: isUppercaseValid,
        isDigitValid: isDigitValid,
      );
    }

    Color getFillColor() {
      if (!enabled) {
        return AppColors.textField.disabledBackground;
      }
      if (isValid) {
        return AppColors.success.background;
      }
      if (hasBeenValidated.value && validatePassword(controller.text) != null) {
        return AppColors.error.background;
      }
      return AppColors.textField.enabledBackground;
    }

    Color getTextColor() {
      if (!enabled) {
        return AppColors.textField.disabledFont;
      }
      if (isValid) {
        return AppColors.success.font;
      }
      if (hasBeenValidated.value && validatePassword(controller.text) != null) {
        return AppColors.error.font;
      }
      return AppColors.textField.enabledFont;
    }

    useEffect(() {
      void listener() {
        if (focusNode.hasFocus) {
          passwordValidatorState.value = passwordValidatorState.value.copyWith(
            isDirty: true,
          );
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 315),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            onChanged: (value) {
              password.value = value;
              customValidator(value);
            },
            enabled: enabled,
            focusNode: focusNode,
            obscureText: !isPasswordVisible.value,
            validator: (value) {
              hasBeenValidated.value = true;
              customValidator(value);
              return validatePassword(value);
            },
            style: TextStyle(
              color: getTextColor(),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: getTextColor(),
              ),
              filled: true,
              fillColor: getFillColor(),
              suffixIcon: IconButton(
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                icon: Icon(isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.textField.enabledBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid
                      ? AppColors.success.border
                      : AppColors.textField.enabledBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid
                      ? AppColors.success.border
                      : AppColors.textField.focusedBorder,
                  width: isValid ? 2 : 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.error.border,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.error.border,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.textField.disabledBorder,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 1.0,
                letterSpacing: 0.0,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          if (password.value != null ||
              passwordValidatorState.value.isDirty ||
              hasBeenValidated.value)
            Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Password must be at least 6 characters \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isMinLengthValid
                              ? AppColors.green
                              : hasBeenValidated.value
                                  ? AppColors.error.font
                                  : AppColors.textField.enabledFont,
                        ),
                      ),
                      TextSpan(
                        text: 'Password must be at most 64 characters \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isMaxLengthValid
                              ? AppColors.green
                              : hasBeenValidated.value
                                  ? AppColors.error.font
                                  : AppColors.textField.enabledFont,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Password must contain at least 1 uppercase letter \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isUppercaseValid
                              ? AppColors.green
                              : hasBeenValidated.value
                                  ? AppColors.error.font
                                  : AppColors.textField.enabledFont,
                        ),
                      ),
                      TextSpan(
                        text: 'Password must contain at least 1 digit \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isDigitValid
                              ? AppColors.success.font
                              : hasBeenValidated.value
                                  ? AppColors.error.font
                                  : AppColors.textField.enabledFont,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
