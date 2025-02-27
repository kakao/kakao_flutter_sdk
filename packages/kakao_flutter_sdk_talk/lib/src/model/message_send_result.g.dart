// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_send_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSendResult _$MessageSendResultFromJson(Map<String, dynamic> json) =>
    MessageSendResult(
      (json['successful_receiver_uuids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      (json['failure_info'] as List<dynamic>?)
          ?.map((e) => MessageFailureInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageSendResultToJson(MessageSendResult instance) =>
    <String, dynamic>{
      if (instance.successfulReceiverUuids case final value?)
        'successful_receiver_uuids': value,
      if (instance.failureInfos?.map((e) => e.toJson()).toList()
          case final value?)
        'failure_info': value,
    };
