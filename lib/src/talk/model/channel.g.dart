// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    json['channel_uuid'] as String,
    json['channel_public_id'] as String,
    json['relation'] as String,
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) {
  final val = <String, dynamic>{
    'channel_uuid': instance.uuid,
    'channel_public_id': instance.encodedId,
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
