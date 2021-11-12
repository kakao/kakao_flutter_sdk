import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/profile.dart';

part 'account.g.dart';

/// <nodoc>
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)

/// Kakao account information.
class Account {
  bool? profileNeedsAgreement;
  bool? profileNicknameNeedsAgreement;
  bool? profileImageNeedsAgreement;
  Profile? profile;

  bool? nameNeedsAgreement;
  String? name;

  bool? emailNeedsAgreement;
  bool? isEmailValid;
  bool? isEmailVerified;
  String? email;

  bool? ageRangeNeedsAgreement;
  @JsonKey(unknownEnumValue: AgeRange.UNKNOWN)
  AgeRange? ageRange;

  bool? birthyearNeedsAgreement;
  String? birthyear;

  bool? birthdayNeedsAgreement;
  String? birthday;
  @JsonKey(unknownEnumValue: BirthdayType.UNKNOWN)
  BirthdayType? birthdayType;

  bool? genderNeedsAgreement;
  @JsonKey(unknownEnumValue: Gender.OTHER)
  Gender? gender;

  bool? ciNeedsAgreement;
  String? ci;
  DateTime? ciAuthenticatedAt;

  bool? legalNameNeedsAgreement;
  String? legalName;

  bool? legalBirthDateNeedsAgreement;
  String? legalBirthDate;

  bool? legalGenderNeedsAgreement;
  @JsonKey(unknownEnumValue: Gender.OTHER)
  Gender? legalGender;

  bool? phoneNumberNeedsAgreement;
  String? phoneNumber;

  bool? isKoreanNeedsAgreement;
  bool? isKorean;

  /// <nodoc>
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

  /// <nodoc>
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() => toJson().toString();
}

/// Age range in [Account].
enum AgeRange {
  @JsonValue("15~19")
  TEEN,
  @JsonValue("20~29")
  TWENTIES,
  @JsonValue("30~39")
  THIRTIES,
  @JsonValue("40~49")
  FORTIES,
  @JsonValue("50~59")
  FIFTIES,
  @JsonValue("60~69")
  SIXTIES,
  @JsonValue("70~79")
  SEVENTIES,
  @JsonValue("80~89")
  EIGHTEES,
  @JsonValue("90~")
  NINTIES_AND_ABOVE,
  UNKNOWN
}

/// Gender in [Account].
enum Gender {
  @JsonValue("female")
  FEMALE,
  @JsonValue("male")
  MALE,
  @JsonValue("other")
  OTHER
}

/// Birthday Type in [Account].
enum BirthdayType { SOLAR, LUNAR, UNKNOWN }
