abstract class CreditScoreRepository {
  Future<Map<String, dynamic>> getCreditOverview(String icNumber);
  Future<String> triggerPrediction(String icNumber);
  Future<Map<String, dynamic>> getPredictionStatus(String jobId);
}
