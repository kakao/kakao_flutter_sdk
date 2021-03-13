import 'package:json_annotation/json_annotation.dart';

part 'coord.g.dart';

@JsonSerializable(includeIfNull: false)
class Coord {
  @JsonKey(fromJson: stringToDouble)
  double x;
  @JsonKey(fromJson: stringToDouble)
  double y;

  Coord(this.x, this.y);

  /// <nodoc>
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$CoordToJson(this);

  @override
  String toString() => toJson().toString();
}

/// <nodoc>
double? stringToNullableDouble<T>(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  return double.tryParse(v);
}

/// <nodoc>
double stringToDouble<T>(dynamic v) {
  return stringToNullableDouble(v) ?? 0;
}

// <nodoc>
int? stringToNullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v);
}

// <nodoc>
int stringToInt(dynamic v) {
  return stringToNullableInt(v) ?? 0;
}

// /// <nodoc>
// String doubleToString(double v) => v.toString();

enum CoordType { WGS84, WCONGNAMUL, CONGNAMUL, WTM, TM }
