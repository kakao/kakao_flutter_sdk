// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_relations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelRelations _$ChannelRelationsFromJson(Map<String, dynamic> json) {
  return ChannelRelations(
    json['user_id'] as int?,
    (json['channels'] as List<dynamic>)
        .map((e) => ChannelRelation.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChannelRelationsToJson(ChannelRelations instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  val['channels'] = instance.channels.map((e) => e.toJson()).toList();
  return val;
}
