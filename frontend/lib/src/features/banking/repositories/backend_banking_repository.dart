import '../repositories/banking_repository.dart';
import '../models/bank_model.dart';
import '../models/banking_account_model.dart';
import '../models/credit_card_model.dart';
import '../services/banking_api_service.dart';

class BackendBankingRepository implements BankingRepository {
  final BankingApiService _bankingApi;

  BackendBankingRepository(this._bankingApi);

  @override
  Future<Bank?> getBank(String bankId) async {
    try {
      final res = await _bankingApi.getBank(bankId);
      if (res['success'] == true && res['data'] != null) {
        return Bank.fromJson(Map<String, dynamic>.from(res['data']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get bank: $e');
    }
  }

  @override
  Future<List<Bank>> getAllBanks() async {
    try {
      final res = await _bankingApi.getAllBanks();
      if (res['success'] == true && res['data'] != null) {
        return (res['data'] as List)
            .map((e) => Bank.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get all banks: $e');
    }
  }

  @override
  Future<BankingAccount?> getBankingAccount(
      String icNumber, String bankId) async {
    try {
      final res = await _bankingApi.getBankingAccount(icNumber, bankId);
      if (res['success'] == true && res['data'] != null) {
        return BankingAccount.fromJson(Map<String, dynamic>.from(res['data']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get banking account: $e');
    }
  }

  @override
  Future<List<BankingAccount>> getUserBankingAccounts(String icNumber) async {
    try {
      final res = await _bankingApi.getUserBankingAccounts(icNumber);
      if (res['success'] == true && res['data'] != null) {
        return (res['data'] as List)
            .map((e) => BankingAccount.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get user banking accounts: $e');
    }
  }

  @override
  Future<List<CreditCard>> getUserCreditCards(String icNumber) async {
    try {
      final res = await _bankingApi.getUserCreditCards(icNumber);
      if (res['success'] == true && res['data'] != null) {
        return (res['data'] as List)
            .map((e) => CreditCard.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get user credit cards: $e');
    }
  }

  @override
  Future<List<CreditCard>> getBankCreditCards(
      String icNumber, String bankId) async {
    try {
      final res = await _bankingApi.getBankCreditCards(icNumber, bankId);
      if (res['success'] == true && res['data'] != null) {
        return (res['data'] as List)
            .map((e) => CreditCard.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get bank credit cards: $e');
    }
  }
}
