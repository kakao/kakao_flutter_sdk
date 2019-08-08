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
    json['argument_msg'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$LinkResponseToJson(LinkResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('template_id', instance.templateId);
  writeNotNull('template_args', instance.templateArgs);
  writeNotNull('template_msg', instance.templateMsg);
  writeNotNull('warning_msg', instance.warningMsg);
  writeNotNull('argument_msg', instance.argumentMsg);
  return val;
}
