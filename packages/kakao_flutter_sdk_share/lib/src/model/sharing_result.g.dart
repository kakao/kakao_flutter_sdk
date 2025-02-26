// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharingResult _$SharingResultFromJson(Map<String, dynamic> json) =>
    SharingResult(
      (json['template_id'] as num).toInt(),
      json['template_args'] as Map<String, dynamic>?,
      json['template_msg'] as Map<String, dynamic>,
      json['warning_msg'] as Map<String, dynamic>,
      json['argument_msg'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SharingResultToJson(SharingResult instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      if (instance.templateArgs case final value?) 'template_args': value,
      'template_msg': instance.templateMsg,
      'warning_msg': instance.warningMsg,
      'argument_msg': instance.argumentMsg,
    };
