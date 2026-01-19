import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String icNumber,
    String? profileImageUrl,
    String? surName,
    @Default([]) List<String> connectedBanks,
    @Default(false) bool dataConsentGiven,
    DateTime? dataConsentDate,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      icNumber: data['icNumber'] as String,
      profileImageUrl: data['profileImageUrl'] as String?,
      surName: data['surName'] as String?,
      connectedBanks: List<String>.from(data['connectedBanks'] as List? ?? []),
      dataConsentGiven: data['dataConsentGiven'] as bool? ?? false,
      dataConsentDate: data['dataConsentDate'] != null
          ? (data['dataConsentDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

extension UserX on User {
  Map<String, dynamic> toFirestore() {
    return {
      'icNumber': icNumber,
      'profileImageUrl': profileImageUrl,
      'surName': surName,
      'connectedBanks': connectedBanks,
      'dataConsentGiven': dataConsentGiven,
      'dataConsentDate':
          dataConsentDate != null ? Timestamp.fromDate(dataConsentDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
