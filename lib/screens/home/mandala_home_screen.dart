import 'package:flutter/material.dart';
import '../../widgets/mandala_image_viewer.dart';

/// Home screen displaying the interactive Child Mandala
class MandalaHomeScreen extends StatelessWidget {
  const MandalaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1CA7EC), // UNICEF Blue
        title: const Text(
          'The Child Mandala',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: Implement drawer/menu
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu to be implemented')),
            );
          },
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Mandala viewer with padding
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: const MandalaImageViewer(),
              ),

              // Optional content below mandala
              const SizedBox(height: 16),

              // Informational text (optional)
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text(
              //     'Tap on any section of the mandala to explore child rights and protection topics',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       color: Colors.grey[600],
              //       fontSize: 14,
              //     ),
              //   ),
              // ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/coordinate-helper');
        },
        icon: const Icon(Icons.straighten),
        label: const Text('Measure'),
        backgroundColor: const Color(0xFF1CA7EC),
        foregroundColor: Colors.white,
      ),
    );
  }
}
