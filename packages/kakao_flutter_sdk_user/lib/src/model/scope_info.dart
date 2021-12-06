import 'package:kakao_flutter_sdk_auth/auth.dart';
import 'package:kakao_flutter_sdk_user/src/model/scope.dart';

part 'scope_info.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ScopeInfo {
  /// 회원번호
  final int id;

  /// 해당 앱의 동의 항목 목록
  final List<Scope>? scopes;

  /// @nodoc
  ScopeInfo(this.id, this.scopes);

  /// @nodoc
  factory ScopeInfo.fromJson(Map<String, dynamic> json) =>
      _$ScopeInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ScopeInfoToJson(this);
}
