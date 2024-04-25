import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope.dart';

part 'scope_info.g.dart';

/// KO: 사용자 동의 내역
/// <br>
/// EN: User consent history
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ScopeInfo {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  final int id;

  /// KO: 앱의 동의항목 목록
  /// <br>
  /// EN: List of scopes in the app
  final List<Scope>? scopes;

  /// @nodoc
  ScopeInfo(this.id, this.scopes);

  /// @nodoc
  factory ScopeInfo.fromJson(Map<String, dynamic> json) =>
      _$ScopeInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ScopeInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
