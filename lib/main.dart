import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_task_clario/auth/presentation/auth.page.dart';

@riverpod
String helloWorld(Ref ref) {
  return 'Hello world';
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: AuthPage(),
      ),
    ),
  );
}
