import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/profile.dart';

part 'account.g.dart';

/// KO: 카카오계정 정보
/// <br>
/// EN: Kakao Account information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Account {
  /// KO: 사용자 동의 시 프로필 제공 가능 여부
  /// <br>
  /// EN: Whether [profile] can be provided under user consent
  bool? profileNeedsAgreement;

  /// KO: 사용자 동의 시 닉네임 제공 가능 여부
  /// <br>
  /// EN: Whether [Profile.nickname] can be provided under user consent
  bool? profileNicknameNeedsAgreement;

  /// KO: 사용자 동의 시 프로필 사진 제공 가능 여부
  /// <br>
  /// EN: Whether [Profile.profileImageUrl] can be provided under user consent
  bool? profileImageNeedsAgreement;

  /// KO: 프로필 정보
  /// <br>
  /// EN: Profile information
  Profile? profile;

  /// KO: 사용자 동의 시 이름 제공 가능 여부
  /// <br>
  /// EN: Whether [name] can be provided under user consent
  bool? nameNeedsAgreement;

  /// KO: 카카오계정 이름
  /// <br>
  /// EN: Name of Kakao Account
  String? name;

  /// KO: 사용자 동의 시 카카오계정 대표 이메일 제공 가능 여부
  /// <br>
  /// EN: Whether email can be provided under user consent
  bool? emailNeedsAgreement;

  /// KO: 이메일 유효 여부
  /// <br>
  /// EN: Whether email address is valid
  bool? isEmailValid;

  /// KO: 이메일 인증 여부
  /// <br>
  /// EN: Whether email address is verified
  bool? isEmailVerified;

  /// KO: 카카오계정 대표 이메일
  /// <br>
  /// EN: Representative email of Kakao Account
  String? email;

  /// KO: 사용자 동의 시 연령대 제공 가능 여부
  /// <br>
  /// EN: Whether age range can be provided under user consent
  bool? ageRangeNeedsAgreement;

  /// KO: 연령대
  /// <br>
  /// EN: Age range
  @JsonKey(unknownEnumValue: AgeRange.unknown)
  AgeRange? ageRange;

  /// KO: 사용자 동의 시 출생 연도 제공 가능 여부
  /// <br>
  /// EN: Whether birthyear can be provided under user consent
  bool? birthyearNeedsAgreement;

  /// KO: 출생 연도, YYYY 형식
  /// <br>
  /// EN: Birthyear in YYYY format
  String? birthyear;

  /// KO: 사용자 동의 시 생일 제공 가능 여부
  /// <br>
  /// EN: Whether birthday can be provided under user consent
  bool? birthdayNeedsAgreement;

  /// KO: 생일, MMDD 형식
  /// <br>
  /// EN: Birthday in MMDD format
  String? birthday;

  /// KO: 생일 타입
  /// <br>
  /// EN: Birthday type
  @JsonKey(unknownEnumValue: BirthdayType.unknown)
  BirthdayType? birthdayType;

  /// KO: 사용자 동의 시 성별 제공 가능 여부
  /// <br>
  /// EN: Whether gender can be provided under user consent
  bool? genderNeedsAgreement;

  /// KO: 성별
  /// <br>
  /// EN: Gender
  @JsonKey(unknownEnumValue: Gender.other)
  Gender? gender;

  /// KO: 사용자 동의 시 CI 참고 가능 여부
  /// <br>
  /// EN: Whether CI for a reference can be provided under user consent
  bool? ciNeedsAgreement;

  /// KO: 연계정보
  /// <br>
  /// EN: Connecting Information(CI)
  String? ci;

  /// KO: CI 발급시간
  /// <br>
  /// EN: CI issuance time
  DateTime? ciAuthenticatedAt;

  /// KO: 사용자 동의 시 실명 제공 가능 여부
  /// <br>
  /// EN: Whether [legalName] can be provided under user consent
  bool? legalNameNeedsAgreement;

  /// KO: 실명
  /// <br>
  /// EN: Legal name
  String? legalName;

  /// KO: 사용자 동의 시 법정 생년월일 제공 가능 여부
  /// <br>
  /// EN: Whether [isKorean] can be provided under user consent
  bool? legalBirthDateNeedsAgreement;

  /// KO: 법정 생년월일, yyyyMMDD 형식
  /// <br>
  /// EN: Legal birth date in yyyyMMDD format
  String? legalBirthDate;

  /// KO: 사용자 동의 시 법정 성별 제공 가능 여부
  /// <br>
  /// EN: Whether [legalGender] can be provided under user consent
  bool? legalGenderNeedsAgreement;

  /// KO: 법정 성별
  /// <br>
  /// EN: Legal gender
  @JsonKey(unknownEnumValue: Gender.other)
  Gender? legalGender;

  /// KO: 사용자 동의 시 전화번호 제공 가능 여부
  /// <br>
  /// EN: Whether [phoneNumber] can be provided under user consent
  bool? phoneNumberNeedsAgreement;

  /// KO: 카카오계정의 전화번호
  /// <br>
  /// EN: Phone number of Kakao Account
  String? phoneNumber;

  /// KO: 사용자 동의 시 내외국인 제공 가능 여부
  /// <br>
  /// EN: Whther isKorean can be provided under user consent
  bool? isKoreanNeedsAgreement;

  /// KO: 본인인증을 거친 내국인 여부
  /// <br>
  /// EN: Whether the user is Korean
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

/// KO: 연령대
/// <br>
/// EN: Age range
enum AgeRange {
  /// KO: 0세~9세
  /// <br>
  /// EN: 0 to 9 years old
  @JsonValue("0~9")
  age_0_9,

  /// KO: 10세~14세
  /// <br>
  /// EN: 10 to 14 years old
  @JsonValue("10~14")
  age_10_14,

  /// KO: 15세~19세
  /// <br>
  /// EN: 15 to 19 years old
  @JsonValue("15~19")
  age_15_19,

  /// KO: 20세~29세
  /// <br>
  /// EN: 20 to 29 years old
  @JsonValue("20~29")
  age_20_29,

  /// KO: 30세~39세
  /// <br>
  /// EN: 30 to 39 years old
  @JsonValue("30~39")
  age_30_39,

  /// KO: 40세~49세
  /// <br>
  /// EN: 40 to 49 years old
  @JsonValue("40~49")
  age_40_49,

  /// KO: 50세~59세
  /// <br>
  /// EN: 50 to 59 years old
  @JsonValue("50~59")
  age_50_59,

  /// KO: 60세~69세
  /// <br>
  /// EN: 60 to 69 years old
  @JsonValue("60~69")
  age_60_69,

  /// KO: 70세~79세
  /// <br>
  /// EN: 70 to 79 years old
  @JsonValue("70~79")
  age_70_79,

  /// KO: 80세~89세
  /// <br>
  /// EN: 80 to 89 years old
  @JsonValue("80~89")
  age_80_89,

  /// KO: 90세 이상
  /// <br>
  /// EN: Over 90 years old
  @JsonValue("90~")
  age_90above,
  unknown
}

/// KO: 성별
/// <br>
/// EN: Gender
enum Gender {
  /// KO: 여자
  /// <br>
  /// EN: Female
  female,

  /// KO: 남자
  /// <br>
  /// EN: Male
  male,
  other
}

/// KO: 생일 타입
/// <br>
/// EN: Birthday type
enum BirthdayType {
  /// KO: 양력
  /// <br>
  /// EN: Solar
  @JsonValue("SOLAR")
  solar,

  /// KO: 음력
  /// <br>
  /// EN: Lunar
  @JsonValue("LUNAR")
  lunar,
  unknown
}
