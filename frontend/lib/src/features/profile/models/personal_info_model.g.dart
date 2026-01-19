// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonalInfoImpl _$$PersonalInfoImplFromJson(Map<String, dynamic> json) =>
    _$PersonalInfoImpl(
      icNumber: json['icNumber'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      nationality: json['nationality'] as String,
      maritalStatus: json['maritalStatus'] as String,
      numberOfDependents: (json['numberOfDependents'] as num?)?.toInt() ?? 0,
      educationLevel: json['educationLevel'] as String? ?? 'Unknown',
      homeOwnership: json['homeOwnership'] as String? ?? 'Unknown',
      ownsProperty: json['ownsProperty'] as bool? ?? false,
    );

Map<String, dynamic> _$$PersonalInfoImplToJson(_$PersonalInfoImpl instance) =>
    <String, dynamic>{
      'icNumber': instance.icNumber,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'nationality': instance.nationality,
      'maritalStatus': instance.maritalStatus,
      'numberOfDependents': instance.numberOfDependents,
      'educationLevel': instance.educationLevel,
      'homeOwnership': instance.homeOwnership,
      'ownsProperty': instance.ownsProperty,
    };
