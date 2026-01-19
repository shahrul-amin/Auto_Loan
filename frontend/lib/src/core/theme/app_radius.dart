import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._(); // Private constructor to prevent instantiation

  // ==================== Radius Scale ====================

  /// Extra small radius - Small elements, badges (4px)
  static const double xs = 4.0;

  /// Small radius - Buttons, chips (8px)
  static const double sm = 8.0;

  /// Medium radius - Cards, inputs (12px)
  static const double md = 12.0;

  /// Large radius - Large cards (16px)
  static const double lg = 16.0;

  /// Extra large radius - Bottom sheets (20px)
  static const double xl = 20.0;

  /// Extra extra large radius - Modals, dialogs (24px)
  static const double xxl = 24.0;

  /// Pill radius - Fully rounded pill-shaped buttons (999px)
  static const double pill = 999.0;

  // ==================== BorderRadius Presets ====================

  /// Card border radius - Default for cards (12px all corners)
  static const cardRadius = BorderRadius.all(Radius.circular(md));

  /// Button border radius - Default for buttons (8px all corners)
  static const buttonRadius = BorderRadius.all(Radius.circular(sm));

  /// Input border radius - Default for input fields (12px all corners)
  static const inputRadius = BorderRadius.all(Radius.circular(md));

  /// Badge border radius - For badges and chips (4px all corners)
  static const badgeRadius = BorderRadius.all(Radius.circular(xs));

  /// Large card radius - For prominent cards (16px all corners)
  static const largeCardRadius = BorderRadius.all(Radius.circular(lg));

  /// Sheet radius - For bottom sheets (20px top corners only)
  static const sheetRadius = BorderRadius.vertical(
    top: Radius.circular(xl),
  );

  /// Dialog radius - For dialogs and modals (24px all corners)
  static const dialogRadius = BorderRadius.all(Radius.circular(xxl));

  /// Pill radius - For pill-shaped buttons (999px all corners)
  static const pillRadius = BorderRadius.all(Radius.circular(pill));

  // ==================== Radius Presets (All Corners) ====================

  /// Extra small radius preset
  static const radiusXS = Radius.circular(xs);

  /// Small radius preset
  static const radiusSM = Radius.circular(sm);

  /// Medium radius preset
  static const radiusMD = Radius.circular(md);

  /// Large radius preset
  static const radiusLG = Radius.circular(lg);

  /// Extra large radius preset
  static const radiusXL = Radius.circular(xl);

  /// Extra extra large radius preset
  static const radiusXXL = Radius.circular(xxl);
}
