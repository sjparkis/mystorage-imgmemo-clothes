import 'package:flutter/material.dart';
import 'core/router.dart';
import 'core/theme.dart';

class MyStorageApp extends StatelessWidget {
  const MyStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyStorage',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
