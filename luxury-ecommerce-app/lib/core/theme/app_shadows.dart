import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // Subtle (Cards at rest)
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Medium (Cards elevated)
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Strong (Modals, Sheets)
  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Glow (Premium accents)
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x403B82F6), // 25% primary
      blurRadius: 20,
      spreadRadius: -5,
    ),
  ];

  // Dark mode shadows
  static const List<BoxShadow> subtleDark = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mediumDark = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> strongDark = [
    BoxShadow(
      color: Color(0x4D000000), // 30% black
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}
