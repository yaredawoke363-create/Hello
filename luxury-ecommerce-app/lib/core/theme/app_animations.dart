import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration emphasis = Duration(milliseconds: 450);

  // Curves
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve accelerate = Curves.easeInCubic;
  static const Curve emphasize = Curves.easeOutBack;
  static const Curve spring = Curves.elasticOut;
  static const Cubic smooth = Cubic(0.4, 0.0, 0.2, 1);
  static const Cubic smoothEmphasize = Cubic(0.2, 0.0, 0, 1);
  static const Cubic smoothDecelerate = Cubic(0.4, 0.0, 1, 1);

  // Spring Configurations
  static const SpringDescription springGentle = SpringDescription(
    mass: 1,
    stiffness: 100,
    damping: 15,
  );

  static const SpringDescription springSnappy = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 25,
  );

  static const SpringDescription springBouncy = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 10,
  );

  // Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = smooth;

  // Stagger durations
  static const Duration staggerFast = Duration(milliseconds: 30);
  static const Duration staggerNormal = Duration(milliseconds: 50);
  static const Duration staggerSlow = Duration(milliseconds: 80);
}
