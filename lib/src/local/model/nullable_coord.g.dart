// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nullable_coord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NullableCoord _$NullableCoordFromJson(Map<String, dynamic> json) {
  return NullableCoord(
    stringToNullableDouble(json['x']),
    stringToNullableDouble(json['y']),
  );
}

Map<String, dynamic> _$NullableCoordToJson(NullableCoord instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  return val;
}
