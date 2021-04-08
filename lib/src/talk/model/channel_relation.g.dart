// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelRelation _$ChannelRelationFromJson(Map<String, dynamic> json) {
  return ChannelRelation(
    json['plus_friend_uuid'] as String,
    json['plus_friend_public_id'] as String,
    json['relation'] as String,
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ChannelRelationToJson(ChannelRelation instance) {
  final val = <String, dynamic>{
    'plus_friend_uuid': instance.uuid,
    'plus_friend_public_id': instance.publicId,
    'relation': instance.relation,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
