import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Account {
  Account(
      this.isEmailVerified,
      this.isEmailValid,
      this.emailNeedsAgreement,
      this.email,
      this.isKakaotalkUser,
      this.phoneNumberNeedsAgreement,
      this.phoneNumber,
      this.ageRangeNeedsAgreement,
      this.ageRange,
      this.birthdayNeedsAgreement,
      this.birthday,
      this.birthyearNeedsAgreement,
      this.birthyear,
      this.genderNeedsAgreement,
      this.gender,
      this.ciNeedsAgreement,
      this.ci,
      this.ciAuthenticatedAt);
  bool isEmailVerified;
  bool isEmailValid;
  bool emailNeedsAgreement;
  String email;

  bool isKakaotalkUser;

  bool phoneNumberNeedsAgreement;
  String phoneNumber;

  bool ageRangeNeedsAgreement;
  AgeRange ageRange;

  bool birthdayNeedsAgreement;
  String birthday;

  bool birthyearNeedsAgreement;
  String birthyear;

  bool genderNeedsAgreement;
  Gender gender;

  bool ciNeedsAgreement;
  String ci;
  String ciAuthenticatedAt;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() => toJson().toString();
}

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
  NINTIES_AND_ABOVE
}

enum Gender {
  @JsonValue("female")
  FEMALE,
  @JsonValue("male")
  MALE,
  @JsonValue("other")
  OTHER
}
