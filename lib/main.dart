// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:tech_task_clario/auth/presentation/auth.page.dart';
import 'package:tech_task_clario/core/constants/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: AuthPage(),
      ),
    ),
  );
}
