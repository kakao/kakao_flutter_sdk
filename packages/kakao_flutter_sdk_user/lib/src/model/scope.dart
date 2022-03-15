import 'package:json_annotation/json_annotation.dart';

part 'scope.g.dart';

/// 동의 항목별 정보
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Scope {
  /// 동의항목 ID
  final String id;

  /// 사용자 동의 화면에 출력되는 동의 항목 이름 또는 설명
  final String displayName;

  /// 동의 항목 타입 PRIVACY(개인정보 보호 동의 항목) / SERVICE(접근권한 관리 동의 항목) 중 하나
  final ScopeType type;

  /// 동의 항목의 현재 사용 여부. 사용자가 동의했으나 현재 앱에 설정되어 있지 않은 동의 항목의 경우 false
  final bool using;

  /// 카카오가 관리하지 않는 위임 동의 항목인지 여부. 현재 사용 중인 동의 항목이고, 위임 동의 항목인 경우에만 응답에 포함
  final bool? delegated;

  /// 사용자 동의 여부
  final bool agreed;

  /// 동의 항목의 동의 철회 가능 여부
  /// 사용자가 동의한 동의 항목인 경우에만 응답에 포함
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

/// 동의 항목 타입
enum ScopeType {
  /// 개인정보 보호 동의 항목
  @JsonValue("PRIVACY")
  privacy,

  /// 접근권한 관리 동의 항목
  @JsonValue("SERVICE")
  service
}
