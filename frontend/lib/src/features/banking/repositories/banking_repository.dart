import '../models/bank_model.dart';
import '../models/banking_account_model.dart';
import '../models/credit_card_model.dart';

abstract class BankingRepository {
  Future<Bank?> getBank(String bankId);
  Future<List<Bank>> getAllBanks();

  Future<BankingAccount?> getBankingAccount(String icNumber, String bankId);
  Future<List<BankingAccount>> getUserBankingAccounts(String icNumber);

  Future<List<CreditCard>> getUserCreditCards(String icNumber);
  Future<List<CreditCard>> getBankCreditCards(String icNumber, String bankId);
}
