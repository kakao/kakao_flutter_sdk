// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      x: json['x'] as String,
      y: json['y'] as String,
      rpFlag: json['rpflag'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      if (instance.rpFlag case final value?) 'rpflag': value,
    };
