import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_radius.dart';

/// Badge type enum
enum BadgeType {
  success,
  warning,
  error,
  info,
  neutral,
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.type = BadgeType.info,
    this.icon,
    super.key,
  });

  /// Badge text label
  final String label;

  /// Badge type (determines color)
  final BadgeType type;

  /// Optional icon to show before label
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case BadgeType.success:
        backgroundColor = AppColors.successLight;
        textColor = AppColors.successDark;
        break;
      case BadgeType.warning:
        backgroundColor = AppColors.warningLight;
        textColor = AppColors.warningDark;
        break;
      case BadgeType.error:
        backgroundColor = AppColors.errorLight;
        textColor = AppColors.errorDark;
        break;
      case BadgeType.info:
        backgroundColor = AppColors.infoLight;
        textColor = AppColors.infoDark;
        break;
      case BadgeType.neutral:
      default:
        backgroundColor = AppColors.surfaceVariant;
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.badgeRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

/// Large badge variant
class AppBadgeLarge extends StatelessWidget {
  const AppBadgeLarge({
    required this.label,
    this.type = BadgeType.info,
    this.icon,
    super.key,
  });

  final String label;
  final BadgeType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case BadgeType.success:
        backgroundColor = AppColors.successLight;
        textColor = AppColors.successDark;
        break;
      case BadgeType.warning:
        backgroundColor = AppColors.warningLight;
        textColor = AppColors.warningDark;
        break;
      case BadgeType.error:
        backgroundColor = AppColors.errorLight;
        textColor = AppColors.errorDark;
        break;
      case BadgeType.info:
        backgroundColor = AppColors.infoLight;
        textColor = AppColors.infoDark;
        break;
      case BadgeType.neutral:
      default:
        backgroundColor = AppColors.surfaceVariant;
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

/// Dot badge - Small colored circle indicator
class AppDotBadge extends StatelessWidget {
  const AppDotBadge({
    this.type = BadgeType.info,
    this.size = 8,
    super.key,
  });

  final BadgeType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (type) {
      case BadgeType.success:
        color = AppColors.success;
        break;
      case BadgeType.warning:
        color = AppColors.warning;
        break;
      case BadgeType.error:
        color = AppColors.error;
        break;
      case BadgeType.info:
        color = AppColors.info;
        break;
      case BadgeType.neutral:
      default:
        color = AppColors.textTertiary;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Count badge - Circular badge with number
class AppCountBadge extends StatelessWidget {
  const AppCountBadge({
    required this.count,
    this.type = BadgeType.error,
    super.key,
  });

  final int count;
  final BadgeType type;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (type) {
      case BadgeType.success:
        backgroundColor = AppColors.success;
        break;
      case BadgeType.warning:
        backgroundColor = AppColors.warning;
        break;
      case BadgeType.error:
        backgroundColor = AppColors.error;
        break;
      case BadgeType.info:
        backgroundColor = AppColors.info;
        break;
      case BadgeType.neutral:
      default:
        backgroundColor = AppColors.textSecondary;
        break;
    }

    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Center(
        child: Text(
          displayCount,
          style: AppTextStyles.labelSmall.copyWith(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
