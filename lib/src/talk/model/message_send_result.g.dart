// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_send_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSendResult _$MessageSendResultFromJson(Map<String, dynamic> json) {
  return MessageSendResult(
    (json['successful_receiver_uuids'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    (json['failure_info'] as List)
        ?.map((e) => e == null
            ? null
            : MessageFailureInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MessageSendResultToJson(MessageSendResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('successful_receiver_uuids', instance.successfulReceiverUuids);
  writeNotNull(
      'failure_info', instance.failureInfos?.map((e) => e?.toJson())?.toList());
  return val;
}
