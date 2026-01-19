import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// White background, subtle shadow, rounded corners, generous padding
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderRadius,
    this.shadow,
    super.key,
  });

  /// The widget to display inside the card
  final Widget child;

  /// Padding inside the card (defaults to 16px all sides)
  final EdgeInsetsGeometry? padding;

  /// Margin outside the card
  final EdgeInsetsGeometry? margin;

  /// Callback when card is tapped (makes card interactive)
  final VoidCallback? onTap;

  /// Background color (defaults to surface white)
  final Color? color;

  /// Border radius (defaults to card radius)
  final BorderRadius? borderRadius;

  /// Shadow (defaults to card shadow)
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: (color ?? AppColors.surface).withOpacity(0.3),
        borderRadius: borderRadius ?? AppRadius.cardRadius,
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.2),
        ),
        boxShadow: shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppRadius.cardRadius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Elevated card variant - For hover or important cards
class AppCardElevated extends StatelessWidget {
  const AppCardElevated({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      shadow: AppShadows.cardElevated,
      child: child,
    );
  }
}

/// Subtle card variant - For nested cards or secondary surfaces
class AppCardSubtle extends StatelessWidget {
  const AppCardSubtle({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      shadow: AppShadows.subtle,
      child: child,
    );
  }
}
