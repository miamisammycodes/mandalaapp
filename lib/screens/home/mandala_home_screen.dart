import 'package:flutter/material.dart';

import '../../widgets/home/mandala_image_viewer.dart';
import '../../widgets/shared/app_scaffold.dart';

/// Home screen displaying the interactive Child Mandala
class MandalaHomeScreen extends StatelessWidget {
  const MandalaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'The Child Mandala App',
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Mandala viewer with padding
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: MandalaImageViewer(),
              ),
              const SizedBox(height: 24),
              // Description text box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE3F2FD), // Very light blue
                        Color(0xFFBBDEFB), // Light blue
                        Color(0xFF90CAF9), // Soft sky blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF64B5F6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF42A5F5).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    'The Child Mandala is a sacred visual guide representing the holistic development of children. Each section symbolizes essential aspects of a child\'s growth physical, emotional, social, cognitive, and spiritual.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: const Color(0xFF1565C0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
