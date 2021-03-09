// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
    json['profile_needs_agreement'] as bool,
    Profile.fromJson(json['profile'] as Map<String, dynamic>),
    json['is_email_verified'] as bool,
    json['is_email_valid'] as bool,
    json['email_needs_agreement'] as bool,
    json['email'] as String,
    json['is_kakaotalk_user'] as bool,
    json['phone_number_needs_agreement'] as bool,
    json['phone_number'] as String,
    json['age_range_needs_agreement'] as bool,
    _$enumDecode(_$AgeRangeEnumMap, json['age_range'],
        unknownValue: AgeRange.UNKNOWN),
    json['birthday_needs_agreement'] as bool,
    json['birthday'] as String,
    json['birthyear_needs_agreement'] as bool,
    json['birthyear'] as String,
    json['gender_needs_agreement'] as bool,
    _$enumDecode(_$GenderEnumMap, json['gender'], unknownValue: Gender.OTHER),
    json['ci_needs_agreement'] as bool,
    json['ci'] as String,
    DateTime.parse(json['ci_authenticated_at'] as String),
  );
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'profile_needs_agreement': instance.profileNeedsAgreement,
      'profile': instance.profile.toJson(),
      'is_email_verified': instance.isEmailVerified,
      'is_email_valid': instance.isEmailValid,
      'email_needs_agreement': instance.emailNeedsAgreement,
      'email': instance.email,
      'is_kakaotalk_user': instance.isKakaotalkUser,
      'phone_number_needs_agreement': instance.phoneNumberNeedsAgreement,
      'phone_number': instance.phoneNumber,
      'age_range_needs_agreement': instance.ageRangeNeedsAgreement,
      'age_range': _$AgeRangeEnumMap[instance.ageRange],
      'birthday_needs_agreement': instance.birthdayNeedsAgreement,
      'birthday': instance.birthday,
      'birthyear_needs_agreement': instance.birthyearNeedsAgreement,
      'birthyear': instance.birthyear,
      'gender_needs_agreement': instance.genderNeedsAgreement,
      'gender': _$GenderEnumMap[instance.gender],
      'ci_needs_agreement': instance.ciNeedsAgreement,
      'ci': instance.ci,
      'ci_authenticated_at': instance.ciAuthenticatedAt.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$AgeRangeEnumMap = {
  AgeRange.TEEN: '15~19',
  AgeRange.TWENTIES: '20~29',
  AgeRange.THIRTIES: '30~39',
  AgeRange.FORTIES: '40~49',
  AgeRange.FIFTIES: '50~59',
  AgeRange.SIXTIES: '60~69',
  AgeRange.SEVENTIES: '70~79',
  AgeRange.EIGHTEES: '80~89',
  AgeRange.NINTIES_AND_ABOVE: '90~',
  AgeRange.UNKNOWN: 'UNKNOWN',
};

const _$GenderEnumMap = {
  Gender.FEMALE: 'female',
  Gender.MALE: 'male',
  Gender.OTHER: 'other',
};
