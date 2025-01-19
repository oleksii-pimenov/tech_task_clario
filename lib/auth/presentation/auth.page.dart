import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Add your email validation logic here
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
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // All fields are valid, proceed with form submission
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )
    ]));
  }
}
