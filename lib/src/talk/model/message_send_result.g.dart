// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_send_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSendResult _$MessageSendResultFromJson(Map<String, dynamic> json) {
  return MessageSendResult(
    (json['successful_receiver_uuids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    (json['failure_info'] as List<dynamic>)
        .map((e) => MessageFailureInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MessageSendResultToJson(MessageSendResult instance) =>
    <String, dynamic>{
      'successful_receiver_uuids': instance.successfulReceiverUuids,
      'failure_info': instance.failureInfos.map((e) => e.toJson()).toList(),
    };
