import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/user/model/scope.dart';

part 'scope_info.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class ScopeInfo {
  final int id;
  final List<Scope>? scopes;

  /// <nodoc>
  ScopeInfo(this.id, this.scopes);

  /// <nodoc>
  factory ScopeInfo.fromJson(Map<String, dynamic> json) =>
      _$ScopeInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ScopeInfoToJson(this);
}
