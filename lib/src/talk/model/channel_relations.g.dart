// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_relations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelRelations _$ChannelRelationsFromJson(Map<String, dynamic> json) {
  return ChannelRelations(
    json['user_id'] as int,
    (json['plus_friends'] as List<dynamic>)
        .map((e) => ChannelRelation.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChannelRelationsToJson(ChannelRelations instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'plus_friends': instance.channels.map((e) => e.toJson()).toList(),
    };
