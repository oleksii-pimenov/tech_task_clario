import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tech_task_clario/shared/widgets/buttons/primary_button.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/custom_text_form_field.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Form(
        key: formKey,
        child: Column(
          children: [
            AppTextFormField(
              controller: emailController,
              labelText: 'Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            PrimaryButton(
              onPressed: () {
                formKey.currentState!.validate();
              },
              label: 'Sign up',
            ),
          ],
        ),
      )
    ]));
  }
}
