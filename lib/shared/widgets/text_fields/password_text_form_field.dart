// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:tech_task_clario/core/constants/colors.dart';
import 'package:tech_task_clario/features/auth/application/providers/validation_provider.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/password_requirements_list.dart';

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
              return null;
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
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: getTextColor(),
                ),
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
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
            ),
          ),
          const Gap(20),
          if (validationState.hasBeenSubmitted ||
              focusNode.hasFocus ||
              isValidated.value)
            PasswordRequirementsList(
              validation: validationState.passwordValidation,
              isValidated: isValidated.value,
            ),
        ],
      ),
    );
  }
}
