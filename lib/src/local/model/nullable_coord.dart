import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/local.dart';

part 'nullable_coord.g.dart';

@JsonSerializable(includeIfNull: false)
class NullableCoord {
  @JsonKey(fromJson: stringToNullableDouble)
  double? x;
  @JsonKey(fromJson: stringToNullableDouble)
  double? y;

  NullableCoord(this.x, this.y);

  /// <nodoc>
  factory NullableCoord.fromJson(Map<String, dynamic> json) =>
      _$NullableCoordFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$NullableCoordToJson(this);

  @override
  String toString() => toJson().toString();
}

// /// <nodoc>
// String doubleToString(double v) => v.toString();
