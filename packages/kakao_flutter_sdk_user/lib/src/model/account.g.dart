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
  $enumDecodeNullable(
    _$AgeRangeEnumMap,
    json['age_range'],
    unknownValue: AgeRange.unknown,
  ),
  json['birthyear_needs_agreement'] as bool?,
  json['birthyear'] as String?,
  json['birthday_needs_agreement'] as bool?,
  json['birthday'] as String?,
  $enumDecodeNullable(
    _$BirthdayTypeEnumMap,
    json['birthday_type'],
    unknownValue: BirthdayType.unknown,
  ),
  json['is_leap_month'] as bool?,
  json['gender_needs_agreement'] as bool?,
  $enumDecodeNullable(
    _$GenderEnumMap,
    json['gender'],
    unknownValue: Gender.other,
  ),
  json['legal_name_needs_agreement'] as bool?,
  json['legal_name'] as String?,
  json['legal_gender_needs_agreement'] as bool?,
  $enumDecodeNullable(
    _$GenderEnumMap,
    json['legal_gender'],
    unknownValue: Gender.other,
  ),
  json['legal_birth_date_needs_agreement'] as bool?,
  json['legal_birth_date'] as String?,
  json['phone_number_needs_agreement'] as bool?,
  json['phone_number'] as String?,
  json['is_korean_needs_agreement'] as bool?,
  json['is_korean'] as bool?,
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'profile_needs_agreement': ?instance.profileNeedsAgreement,
  'profile_nickname_needs_agreement': ?instance.profileNicknameNeedsAgreement,
  'profile_image_needs_agreement': ?instance.profileImageNeedsAgreement,
  'profile': ?instance.profile?.toJson(),
  'name_needs_agreement': ?instance.nameNeedsAgreement,
  'name': ?instance.name,
  'email_needs_agreement': ?instance.emailNeedsAgreement,
  'is_email_valid': ?instance.isEmailValid,
  'is_email_verified': ?instance.isEmailVerified,
  'email': ?instance.email,
  'age_range_needs_agreement': ?instance.ageRangeNeedsAgreement,
  'age_range': ?_$AgeRangeEnumMap[instance.ageRange],
  'birthyear_needs_agreement': ?instance.birthyearNeedsAgreement,
  'birthyear': ?instance.birthyear,
  'birthday_needs_agreement': ?instance.birthdayNeedsAgreement,
  'birthday': ?instance.birthday,
  'birthday_type': ?_$BirthdayTypeEnumMap[instance.birthdayType],
  'is_leap_month': ?instance.isLeapMonth,
  'gender_needs_agreement': ?instance.genderNeedsAgreement,
  'gender': ?_$GenderEnumMap[instance.gender],
  'legal_name_needs_agreement': ?instance.legalNameNeedsAgreement,
  'legal_name': ?instance.legalName,
  'legal_birth_date_needs_agreement': ?instance.legalBirthDateNeedsAgreement,
  'legal_birth_date': ?instance.legalBirthDate,
  'legal_gender_needs_agreement': ?instance.legalGenderNeedsAgreement,
  'legal_gender': ?_$GenderEnumMap[instance.legalGender],
  'phone_number_needs_agreement': ?instance.phoneNumberNeedsAgreement,
  'phone_number': ?instance.phoneNumber,
  'is_korean_needs_agreement': ?instance.isKoreanNeedsAgreement,
  'is_korean': ?instance.isKorean,
};

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
