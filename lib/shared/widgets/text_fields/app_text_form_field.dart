import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tech_task_clario/shared/theme/app_theme.dart';

class AppTextFormField extends HookWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isValid;
  final bool enabled;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isValid = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBeenValidated = useState(false);

    Color getFillColor() {
      if (!enabled) {
        return AppColors.textField.disabledBackground;
      }
      if (isValid) {
        return AppColors.success.background;
      }
      if (hasBeenValidated.value && validator?.call(controller.text) != null) {
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
      if (hasBeenValidated.value && validator?.call(controller.text) != null) {
        return AppColors.error.font;
      }
      return AppColors.textField.enabledFont;
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
              return validator?.call(value);
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
              errorStyle: TextStyle(
                fontSize: 13.0,
                color: AppColors.error.font,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
