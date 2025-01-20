import 'package:flutter/material.dart';
import 'package:tech_task_clario/core/constants/colors.dart';
import 'package:tech_task_clario/features/auth/domain/usecases/validate_password.dart';

class PasswordRequirementsList extends StatelessWidget {
  const PasswordRequirementsList({
    super.key,
    required this.validation,
    required this.isValidated,
  });

  final ValidationResult? validation;
  final bool isValidated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text.rich(
        TextSpan(
          children: [
            _buildRequirement(
              'Must be at least 6 characters',
              validation?.isMinLengthValid ?? false,
            ),
            _buildRequirement(
              'Must be at most 64 characters',
              validation?.isMaxLengthValid ?? false,
            ),
            _buildRequirement(
              'Must contain at least 1 uppercase letter',
              validation?.hasUppercase ?? false,
            ),
            _buildRequirement(
              'Must contain at least 1 digit',
              validation?.hasDigit ?? false,
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildRequirement(String text, bool isMet) {
    return TextSpan(
      text: '$text \n',
      style: TextStyle(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: isMet
            ? AppColors.green
            : isValidated
                ? AppColors.error.font
                : AppColors.textField.enabledFont,
      ),
    );
  }
}
