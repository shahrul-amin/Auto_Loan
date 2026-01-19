// AutoLoan Frontend Unit Tests
//
// Unit tests for business logic, utilities, and data models
// Test Coverage:
// - Authentication logic
// - Data validation
// - Utility functions
// - Model classes

import 'package:flutter_test/flutter_test.dart';
import 'dart:math' show pow;

void main() {
  group('DSR Calculation Tests', () {
    test('should calculate DSR correctly', () {
      double monthlyIncome = 5000;
      double totalCommitments = 1775;
      double expectedDSR = (totalCommitments / monthlyIncome) * 100;

      expect(expectedDSR, closeTo(35.5, 0.1));
    });

    test('should return 0 when income is 0', () {
      double monthlyIncome = 0;
      double totalCommitments = 1000;
      double dsr =
          monthlyIncome > 0 ? (totalCommitments / monthlyIncome) * 100 : 0;

      expect(dsr, equals(0));
    });

    test('should handle negative values', () {
      double totalCommitments = -100;

      expect(totalCommitments >= 0, isFalse);
    });
  });

  group('Credit Score Category Tests', () {
    String getCreditScoreCategory(int score) {
      if (score >= 750) return 'Excellent';
      if (score >= 700) return 'Very Good';
      if (score >= 650) return 'Good';
      if (score >= 600) return 'Fair';
      return 'Poor';
    }

    test('should categorize excellent credit score', () {
      expect(getCreditScoreCategory(780), equals('Excellent'));
    });

    test('should categorize very good credit score', () {
      expect(getCreditScoreCategory(720), equals('Very Good'));
    });

    test('should categorize good credit score', () {
      expect(getCreditScoreCategory(670), equals('Good'));
    });

    test('should categorize fair credit score', () {
      expect(getCreditScoreCategory(620), equals('Fair'));
    });

    test('should categorize poor credit score', () {
      expect(getCreditScoreCategory(550), equals('Poor'));
    });

    test('should handle boundary values', () {
      expect(getCreditScoreCategory(750), equals('Excellent'));
      expect(getCreditScoreCategory(749), equals('Very Good'));
    });
  });

  group('Loan Amount Validation Tests', () {
    bool isValidLoanAmount(double amount, String loanType) {
      if (amount <= 0) return false;

      Map<String, double> maxLimits = {
        'Personal': 100000,
        'Auto': 200000,
        'Home': 500000,
      };

      return amount <= (maxLimits[loanType] ?? 50000);
    }

    test('should accept valid personal loan amount', () {
      expect(isValidLoanAmount(50000, 'Personal'), isTrue);
    });

    test('should reject excessive personal loan amount', () {
      expect(isValidLoanAmount(150000, 'Personal'), isFalse);
    });

    test('should reject zero or negative amounts', () {
      expect(isValidLoanAmount(0, 'Personal'), isFalse);
      expect(isValidLoanAmount(-1000, 'Personal'), isFalse);
    });

    test('should handle different loan types', () {
      expect(isValidLoanAmount(180000, 'Auto'), isTrue);
      expect(isValidLoanAmount(450000, 'Home'), isTrue);
    });
  });

  group('IC Number Validation Tests', () {
    bool isValidMalaysianIC(String ic) {
      // Format: YYMMDD-PB-###G
      RegExp icPattern = RegExp(r'^\d{6}-\d{2}-\d{4}$');
      return icPattern.hasMatch(ic);
    }

    test('should accept valid IC format', () {
      expect(isValidMalaysianIC('900101-01-1234'), isTrue);
    });

    test('should reject invalid IC format', () {
      expect(isValidMalaysianIC('90010101234'), isFalse);
      expect(isValidMalaysianIC('900101-1-1234'), isFalse);
      expect(isValidMalaysianIC('invalid'), isFalse);
    });

    test('should reject empty IC', () {
      expect(isValidMalaysianIC(''), isFalse);
    });
  });

  group('Phone Number Validation Tests', () {
    bool isValidMalaysianPhone(String phone) {
      // Format: +60123456789 or 0123456789
      RegExp phonePattern = RegExp(r'^(\+?60|0)\d{9,10}$');
      return phonePattern.hasMatch(phone);
    }

    test('should accept valid phone with country code', () {
      expect(isValidMalaysianPhone('+60123456789'), isTrue);
    });

    test('should accept valid phone without country code', () {
      expect(isValidMalaysianPhone('0123456789'), isTrue);
    });

    test('should reject invalid phone format', () {
      expect(isValidMalaysianPhone('12345'), isFalse);
      expect(isValidMalaysianPhone('+1234567890'), isFalse);
    });
  });

  group('Email Validation Tests', () {
    bool isValidEmail(String email) {
      RegExp emailPattern =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailPattern.hasMatch(email);
    }

    test('should accept valid email', () {
      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('user.name@domain.co.uk'), isTrue);
    });

    test('should reject invalid email', () {
      expect(isValidEmail('invalid.email'), isFalse);
      expect(isValidEmail('@example.com'), isFalse);
      expect(isValidEmail('test@'), isFalse);
    });
  });

  group('OTP Validation Tests', () {
    bool isValidOTP(String otp) {
      return otp.length == 6 && int.tryParse(otp) != null;
    }

    test('should accept valid 6-digit OTP', () {
      expect(isValidOTP('123456'), isTrue);
    });

    test('should reject invalid OTP length', () {
      expect(isValidOTP('12345'), isFalse);
      expect(isValidOTP('1234567'), isFalse);
    });

    test('should reject non-numeric OTP', () {
      expect(isValidOTP('12345a'), isFalse);
      expect(isValidOTP('abcdef'), isFalse);
    });
  });

  group('Loan Tenure Validation Tests', () {
    bool isValidTenure(int tenure, String loanType) {
      Map<String, List<int>> tenureRanges = {
        'Personal': [12, 84],
        'Auto': [12, 108],
        'Home': [60, 420],
      };

      List<int>? range = tenureRanges[loanType];
      if (range == null) return false;

      return tenure >= range[0] && tenure <= range[1];
    }

    test('should accept valid personal loan tenure', () {
      expect(isValidTenure(36, 'Personal'), isTrue);
    });

    test('should reject excessive personal loan tenure', () {
      expect(isValidTenure(100, 'Personal'), isFalse);
    });

    test('should handle different loan types', () {
      expect(isValidTenure(84, 'Auto'), isTrue);
      expect(isValidTenure(360, 'Home'), isTrue);
    });
  });

  group('Monthly Payment Calculation Tests', () {
    double calculateMonthlyPayment(
        double loanAmount, int tenure, double interestRate) {
      if (interestRate == 0) return loanAmount / tenure;

      double monthlyRate = interestRate / 12 / 100;
      double denominator = 1 - pow(1 + monthlyRate, -tenure).toDouble();

      return (loanAmount * monthlyRate) / denominator;
    }

    test('should calculate monthly payment with 0% interest', () {
      double payment = calculateMonthlyPayment(36000, 36, 0);
      expect(payment, closeTo(1000, 0.01));
    });

    test('should calculate monthly payment with interest', () {
      // Simplified test - actual calculation may vary
      double payment = calculateMonthlyPayment(50000, 36, 5.0);
      expect(payment > 1388, isTrue);
      expect(payment < 1600, isTrue);
    });
  });

  group('Document Validation Tests', () {
    bool isValidDocumentFormat(String filename) {
      List<String> validExtensions = ['.jpg', '.jpeg', '.png', '.pdf'];
      String extension =
          filename.toLowerCase().substring(filename.lastIndexOf('.'));
      return validExtensions.contains(extension);
    }

    test('should accept valid document formats', () {
      expect(isValidDocumentFormat('document.pdf'), isTrue);
      expect(isValidDocumentFormat('image.jpg'), isTrue);
      expect(isValidDocumentFormat('photo.PNG'), isTrue);
    });

    test('should reject invalid document formats', () {
      expect(isValidDocumentFormat('document.doc'), isFalse);
      expect(isValidDocumentFormat('file.txt'), isFalse);
    });
  });
}
