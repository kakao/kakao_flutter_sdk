// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkResponse _$LinkResponseFromJson(Map<String, dynamic> json) {
  return LinkResponse(
      json['template_id'] as int,
      json['template_args'] as Map<String, dynamic>,
      json['template_msg'] as Map<String, dynamic>,
      json['warning_msg'] as Map<String, dynamic>,
      json['argument_msg'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LinkResponseToJson(LinkResponse instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'template_args': instance.templateArgs,
      'template_msg': instance.templateMsg,
      'warning_msg': instance.warningMsg,
      'argument_msg': instance.argumentMsg
    };
