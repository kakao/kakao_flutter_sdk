// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['name'] as String,
    json['x'] as String,
    json['y'] as String,
    json['rpflag'] as String?,
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
