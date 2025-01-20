import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tech_task_clario/auth/presentation/auth.page.dart';
import 'package:tech_task_clario/core/constants/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: AuthPage(),
      ),
    ),
  );
}
