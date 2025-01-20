import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onDismiss,
  });

  final String title;
  final String content;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            FocusManager.instance.primaryFocus?.unfocus();
            onDismiss();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
