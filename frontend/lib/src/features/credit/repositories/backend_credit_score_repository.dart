import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/credit_score_model.dart';
import '../models/credit_card_model.dart';
import 'credit_score_repository.dart';

class BackendCreditScoreRepository implements CreditScoreRepository {
  final String baseUrl;
  final http.Client httpClient;

  BackendCreditScoreRepository({
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  @override
  Future<Map<String, dynamic>> getCreditOverview(String icNumber) async {
    final url = Uri.parse('$baseUrl/api/credit/score/overview/$icNumber');

    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['success'] == true && jsonData['data'] != null) {
        final data = jsonData['data'] as Map<String, dynamic>;

        final creditScoreData = data['creditScore'] as Map<String, dynamic>;
        final creditScore = CreditScoreModel(
          score: creditScoreData['score'] as int,
          category: _parseCreditCategory(creditScoreData['category'] as String),
          lastUpdated: DateTime.parse(creditScoreData['lastUpdated'] as String),
        );

        final creditCardsData = data['creditCards'] as List<dynamic>;
        final creditCards = creditCardsData.map((card) {
          final cardMap = card as Map<String, dynamic>;
          return CreditCardModel(
            id: cardMap['id'] as String,
            cardNumber: cardMap['cardNumber'] as String,
            maskedCardNumber: cardMap['maskedCardNumber'] as String,
            bankId: cardMap['bankId'] as String,
            bankName: cardMap['bankName'] as String,
            bankLogoUrl: cardMap['bankLogoUrl'] as String,
            primaryColor: cardMap['primaryColor'] as String,
            cardScheme: _parseCardScheme(cardMap['cardScheme'] as String),
            currentBalance: (cardMap['currentBalance'] as num).toDouble(),
            creditLimit: (cardMap['creditLimit'] as num).toDouble(),
            availableCredit: (cardMap['availableCredit'] as num).toDouble(),
          );
        }).toList();

        return {
          'creditScore': creditScore,
          'creditCards': creditCards,
        };
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Credit score not found for IC number: $icNumber');
    } else {
      throw Exception('Failed to load credit overview: ${response.statusCode}');
    }
  }

  @override
  Future<String> triggerPrediction(String icNumber) async {
    final url =
        Uri.parse('$baseUrl/api/credit/score/trigger-prediction/$icNumber');

    final response = await httpClient.post(url);

    if (response.statusCode == 202) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['success'] == true && jsonData['jobId'] != null) {
        return jsonData['jobId'] as String;
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      throw Exception(jsonData['message'] ?? 'Not eligible for prediction');
    } else {
      throw Exception('Failed to trigger prediction: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> getPredictionStatus(String jobId) async {
    final url = Uri.parse('$baseUrl/api/credit/score/prediction-status/$jobId');

    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['success'] == true) {
        return {
          'status': jsonData['status'] as String,
          'result': jsonData['result'],
          'error': jsonData['error'],
        };
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Prediction job not found: $jobId');
    } else {
      throw Exception(
          'Failed to get prediction status: ${response.statusCode}');
    }
  }

  CreditScoreCategory _parseCreditCategory(String category) {
    switch (category) {
      case 'Poor':
        return CreditScoreCategory.poor;
      case 'Fair':
        return CreditScoreCategory.fair;
      case 'Good':
        return CreditScoreCategory.good;
      case 'Very Good':
        return CreditScoreCategory.veryGood;
      case 'Excellent':
        return CreditScoreCategory.excellent;
      default:
        throw Exception('Unknown credit category: $category');
    }
  }

  CreditCardType _parseCardScheme(String scheme) {
    switch (scheme.toLowerCase()) {
      case 'visa':
        return CreditCardType.visa;
      case 'mastercard':
        return CreditCardType.mastercard;
      case 'amex':
        return CreditCardType.amex;
      default:
        throw Exception('Unknown card scheme: $scheme');
    }
  }
}
