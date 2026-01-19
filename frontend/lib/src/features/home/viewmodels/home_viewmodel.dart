import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/home_data.dart';
import '../providers/home_providers.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeData> build(String userId) async {
    return await ref.read(homeRepositoryProvider).getHomeData(userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = (state.value ?? await future).userFirstName;
      await ref.read(homeRepositoryProvider).refreshHomeData(userId);
      return await ref.read(homeRepositoryProvider).getHomeData(userId);
    });
  }

  DateTime getNextUpdateDate() {
    final now = DateTime.now();
    final nextMonth = now.month == 12 ? 1 : now.month + 1;
    final nextYear = now.month == 12 ? now.year + 1 : now.year;
    return DateTime(nextYear, nextMonth, 1);
  }

  String getPersonalizedInsight(List<CreditScoreUpdate> history) {
    if (history.length < 2) {
      return 'Welcome! Your credit journey is just beginning. Keep making timely payments to improve your score.';
    }

    final latestScore = history.last.score;
    final previousScore = history[history.length - 2].score;
    final scoreDiff = latestScore - previousScore;

    if (scoreDiff > 20) {
      return 'Excellent progress! Your credit score increased by $scoreDiff points. Keep up the great financial habits!';
    } else if (scoreDiff > 0) {
      return 'Good job! Your credit score improved by $scoreDiff points. Continue your positive financial behavior.';
    } else if (scoreDiff == 0) {
      return 'Your credit score is stable. Maintain your current payment patterns to continue building your credit.';
    } else if (scoreDiff > -20) {
      return 'Your score decreased by ${scoreDiff.abs()} points. Review your recent financial activities and ensure timely payments.';
    } else {
      return 'Your credit score dropped by ${scoreDiff.abs()} points. Consider consulting a financial advisor to improve your score.';
    }
  }

  double getLoanSuccessRate(int total, int approved) {
    if (total == 0) return 0.0;
    return (approved / total) * 100;
  }
}
