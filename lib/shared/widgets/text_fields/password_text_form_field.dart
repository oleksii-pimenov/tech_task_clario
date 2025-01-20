import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _errorColor = Color(0xFFFF8080);
const _errorFontColor = _errorColor;
const _errorBackgroundColor = Color(0xFFFDEFEE);
const _focusedBorderColor = Color(0xFF151D51);
const _focusedFontColor = Color.fromRGBO(21, 29, 81, 1);
const _focusedBackgroundColor = Colors.white;
const _enabledBorderColor = Color.fromRGBO(21, 29, 81, 0.2);
const _enabledFontColor = Color.fromRGBO(21, 29, 81, 1);
const _enabledBackgroundColor = Colors.white;
const _disabledBorderColor = Color.fromRGBO(21, 29, 81, 0.2);
const _disabledFontColor = Color.fromRGBO(21, 29, 81, 0.2);
const _disabledBackgroundColor = Color.fromRGBO(21, 29, 81, 0.2);
const _successBorderColor = Color.fromRGBO(39, 178, 116, 1);
const _successFontColor = Color.fromRGBO(39, 178, 116, 1);
const _successBackgroundColor = Color(0xFFEFFBF9);

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
        return _disabledBackgroundColor;
      }
      if (isValid) {
        return _successBackgroundColor;
      }
      if (hasBeenValidated.value && validatePassword(controller.text) != null) {
        return _errorBackgroundColor;
      }
      return _enabledBackgroundColor;
    }

    Color getTextColor() {
      if (!enabled) {
        return _disabledFontColor;
      }
      if (isValid) {
        return _successFontColor;
      }
      if (hasBeenValidated.value && validatePassword(controller.text) != null) {
        return _errorFontColor;
      }
      return _enabledFontColor;
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
                borderSide: const BorderSide(
                  color: _enabledBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid ? _successBorderColor : _enabledBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid ? _successBorderColor : _focusedBorderColor,
                  width: isValid ? 2 : 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _errorColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _disabledBorderColor,
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
                              ? _successFontColor
                              : hasBeenValidated.value
                                  ? _errorFontColor
                                  : _enabledFontColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Password must be at most 64 characters \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isMaxLengthValid
                              ? _successFontColor
                              : hasBeenValidated.value
                                  ? _errorFontColor
                                  : _enabledFontColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Password must contain at least 1 uppercase letter \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isUppercaseValid
                              ? _successFontColor
                              : hasBeenValidated.value
                                  ? _errorFontColor
                                  : _enabledFontColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Password must contain at least 1 digit \n',
                        style: TextStyle(
                          color: passwordValidatorState.value.isDigitValid
                              ? _successFontColor
                              : hasBeenValidated.value
                                  ? _errorFontColor
                                  : _enabledFontColor,
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
