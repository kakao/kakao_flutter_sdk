// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_failure_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageFailureInfo _$MessageFailureInfoFromJson(Map<String, dynamic> json) {
  return MessageFailureInfo(
    json['code'] as int,
    json['msg'] as String,
    (json['receiver_uuids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$MessageFailureInfoToJson(MessageFailureInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('msg', instance.msg);
  writeNotNull('receiver_uuids', instance.receiverUuids);
  return val;
}
