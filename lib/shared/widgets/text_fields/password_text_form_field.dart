import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tech_task_clario/core/constants/colors.dart';
import 'package:tech_task_clario/features/auth/application/providers/validation_provider.dart';

class PasswordTextFormField extends HookConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  const PasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValidated = useState(false);
    final isPasswordVisible = useState(false);
    final validationState = ref.watch(validationProvider);
    final focusNode = useFocusNode();

    Color getFillColor() {
      if (!enabled) {
        return AppColors.textField.disabledBackground;
      }
      if (!isValidated.value) {
        return AppColors.textField.enabledBackground;
      }
      if (!validationState.isPasswordValid) {
        return AppColors.error.background;
      }
      return AppColors.success.background;
    }

    Color getTextColor() {
      if (!enabled) {
        return AppColors.textField.disabledFont;
      }
      if (!isValidated.value) {
        return AppColors.textField.enabledFont;
      }
      if (!validationState.isPasswordValid) {
        return AppColors.error.font;
      }
      return AppColors.success.font;
    }

    Color getBorderColor({bool isFocused = false}) {
      if (!enabled) {
        return AppColors.textField.disabledBorder;
      }
      if (!isValidated.value) {
        return isFocused
            ? AppColors.textField.focusedBorder
            : AppColors.textField.enabledBorder;
      }
      if (!validationState.isPasswordValid) {
        return AppColors.error.border;
      }
      return AppColors.success.border;
    }

    useEffect(() {
      void listener() {
        if (focusNode.hasFocus) {
          ref.read(validationProvider.notifier).setSubmitted();
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
              ref.read(validationProvider.notifier).validatePassword(value);
            },
            enabled: enabled,
            focusNode: focusNode,
            obscureText: !isPasswordVisible.value,
            validator: (value) {
              isValidated.value = true;
              ref
                  .read(validationProvider.notifier)
                  .validatePassword(value ?? '');
              return validationState.passwordValidation?.errorMessage;
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
                  color: getBorderColor(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: getBorderColor(),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: getBorderColor(isFocused: true),
                  width: isValidated.value && validationState.isPasswordValid
                      ? 2
                      : 1,
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
          if (validationState.hasBeenSubmitted || focusNode.hasFocus)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Password must be at least 6 characters \n',
                      style: TextStyle(
                        color: validationState
                                    .passwordValidation?.isMinLengthValid ??
                                false
                            ? AppColors.green
                            : isValidated.value
                                ? AppColors.error.font
                                : AppColors.textField.enabledFont,
                      ),
                    ),
                    TextSpan(
                      text: 'Password must be at most 64 characters \n',
                      style: TextStyle(
                        color: validationState
                                    .passwordValidation?.isMaxLengthValid ??
                                false
                            ? AppColors.green
                            : isValidated.value
                                ? AppColors.error.font
                                : AppColors.textField.enabledFont,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Password must contain at least 1 uppercase letter \n',
                      style: TextStyle(
                        color:
                            validationState.passwordValidation?.hasUppercase ??
                                    false
                                ? AppColors.green
                                : isValidated.value
                                    ? AppColors.error.font
                                    : AppColors.textField.enabledFont,
                      ),
                    ),
                    TextSpan(
                      text: 'Password must contain at least 1 digit \n',
                      style: TextStyle(
                        color: validationState.passwordValidation?.hasDigit ??
                                false
                            ? AppColors.success.font
                            : isValidated.value
                                ? AppColors.error.font
                                : AppColors.textField.enabledFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
