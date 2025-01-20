// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:tech_task_clario/core/constants/colors.dart';
import 'package:tech_task_clario/shared/widgets/buttons/primary_button.dart';
import 'package:tech_task_clario/shared/widgets/dialogs/success_dialog.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/app_text_form_field.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/password_text_form_field.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final formKey2 = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void validateFields() {
      FocusScope.of(context).unfocus();
      emailController.text = emailController.text.trim();
      final isEmailValid = formKey.currentState!.validate();
      final isPasswordValid = formKey2.currentState!.validate();

      if (isEmailValid && isPasswordValid) {
        showAdaptiveDialog(
          context: context,
          builder: (context) => SuccessDialog(
            title: 'Success',
            content: 'Sign up successful!',
            onDismiss: () {
              // for resetting form
              /*     resetForm(); */
            },
          ),
        );
      }
    }

    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientTop,
                  AppColors.gradientBottom,
                ],
              ),
            ),
            child: SizedBox.expand(),
          ),
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/img/auth_page_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(constraints.maxHeight * 0.2),
                Text('Sign up', style: Theme.of(context).textTheme.titleLarge),
                Gap(40),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                      ),
                    ],
                  ),
                ),
                Gap(20),
                Form(
                  key: formKey2,
                  child: Column(
                    children: [
                      PasswordTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                      ),
                    ],
                  ),
                ),
                Gap(40),
                PrimaryButton(
                  onPressed: validateFields,
                  label: 'Sign up',
                ),
              ])
        ],
      );
    }));
  }
}
