import 'package:json_annotation/json_annotation.dart';

part 'scope.g.dart';

/// KO: 동의항목 정보
/// <br>
/// EN: Scope information
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Scope {
  /// KO: 사용자 동의 화면에 출력되는 동의항목의 이름 또는 설명
  /// <br>
  /// EN: Name or description of the scope displayed on the Consent screen.
  final String id;

  /// KO: 사용자 동의 화면에 출력되는 동의항목의 이름 또는 설명
  /// <br>
  /// EN: Name or description of the scope displayed on the Consent screen.
  final String displayName;

  /// KO: 동의항목 타입(PRIVACY: 개인정보 보호 동의 항목 | SERVICE: 접근권한 관리 동의 항목)
  /// <br>
  /// EN: Type of the scope (PRIVACY: for personal information | SERVICE: for permission)
  final ScopeType type;

  /// KO: 동의항목 사용 여부
  /// <br>
  /// EN: Whether your app is using the scope
  final bool using;

  /// KO: 카카오가 관리하지 않는 위임 동의항목인지 여부, 현재 사용 중인 동의항목만 응답에 포함
  /// <br>
  /// EN: The consent status of the service terms
  final bool? delegated;

  /// KO: 동의 여부
  /// <br>
  /// EN: The consent status of the service terms
  final bool agreed;

  /// KO: 동의 철회 가능 여부
  /// <br>
  /// EN: Whether the scope can be revoked
  final bool? revocable;

  /// @nodoc
  Scope(this.id, this.displayName, this.type, this.using, this.delegated,
      this.agreed, this.revocable);

  /// @nodoc
  factory Scope.fromJson(Map<String, dynamic> json) => _$ScopeFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ScopeToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// KO: 동의항목 타입
/// <br>
/// EN: Scope type
enum ScopeType {
  /// KO: 개인정보 보호 동의항목
  /// <br>
  /// EN: Scope for personal information
  @JsonValue("PRIVACY")
  privacy,

  /// KO: 접근권한 관리 동의항목
  /// <br>
  /// EN: Scope for permission
  @JsonValue("SERVICE")
  service
}
