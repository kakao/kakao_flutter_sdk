// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_failure_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageFailureInfo _$MessageFailureInfoFromJson(Map<String, dynamic> json) =>
    MessageFailureInfo(
      (json['code'] as num).toInt(),
      json['msg'] as String,
      (json['receiver_uuids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MessageFailureInfoToJson(MessageFailureInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'receiver_uuids': instance.receiverUuids,
    };
