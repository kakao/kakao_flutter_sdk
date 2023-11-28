// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_channel_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowChannelResult _$FollowChannelResultFromJson(Map<String, dynamic> json) =>
    FollowChannelResult(
      const StatusConverter().fromJson(json['status'] as String),
      json['channel_public_id'] as String,
    );

Map<String, dynamic> _$FollowChannelResultToJson(
        FollowChannelResult instance) =>
    <String, dynamic>{
      'status': const StatusConverter().toJson(instance.success),
      'channel_public_id': instance.channelPublicId,
    };
