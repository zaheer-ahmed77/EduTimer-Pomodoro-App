import 'package:flutter/material.dart';
import 'app_theme.dart';

import 'notification_service.dart';
import 'onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduTimer',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const OnboardingScreen(),
    );
  }
}
