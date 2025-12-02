import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    // Navigate to the section's route using push (keeps home in stack for back navigation)
    context.push(widget.data.route);
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
