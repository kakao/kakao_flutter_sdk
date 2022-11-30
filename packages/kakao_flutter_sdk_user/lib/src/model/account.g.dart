// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['profile_needs_agreement'] as bool?,
      json['profile_nickname_needs_agreement'] as bool?,
      json['profile_image_needs_agreement'] as bool?,
      json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      json['name_needs_agreement'] as bool?,
      json['name'] as String?,
      json['email_needs_agreement'] as bool?,
      json['is_email_valid'] as bool?,
      json['is_email_verified'] as bool?,
      json['email'] as String?,
      json['age_range_needs_agreement'] as bool?,
      $enumDecodeNullable(_$AgeRangeEnumMap, json['age_range'],
          unknownValue: AgeRange.unknown),
      json['birthyear_needs_agreement'] as bool?,
      json['birthyear'] as String?,
      json['birthday_needs_agreement'] as bool?,
      json['birthday'] as String?,
      $enumDecodeNullable(_$BirthdayTypeEnumMap, json['birthday_type'],
          unknownValue: BirthdayType.unknown),
      json['gender_needs_agreement'] as bool?,
      $enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.other),
      json['ci_needs_agreement'] as bool?,
      json['ci'] as String?,
      json['ci_authenticated_at'] == null
          ? null
          : DateTime.parse(json['ci_authenticated_at'] as String),
      json['legal_name_needs_agreement'] as bool?,
      json['legal_name'] as String?,
      json['legal_gender_needs_agreement'] as bool?,
      $enumDecodeNullable(_$GenderEnumMap, json['legal_gender'],
          unknownValue: Gender.other),
      json['legal_birth_date_needs_agreement'] as bool?,
      json['legal_birth_date'] as String?,
      json['phone_number_needs_agreement'] as bool?,
      json['phone_number'] as String?,
      json['is_korean_needs_agreement'] as bool?,
      json['is_korean'] as bool?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('profile_needs_agreement', instance.profileNeedsAgreement);
  writeNotNull('profile_nickname_needs_agreement',
      instance.profileNicknameNeedsAgreement);
  writeNotNull(
      'profile_image_needs_agreement', instance.profileImageNeedsAgreement);
  writeNotNull('profile', instance.profile?.toJson());
  writeNotNull('name_needs_agreement', instance.nameNeedsAgreement);
  writeNotNull('name', instance.name);
  writeNotNull('email_needs_agreement', instance.emailNeedsAgreement);
  writeNotNull('is_email_valid', instance.isEmailValid);
  writeNotNull('is_email_verified', instance.isEmailVerified);
  writeNotNull('email', instance.email);
  writeNotNull('age_range_needs_agreement', instance.ageRangeNeedsAgreement);
  writeNotNull('age_range', _$AgeRangeEnumMap[instance.ageRange]);
  writeNotNull('birthyear_needs_agreement', instance.birthyearNeedsAgreement);
  writeNotNull('birthyear', instance.birthyear);
  writeNotNull('birthday_needs_agreement', instance.birthdayNeedsAgreement);
  writeNotNull('birthday', instance.birthday);
  writeNotNull('birthday_type', _$BirthdayTypeEnumMap[instance.birthdayType]);
  writeNotNull('gender_needs_agreement', instance.genderNeedsAgreement);
  writeNotNull('gender', _$GenderEnumMap[instance.gender]);
  writeNotNull('ci_needs_agreement', instance.ciNeedsAgreement);
  writeNotNull('ci', instance.ci);
  writeNotNull(
      'ci_authenticated_at', instance.ciAuthenticatedAt?.toIso8601String());
  writeNotNull('legal_name_needs_agreement', instance.legalNameNeedsAgreement);
  writeNotNull('legal_name', instance.legalName);
  writeNotNull('legal_birth_date_needs_agreement',
      instance.legalBirthDateNeedsAgreement);
  writeNotNull('legal_birth_date', instance.legalBirthDate);
  writeNotNull(
      'legal_gender_needs_agreement', instance.legalGenderNeedsAgreement);
  writeNotNull('legal_gender', _$GenderEnumMap[instance.legalGender]);
  writeNotNull(
      'phone_number_needs_agreement', instance.phoneNumberNeedsAgreement);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('is_korean_needs_agreement', instance.isKoreanNeedsAgreement);
  writeNotNull('is_korean', instance.isKorean);
  return val;
}

const _$AgeRangeEnumMap = {
  AgeRange.age_0_9: '0~9',
  AgeRange.age_10_14: '10~14',
  AgeRange.age_15_19: '15~19',
  AgeRange.age_20_29: '20~29',
  AgeRange.age_30_39: '30~39',
  AgeRange.age_40_49: '40~49',
  AgeRange.age_50_59: '50~59',
  AgeRange.age_60_69: '60~69',
  AgeRange.age_70_79: '70~79',
  AgeRange.age_80_89: '80~89',
  AgeRange.age_90above: '90~',
  AgeRange.unknown: 'unknown',
};

const _$BirthdayTypeEnumMap = {
  BirthdayType.solar: 'SOLAR',
  BirthdayType.lunar: 'LUNAR',
  BirthdayType.unknown: 'unknown',
};

const _$GenderEnumMap = {
  Gender.female: 'female',
  Gender.male: 'male',
  Gender.other: 'other',
};
