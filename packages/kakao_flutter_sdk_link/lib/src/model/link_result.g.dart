// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkResult _$LinkResultFromJson(Map<String, dynamic> json) {
  return LinkResult(
    json['template_id'] as int,
    json['template_args'] as Map<String, dynamic>?,
    json['template_msg'] as Map<String, dynamic>,
    json['warning_msg'] as Map<String, dynamic>,
    json['argument_msg'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$LinkResultToJson(LinkResult instance) {
  final val = <String, dynamic>{
    'template_id': instance.templateId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('template_args', instance.templateArgs);
  val['template_msg'] = instance.templateMsg;
  val['warning_msg'] = instance.warningMsg;
  val['argument_msg'] = instance.argumentMsg;
  return val;
}
