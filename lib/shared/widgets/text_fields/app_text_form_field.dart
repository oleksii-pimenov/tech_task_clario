// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:tech_task_clario/core/constants/colors.dart';
import 'package:tech_task_clario/features/auth/application/providers/validation_provider.dart';

class AppTextFormField extends HookConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validationState = ref.watch(validationProvider);
    final hasBeenValidated = useState(false);

    Color getFillColor() {
      if (!enabled) {
        return AppColors.textField.disabledBackground;
      }
      if (!hasBeenValidated.value) {
        return AppColors.textField.enabledBackground;
      }
      if (!validationState.isEmailValid) {
        return AppColors.error.background;
      }
      return AppColors.success.background;
    }

    Color getTextColor() {
      if (!enabled) {
        return AppColors.textField.disabledFont;
      }
      if (!hasBeenValidated.value) {
        return AppColors.textField.enabledFont;
      }
      if (!validationState.isEmailValid) {
        return AppColors.error.font;
      }
      return AppColors.success.font;
    }

    Color getBorderColor({bool isFocused = false}) {
      if (!enabled) {
        return AppColors.textField.disabledBorder;
      }
      if (!hasBeenValidated.value) {
        return isFocused
            ? AppColors.textField.focusedBorder
            : AppColors.textField.enabledBorder;
      }
      if (!validationState.isEmailValid) {
        return AppColors.error.border;
      }
      return AppColors.success.border;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 315),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            enabled: enabled,
            validator: (value) {
              hasBeenValidated.value = true;
              ref.read(validationProvider.notifier).validateEmail(value ?? '');
              final error = ref.read(validationProvider).emailError;
              return error;
            },
            style: TextStyle(
              color: getTextColor(),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: getTextColor(),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: getFillColor(),
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
                  width: hasBeenValidated.value && validationState.isEmailValid
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
              errorStyle: TextStyle(
                fontSize: 13.0,
                color: AppColors.error.font,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
