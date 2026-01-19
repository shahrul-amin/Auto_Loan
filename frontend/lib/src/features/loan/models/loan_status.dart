import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_badge.dart';
import 'package:flutter/material.dart';

enum LoanStatus {
  @JsonValue('rejected')
  rejected,
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('credited')
  credited,
}

extension LoanStatusExtension on LoanStatus {
  String get label {
    switch (this) {
      case LoanStatus.rejected:
        return 'Rejected';
      case LoanStatus.pending:
        return 'Pending';
      case LoanStatus.approved:
        return 'Approved';
      case LoanStatus.credited:
        return 'Credited';
    }
  }

  Color get color {
    switch (this) {
      case LoanStatus.rejected:
        return AppColors.error;
      case LoanStatus.pending:
        return AppColors.warning;
      case LoanStatus.approved:
        return AppColors.success;
      case LoanStatus.credited:
        return AppColors.info;
    }
  }

  BadgeType get badgeType {
    switch (this) {
      case LoanStatus.rejected:
        return BadgeType.error;
      case LoanStatus.pending:
        return BadgeType.warning;
      case LoanStatus.approved:
        return BadgeType.success;
      case LoanStatus.credited:
        return BadgeType.info;
    }
  }

  String get description {
    switch (this) {
      case LoanStatus.rejected:
        return 'Application rejected by ML model or bank officer';
      case LoanStatus.pending:
        return 'ML model is processing your application';
      case LoanStatus.approved:
        return 'ML model approved - awaiting officer review';
      case LoanStatus.credited:
        return 'Approved by officer and amount credited';
    }
  }

  static LoanStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return LoanStatus.rejected;
      case 'pending':
      case 'under_review':
        return LoanStatus.pending;
      case 'approved':
        return LoanStatus.approved;
      case 'credited':
        return LoanStatus.credited;
      default:
        return LoanStatus.pending;
    }
  }
}
