import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info_model.freezed.dart';
part 'personal_info_model.g.dart';

@freezed
class PersonalInfo with _$PersonalInfo {
  const factory PersonalInfo({
    required String icNumber,
    required String fullName,
    required String phoneNumber,
    required String email,
    required DateTime dateOfBirth,
    required String address,
    required String city,
    required String state,
    required String postcode,
    required String nationality,
    required String maritalStatus,
    @Default(0) int numberOfDependents,
    @Default('Unknown') String educationLevel,
    @Default('Unknown') String homeOwnership,
    @Default(false) bool ownsProperty,
  }) = _PersonalInfo;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);

  factory PersonalInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PersonalInfo(
      icNumber: data['icNumber'] as String,
      fullName: data['fullName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      email: data['email'] as String,
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      address: data['address'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      postcode: data['postcode'] as String,
      nationality: data['nationality'] as String,
      maritalStatus: data['maritalStatus'] as String,
      numberOfDependents: data['numberOfDependents'] as int? ?? 0,
      educationLevel: data['educationLevel'] as String? ?? 'Unknown',
      homeOwnership: data['homeOwnership'] as String? ?? 'Unknown',
      ownsProperty: data['ownsProperty'] as bool? ?? false,
    );
  }
}

extension PersonalInfoX on PersonalInfo {
  Map<String, dynamic> toFirestore() {
    return {
      'icNumber': icNumber,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'address': address,
      'city': city,
      'state': state,
      'postcode': postcode,
      'nationality': nationality,
      'maritalStatus': maritalStatus,
      'numberOfDependents': numberOfDependents,
      'educationLevel': educationLevel,
      'homeOwnership': homeOwnership,
      'ownsProperty': ownsProperty,
    };
  }
}
