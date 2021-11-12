// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channels _$ChannelsFromJson(Map<String, dynamic> json) {
  return Channels(
    json['user_id'] as int?,
    (json['channels'] as List<dynamic>?)
        ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChannelsToJson(Channels instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('channels', instance.channels?.map((e) => e.toJson()).toList());
  return val;
}
