// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScopeInfo _$ScopeInfoFromJson(Map<String, dynamic> json) {
  return ScopeInfo(
    json['id'] as int,
    (json['scopes'] as List<dynamic>?)
        ?.map((e) => Scope.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ScopeInfoToJson(ScopeInfo instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('scopes', instance.scopes?.map((e) => e.toJson()).toList());
  return val;
}
