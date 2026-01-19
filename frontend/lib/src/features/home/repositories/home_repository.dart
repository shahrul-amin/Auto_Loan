import '../models/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> getHomeData(String userId);
  Future<void> refreshHomeData(String userId);
}
