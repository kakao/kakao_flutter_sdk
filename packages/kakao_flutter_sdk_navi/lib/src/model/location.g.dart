// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    name: json['name'] as String,
    x: json['x'] as String,
    y: json['y'] as String,
    rpFlag: json['rpflag'] as String?,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'x': instance.x,
    'y': instance.y,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('rpflag', instance.rpFlag);
  return val;
}
