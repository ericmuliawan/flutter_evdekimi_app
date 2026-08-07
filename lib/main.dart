import 'package:flutter/material.dart';

import 'common/di/service_locator.dart';
import 'feature/auth/presentation/pages/login_page.dart';
import 'uikit/token/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const EvdeKimiApp());
}

class EvdeKimiApp extends StatelessWidget {
  const EvdeKimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVDEKimi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
