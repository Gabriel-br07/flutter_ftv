import 'package:flutter/material.dart';
import 'package:flutter_ftv/app/router.dart';
import 'package:flutter_ftv/core/theme/app_theme.dart';

/// Root widget: Material 3 app wired to the go_router configuration.
class FtvApp extends StatelessWidget {
  const FtvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pelada de Futevôlei',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // No themeMode: the MaterialApp default (ThemeMode.system) already
      // follows the Android system dark-mode setting.
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
