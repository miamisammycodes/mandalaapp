import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/home/mandala_section_data.dart';
import 'mandala_section.dart';
import 'mandala_section_clipper.dart';

/// Interactive mandala viewer with clickable sections
class MandalaImageViewer extends StatelessWidget {
  const MandalaImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1, // Square aspect ratio for mandala
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background mandala image
              _buildMandalaImage(),

              // Clickable sections overlay
              ..._buildClickableSections(),
            ],
          ),
        );
      },
    );
  }

  /// Build the mandala background image
  Widget _buildMandalaImage() {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      fit: BoxFit.contain,
      placeholderBuilder: (context) => Container(
        color: Colors.blue[50],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Build all four clickable sections
  List<Widget> _buildClickableSections() {
    final sections = MandalaSectionData.sections;

    return [
      // Top section - Survival and Development
      MandalaSection(
        data: sections[0],
        clipper: TopTrapezoidClipper(),
      ),

      // Left section - Non Discrimination
      MandalaSection(
        data: sections[1],
        clipper: LeftTrapezoidClipper(),
      ),

      // Bottom section - Best Interest
      MandalaSection(
        data: sections[2],
        clipper: BottomTrapezoidClipper(),
      ),

      // Right section - Respect Views
      MandalaSection(
        data: sections[3],
        clipper: RightTrapezoidClipper(),
      ),
    ];
  }
}
