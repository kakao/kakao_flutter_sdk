// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scope _$ScopeFromJson(Map<String, dynamic> json) => Scope(
      json['id'] as String,
      json['display_name'] as String,
      $enumDecode(_$ScopeTypeEnumMap, json['type']),
      json['using'] as bool,
      json['delegated'] as bool?,
      json['agreed'] as bool,
      json['revocable'] as bool?,
    );

Map<String, dynamic> _$ScopeToJson(Scope instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'display_name': instance.displayName,
    'type': _$ScopeTypeEnumMap[instance.type]!,
    'using': instance.using,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('delegated', instance.delegated);
  val['agreed'] = instance.agreed;
  writeNotNull('revocable', instance.revocable);
  return val;
}

const _$ScopeTypeEnumMap = {
  ScopeType.privacy: 'PRIVACY',
  ScopeType.service: 'SERVICE',
};
