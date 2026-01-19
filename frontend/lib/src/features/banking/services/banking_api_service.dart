import '../../../core/api/api_service.dart';

class BankingApiService {
  final ApiService _api;

  BankingApiService(this._api);

  Future<Map<String, dynamic>> getBank(String bankId) async {
    return await _api.get('/banks/$bankId');
  }

  Future<Map<String, dynamic>> getAllBanks() async {
    return await _api.get('/banks');
  }

  Future<Map<String, dynamic>> getBankingAccount(
      String icNumber, String bankId) async {
    return await _api.get('/banking/accounts/$icNumber/$bankId');
  }

  Future<Map<String, dynamic>> getUserBankingAccounts(String icNumber) async {
    return await _api.get('/banking/accounts/$icNumber');
  }

  Future<Map<String, dynamic>> getUserCreditCards(String icNumber) async {
    return await _api
        .get('/banking/credit-cards', queryParameters: {'icNumber': icNumber});
  }

  Future<Map<String, dynamic>> getBankCreditCards(
      String icNumber, String bankId) async {
    return await _api.get('/banking/credit-cards',
        queryParameters: {'icNumber': icNumber, 'bankId': bankId});
  }
}
