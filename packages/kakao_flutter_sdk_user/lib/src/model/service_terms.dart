import 'package:json_annotation/json_annotation.dart';

part 'service_terms.g.dart';

/// KO: 서비스 약관 정보
/// <br>
/// EN: Service terms information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ServiceTerms {
  /// KO: 태그
  /// <br>
  /// EN: Tag
  String tag;

  /// KO: 필수 동의 여부
  /// <br>
  /// EN: Whether consent is required
  bool required;

  /// KO: 동의 여부
  /// <br>
  /// EN: The consent status of the service terms
  bool agreed;

  /// KO: 철회 가능 여부
  /// <br>
  /// EN: Whether consent is revocable
  bool revocable;

  /// KO: 마지막으로 동의한 시간
  /// <br>
  /// EN: The last time the user agreed to the scope
  DateTime? agreedAt;

  /// KO: 서비스 약관의 동의 경로
  /// <br>
  /// EN: Path through which the service terms were agreed to
  @JsonKey(name: 'agreed_by', unknownEnumValue: Referer.unknown)
  Referer? referer;

  /// @nodoc
  ServiceTerms(this.tag, this.required, this.agreed, this.revocable,
      this.agreedAt, this.referer);

  /// @nodoc
  factory ServiceTerms.fromJson(Map<String, dynamic> json) =>
      _$ServiceTermsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ServiceTermsToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// KO: 서비스 약관의 동의 경로
/// <br>
/// EN: Path through which the service terms were agreed to
enum Referer {
  /// KO: 카카오싱크 간편가입 동의 화면
  /// <br>
  /// EN: Consent screen of Kakao Sync Simple Signup
  @JsonValue('KAUTH')
  kauth,

  /// KO: 기타
  /// <br>
  /// EN: Other paths
  @JsonValue('KAPI')
  kapi,

  /// KO: 알 수 없음
  /// <br>
  /// EN: Unknown
  unknown
}
