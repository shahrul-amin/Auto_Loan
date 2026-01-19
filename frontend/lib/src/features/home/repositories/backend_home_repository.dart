import '../models/home_data.dart';
import '../../../core/api/api_service.dart';
import 'home_repository.dart';

class BackendHomeRepository implements HomeRepository {
  final ApiService _apiService;

  BackendHomeRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<HomeData> getHomeData(String userId) async {
    final response = await _apiService.get('/dashboard/$userId/summary');

    if (response['success'] == true && response['data'] != null) {
      return _mapResponseToHomeData(response['data']);
    }

    throw Exception('Failed to load home data');
  }

  @override
  Future<void> refreshHomeData(String userId) async {
    await getHomeData(userId);
  }

  HomeData _mapResponseToHomeData(Map<String, dynamic> data) {
    final creditScoreHistory = (data['creditScoreHistory'] as List?)
            ?.map((item) => CreditScoreUpdate(
                  date: DateTime.parse(item['predictedAt'] ?? item['date']),
                  score: (item['creditScore'] ?? item['score'] ?? 0) as int,
                ))
            .toList() ??
        [];

    final existingLoans = (data['existingLoans'] as List?)
            ?.map((item) => ExistingLoanSummary(
                  loanId: item['loanId'] ?? '',
                  loanType: item['loanType'] ?? '',
                  loanAmount: (item['loanAmount'] ?? 0.0).toDouble(),
                  outstandingBalance:
                      (item['outstandingBalance'] ?? 0.0).toDouble(),
                  monthlyInstallment:
                      (item['monthlyInstallment'] ?? 0.0).toDouble(),
                  remainingTenure: (item['remainingTenure'] ?? 0) as int,
                  startDate: DateTime.parse(item['startDate']),
                  nextPaymentDate: item['nextPaymentDate'] != null
                      ? DateTime.parse(item['nextPaymentDate'])
                      : null,
                ))
            .toList() ??
        [];

    final financialMetrics = data['financialMetrics'] as Map<String, dynamic>?;

    return HomeData(
      userFirstName: data['userFirstName'] ?? 'User',
      registrationDate: DateTime.parse(data['registrationDate']),
      currentCreditScore: data['currentCreditScore'] ?? 0,
      creditScoreHistory: creditScoreHistory,
      existingLoans: existingLoans,
      financialMetrics: FinancialMetrics(
        dsrPercentage: (financialMetrics?['dsrPercentage'] ?? 0.0).toDouble(),
        ccrisGood: financialMetrics?['ccrisGood'] ?? false,
        totalExistingCommitments:
            (financialMetrics?['totalExistingCommitments'] ?? 0.0).toDouble(),
        dsrBreakdown: _parseDoubleMap(financialMetrics?['dsrBreakdown']),
        ccrisDetails: financialMetrics?['ccrisDetails'],
        commitmentsBreakdown:
            _parseDoubleMap(financialMetrics?['commitmentsBreakdown']),
      ),
      activeLoansCount: data['activeLoansCount'] ?? 0,
      totalApplicationsCount: data['totalApplicationsCount'] ?? 0,
      approvedApplicationsCount: data['approvedApplicationsCount'] ?? 0,
    );
  }

  Map<String, double>? _parseDoubleMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return map.map((key, value) {
      if (value is num) {
        return MapEntry(key, value.toDouble());
      }
      return MapEntry(key, 0.0);
    });
  }
}
