import 'package:flutter/material.dart';
import '../../models/home/mandala_section_data.dart';

/// A clickable section of the mandala with custom shape and tap feedback
class MandalaSection extends StatefulWidget {
  final MandalaSectionData data;
  final CustomClipper<Path> clipper;

  const MandalaSection({
    super.key,
    required this.data,
    required this.clipper,
  });

  @override
  State<MandalaSection> createState() => _MandalaSectionState();
}

class _MandalaSectionState extends State<MandalaSection> {
  void _handleTap() {
    // Debug: Show which section was tapped
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: ${widget.data.title}'),
        duration: const Duration(milliseconds: 800),
      ),
    );

    // Navigate to the section's route
    // TODO: Update to use go_router when routing is configured
    Navigator.pushNamed(context, widget.data.route);
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: widget.clipper,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          // Completely invisible - no visual feedback
          color: Colors.transparent,
        ),
      ),
    );
  }
}
