import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tech_task_clario/shared/widgets/buttons/primary_button.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/app_text_form_field.dart';
import 'package:tech_task_clario/shared/widgets/text_fields/password_text_form_field.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final formKey2 = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isEmailValid = useState(false);
    final isPasswordValid = useState(false);

    void validateFields() {
      FocusScope.of(context).unfocus();
      emailController.text = emailController.text.trim();
      isEmailValid.value = formKey.currentState!.validate();
      isPasswordValid.value = formKey2.currentState!.validate();
      if (isEmailValid.value && isPasswordValid.value) {
        showAdaptiveDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text('Success'),
            content: const Text('Sign up successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('OK'),
              ),
            ],
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
                  Color(0xFFF4F9FF),
                  Color(0xFFE0EDFB),
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
                        isValid: isEmailValid.value,
                        validator: validateEmail,
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
                        isValid: isPasswordValid.value,
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
