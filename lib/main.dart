import 'package:flutter/material.dart';
import 'package:mandalaapp/features/home/screens/mandala_home_screen.dart';
import 'screens/education/education_content_screen.dart';
import 'widgets/home/coordinate_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Child Mandala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1CA7EC), // UNICEF Blue
        ),
        useMaterial3: true,
      ),
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
