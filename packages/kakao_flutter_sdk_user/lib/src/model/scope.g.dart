// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scope _$ScopeFromJson(Map<String, dynamic> json) => Scope(
      json['id'] as String,
      json['display_name'] as String,
      $enumDecode(_$ScopeTypeEnumMap, json['type'],
          unknownValue: ScopeType.unknown),
      json['using'] as bool,
      json['delegated'] as bool?,
      json['agreed'] as bool,
      json['revocable'] as bool?,
    );

Map<String, dynamic> _$ScopeToJson(Scope instance) => <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'type': _$ScopeTypeEnumMap[instance.type]!,
      'using': instance.using,
      if (instance.delegated case final value?) 'delegated': value,
      'agreed': instance.agreed,
      if (instance.revocable case final value?) 'revocable': value,
    };

const _$ScopeTypeEnumMap = {
  ScopeType.privacy: 'PRIVACY',
  ScopeType.service: 'SERVICE',
  ScopeType.unknown: 'unknown',
};
