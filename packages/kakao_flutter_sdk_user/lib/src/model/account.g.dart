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
      json['is_leap_month'] as bool?,
      json['gender_needs_agreement'] as bool?,
      $enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.other),
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

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      if (instance.profileNeedsAgreement case final value?)
        'profile_needs_agreement': value,
      if (instance.profileNicknameNeedsAgreement case final value?)
        'profile_nickname_needs_agreement': value,
      if (instance.profileImageNeedsAgreement case final value?)
        'profile_image_needs_agreement': value,
      if (instance.profile?.toJson() case final value?) 'profile': value,
      if (instance.nameNeedsAgreement case final value?)
        'name_needs_agreement': value,
      if (instance.name case final value?) 'name': value,
      if (instance.emailNeedsAgreement case final value?)
        'email_needs_agreement': value,
      if (instance.isEmailValid case final value?) 'is_email_valid': value,
      if (instance.isEmailVerified case final value?)
        'is_email_verified': value,
      if (instance.email case final value?) 'email': value,
      if (instance.ageRangeNeedsAgreement case final value?)
        'age_range_needs_agreement': value,
      if (_$AgeRangeEnumMap[instance.ageRange] case final value?)
        'age_range': value,
      if (instance.birthyearNeedsAgreement case final value?)
        'birthyear_needs_agreement': value,
      if (instance.birthyear case final value?) 'birthyear': value,
      if (instance.birthdayNeedsAgreement case final value?)
        'birthday_needs_agreement': value,
      if (instance.birthday case final value?) 'birthday': value,
      if (_$BirthdayTypeEnumMap[instance.birthdayType] case final value?)
        'birthday_type': value,
      if (instance.isLeapMonth case final value?) 'is_leap_month': value,
      if (instance.genderNeedsAgreement case final value?)
        'gender_needs_agreement': value,
      if (_$GenderEnumMap[instance.gender] case final value?) 'gender': value,
      if (instance.legalNameNeedsAgreement case final value?)
        'legal_name_needs_agreement': value,
      if (instance.legalName case final value?) 'legal_name': value,
      if (instance.legalBirthDateNeedsAgreement case final value?)
        'legal_birth_date_needs_agreement': value,
      if (instance.legalBirthDate case final value?) 'legal_birth_date': value,
      if (instance.legalGenderNeedsAgreement case final value?)
        'legal_gender_needs_agreement': value,
      if (_$GenderEnumMap[instance.legalGender] case final value?)
        'legal_gender': value,
      if (instance.phoneNumberNeedsAgreement case final value?)
        'phone_number_needs_agreement': value,
      if (instance.phoneNumber case final value?) 'phone_number': value,
      if (instance.isKoreanNeedsAgreement case final value?)
        'is_korean_needs_agreement': value,
      if (instance.isKorean case final value?) 'is_korean': value,
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
