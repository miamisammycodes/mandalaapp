import 'package:flutter/material.dart';

/// Base class for mandala section clippers
/// Uses relative coordinates (0.0 - 1.0) for responsive scaling
abstract class MandalaSectionClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Clipper for the top section (Survival and Development)
/// Creates a trapezoid pointing upward
class TopTrapezoidClipper extends MandalaSectionClipper {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start from top-left of trapezoid
    path.moveTo(w * 0.35, h * 0.05); // Top-left (narrow end)
    path.lineTo(w * 0.65, h * 0.05); // Top-right (narrow end)
    path.lineTo(w * 0.75, h * 0.45); // Bottom-right (wide end)
    path.lineTo(w * 0.25, h * 0.45); // Bottom-left (wide end)
    path.close();

    return path;
  }
}

/// Clipper for the right section (Respect Views of the child)
/// Creates a trapezoid pointing right
class RightTrapezoidClipper extends MandalaSectionClipper {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start from top-right of trapezoid
    path.moveTo(w * 0.95, h * 0.35); // Right-top (narrow end)
    path.lineTo(w * 0.95, h * 0.65); // Right-bottom (narrow end)
    path.lineTo(w * 0.55, h * 0.75); // Left-bottom (wide end)
    path.lineTo(w * 0.55, h * 0.25); // Left-top (wide end)
    path.close();

    return path;
  }
}

/// Clipper for the bottom section (Best interest of the child)
/// Creates a trapezoid pointing downward
class BottomTrapezoidClipper extends MandalaSectionClipper {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start from bottom-left of trapezoid
    path.moveTo(w * 0.35, h * 0.95); // Bottom-left (narrow end)
    path.lineTo(w * 0.65, h * 0.95); // Bottom-right (narrow end)
    path.lineTo(w * 0.75, h * 0.55); // Top-right (wide end)
    path.lineTo(w * 0.25, h * 0.55); // Top-left (wide end)
    path.close();

    return path;
  }
}

/// Clipper for the left section (Non Discrimination)
/// Creates a trapezoid pointing left
class LeftTrapezoidClipper extends MandalaSectionClipper {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start from left-top of trapezoid
    path.moveTo(w * 0.05, h * 0.35); // Left-top (narrow end)
    path.lineTo(w * 0.05, h * 0.65); // Left-bottom (narrow end)
    path.lineTo(w * 0.45, h * 0.75); // Right-bottom (wide end)
    path.lineTo(w * 0.45, h * 0.25); // Right-top (wide end)
    path.close();

    return path;
  }
}
