import 'package:json_annotation/json_annotation.dart';

part 'scope.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Scope {
  final String id;
  final String displayName;
  final ScopeType type;
  final bool using;
  final bool? delegated;
  final bool agreed;
  final bool? revocable;

  /// <nodoc>
  Scope(this.id, this.displayName, this.type, this.using, this.delegated,
      this.agreed, this.revocable);

  /// <nodoc>
  factory Scope.fromJson(Map<String, dynamic> json) => _$ScopeFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$ScopeToJson(this);
}

enum ScopeType { PRIVACY, SERVICE }
