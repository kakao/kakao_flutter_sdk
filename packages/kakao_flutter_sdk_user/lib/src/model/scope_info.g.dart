// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScopeInfo _$ScopeInfoFromJson(Map<String, dynamic> json) => ScopeInfo(
      (json['id'] as num).toInt(),
      (json['scopes'] as List<dynamic>?)
          ?.map((e) => Scope.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScopeInfoToJson(ScopeInfo instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.scopes?.map((e) => e.toJson()).toList() case final value?)
        'scopes': value,
    };
