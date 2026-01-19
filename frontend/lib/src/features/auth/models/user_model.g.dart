// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      icNumber: json['icNumber'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      surName: json['surName'] as String?,
      connectedBanks: (json['connectedBanks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dataConsentGiven: json['dataConsentGiven'] as bool? ?? false,
      dataConsentDate: json['dataConsentDate'] == null
          ? null
          : DateTime.parse(json['dataConsentDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'icNumber': instance.icNumber,
      'profileImageUrl': instance.profileImageUrl,
      'surName': instance.surName,
      'connectedBanks': instance.connectedBanks,
      'dataConsentGiven': instance.dataConsentGiven,
      'dataConsentDate': instance.dataConsentDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
