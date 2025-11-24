import 'package:flutter/material.dart';
import 'package:mandalaapp/features/home/screens/mandala_home_screen.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'screens/education/education_content_screen.dart';
import 'widgets/home/coordinate_helper.dart';

void main() {
  // Print configuration on app startup (debug mode only)
  AppConfig.printConfig();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MandalaHomeScreen(),
      routes: {
        '/education/survival': (context) =>
            EducationContentScreen.survival(),
        '/education/non-discrimination': (context) =>
            EducationContentScreen.nonDiscrimination(),
        '/education/best-interest': (context) =>
            EducationContentScreen.bestInterest(),
        '/education/respect-views': (context) =>
            EducationContentScreen.respectViews(),
        '/coordinate-helper': (context) => const CoordinateHelper(),
      },
    );
  }
}
