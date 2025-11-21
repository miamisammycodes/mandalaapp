import 'package:flutter/material.dart';

/// Represents a clickable section of the Child Mandala
class MandalaSectionData {
  final String id;
  final String title;
  final String route;
  final Color overlayColor;

  const MandalaSectionData({
    required this.id,
    required this.title,
    required this.route,
    required this.overlayColor,
  });

  /// The four main sections of the Child Mandala
  static const List<MandalaSectionData> sections = [
    MandalaSectionData(
      id: 'survival',
      title: 'Survival and Development',
      route: '/education/survival',
      overlayColor: Color(0x4DFF5252), // Semi-transparent red
    ),
    MandalaSectionData(
      id: 'non-discrimination',
      title: 'Non Discrimination',
      route: '/education/non-discrimination',
      overlayColor: Color(0x4DFFEB3B), // Semi-transparent yellow
    ),
    MandalaSectionData(
      id: 'best-interest',
      title: 'Best interest of the child',
      route: '/education/best-interest',
      overlayColor: Color(0x4DFFFFFF), // Semi-transparent white
    ),
    MandalaSectionData(
      id: 'respect-views',
      title: 'Respect Views of the child',
      route: '/education/respect-views',
      overlayColor: Color(0x4D4CAF50), // Semi-transparent green
    ),
  ];

  /// Get section by ID
  static MandalaSectionData getById(String id) {
    return sections.firstWhere((section) => section.id == id);
  }
}
