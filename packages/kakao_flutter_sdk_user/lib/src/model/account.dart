import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/profile.dart';

part 'account.g.dart';

/// 카카오계정에 등록된 사용자 개인정보
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Account {
  /// profile 제공에 대한 사용자 동의 필요 여부
  bool? profileNeedsAgreement;

  /// profile nickename 제공에 대한 사용자 동의 필요 여부
  bool? profileNicknameNeedsAgreement;

  /// profile image 제공에 대한 사용자 동의 필요 여부
  bool? profileImageNeedsAgreement;

  /// 카카오계정 프로필 정보
  Profile? profile;

  /// 카카오계정 이름에 대한 사용자 동의 필요 여부
  bool? nameNeedsAgreement;

  /// 카카오계정 이름
  String? name;

  /// email 제공에 대한 사용자 동의 필요 여부
  bool? emailNeedsAgreement;

  /// 카카오계정에 등록된 이메일의 유효성
  bool? isEmailValid;

  /// 카카오계정에 이메일 등록 시 이메일 인증을 받았는지 여부
  bool? isEmailVerified;

  /// 카카오계정 대표 이메일
  String? email;

  /// 연령 제공에 대한 사용자 동의 필요 여부
  bool? ageRangeNeedsAgreement;

  /// 연령대
  @JsonKey(unknownEnumValue: AgeRange.unknown)
  AgeRange? ageRange;

  /// birthyear 제공에 대한 사용자 동의 필요 여부
  bool? birthyearNeedsAgreement;

  /// 출생 연도 (YYYY)
  String? birthyear;

  /// birthday 제공에 대한 사용자 동의 필요 여부
  bool? birthdayNeedsAgreement;

  /// 생일 (MMDD)
  String? birthday;

  /// 생일의 양력/음력
  @JsonKey(unknownEnumValue: BirthdayType.unknown)
  BirthdayType? birthdayType;

  /// gender 제공에 대한 사용자의 동의 필요 여부
  bool? genderNeedsAgreement;

  /// 성별
  @JsonKey(unknownEnumValue: Gender.other)
  Gender? gender;

  /// ci 제공에 대한 사용자의 동의 필요 여부
  bool? ciNeedsAgreement;

  /// 암호화된 사용자 확인값
  String? ci;

  /// ci 발급시간
  DateTime? ciAuthenticatedAt;

  /// legalName 제공에 대한 사용자 동의 필요 여부
  bool? legalNameNeedsAgreement;

  /// 실명
  String? legalName;

  /// legalBirthDate 제공에 대한 사용자 동의 필요 여부
  bool? legalBirthDateNeedsAgreement;

  /// 법정생년월일
  String? legalBirthDate;

  /// legalGender 제공에 대한 사용자 동의 필요 여부
  bool? legalGenderNeedsAgreement;

  /// 법정성별
  @JsonKey(unknownEnumValue: Gender.other)
  Gender? legalGender;

  /// phoneNumber 제공에 대한 사용자 동의 필요 여부
  bool? phoneNumberNeedsAgreement;

  /// 카카오톡에서 인증한 전화번호
  String? phoneNumber;

  /// 한국인 여부 제공에 대한 사용자 동의 필요 여부
  bool? isKoreanNeedsAgreement;

  /// 한국인 여부
  bool? isKorean;

  /// @nodoc
  Account(
      this.profileNeedsAgreement,
      this.profileNicknameNeedsAgreement,
      this.profileImageNeedsAgreement,
      this.profile,
      this.nameNeedsAgreement,
      this.name,
      this.emailNeedsAgreement,
      this.isEmailValid,
      this.isEmailVerified,
      this.email,
      this.ageRangeNeedsAgreement,
      this.ageRange,
      this.birthyearNeedsAgreement,
      this.birthyear,
      this.birthdayNeedsAgreement,
      this.birthday,
      this.birthdayType,
      this.genderNeedsAgreement,
      this.gender,
      this.ciNeedsAgreement,
      this.ci,
      this.ciAuthenticatedAt,
      this.legalNameNeedsAgreement,
      this.legalName,
      this.legalGenderNeedsAgreement,
      this.legalGender,
      this.legalBirthDateNeedsAgreement,
      this.legalBirthDate,
      this.phoneNumberNeedsAgreement,
      this.phoneNumber,
      this.isKoreanNeedsAgreement,
      this.isKorean);

  /// @nodoc
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// 연령대 (한국 나이)
enum AgeRange {
  @JsonValue("0~9")
  age_0_9,
  @JsonValue("10~14")
  age_10_14,
  @JsonValue("15~19")
  age_15_19,
  @JsonValue("20~29")
  age_20_29,
  @JsonValue("30~39")
  age_30_39,
  @JsonValue("40~49")
  age_40_49,
  @JsonValue("50~59")
  age_50_59,
  @JsonValue("60~69")
  age_60_69,
  @JsonValue("70~79")
  age_70_79,
  @JsonValue("80~89")
  age_80_89,
  @JsonValue("90~")
  age_90above,
  unknown
}

/// 성별
enum Gender { female, male, other }

/// 생일의 양력/음력
enum BirthdayType {
  @JsonValue("SOLAR")
  solar,
  @JsonValue("LUNAR")
  lunar,
  unknown
}
