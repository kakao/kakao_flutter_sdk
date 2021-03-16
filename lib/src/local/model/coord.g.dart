// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coord _$CoordFromJson(Map<String, dynamic> json) {
  return Coord(
    stringToDouble(json['x']),
    stringToDouble(json['y']),
  );
}

Map<String, dynamic> _$CoordToJson(Coord instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
