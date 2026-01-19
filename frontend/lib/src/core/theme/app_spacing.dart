import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  static const screenPadding = EdgeInsets.all(20.0);
  static const cardPadding = EdgeInsets.all(16.0);
  static const listItemPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  static const buttonPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );
  static const inputPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 16.0,
  );
  static const sectionPadding = EdgeInsets.symmetric(vertical: 12.0);

  static const verticalSpaceXS = SizedBox(height: xs);
  static const verticalSpaceSM = SizedBox(height: sm);
  static const verticalSpaceMD = SizedBox(height: md);
  static const verticalSpaceLG = SizedBox(height: lg);
  static const verticalSpaceXL = SizedBox(height: xl);
  static const verticalSpaceXXL = SizedBox(height: xxl);
  static const verticalSpaceXXXL = SizedBox(height: xxxl);

  static const horizontalSpaceXS = SizedBox(width: xs);
  static const horizontalSpaceSM = SizedBox(width: sm);
  static const horizontalSpaceMD = SizedBox(width: md);
  static const horizontalSpaceLG = SizedBox(width: lg);
  static const horizontalSpaceXL = SizedBox(width: xl);
  static const horizontalSpaceXXL = SizedBox(width: xxl);
  static const horizontalSpaceXXXL = SizedBox(width: xxxl);
}
