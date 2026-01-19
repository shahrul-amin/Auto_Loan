import '../models/personal_info_model.dart';

abstract class PersonalInfoRepository {
  Future<PersonalInfo?> getPersonalInfo(String icNumber);
  Future<void> createPersonalInfo(PersonalInfo personalInfo);
  Future<void> updatePersonalInfo(PersonalInfo personalInfo);
}
