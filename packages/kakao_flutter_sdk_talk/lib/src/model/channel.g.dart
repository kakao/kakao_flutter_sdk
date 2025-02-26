// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      json['channel_uuid'] as String,
      json['channel_public_id'] as String,
      json['relation'] as String,
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'channel_uuid': instance.uuid,
      'channel_public_id': instance.encodedId,
      'relation': instance.relation,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };
