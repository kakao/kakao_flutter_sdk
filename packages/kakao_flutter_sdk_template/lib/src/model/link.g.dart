// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
    webUrl:
        json['web_url'] == null ? null : Uri.parse(json['web_url'] as String),
    mobileWebUrl: json['mobile_web_url'] == null
        ? null
        : Uri.parse(json['mobile_web_url'] as String),
    androidExecutionParams:
        Util.stringToMap(json['android_execution_params'] as String?),
    iosExecutionParams:
        Util.stringToMap(json['ios_execution_params'] as String?),
  );
}

Map<String, dynamic> _$LinkToJson(Link instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('web_url', instance.webUrl?.toString());
  writeNotNull('mobile_web_url', instance.mobileWebUrl?.toString());
  writeNotNull('android_execution_params',
      Util.mapToString(instance.androidExecutionParams));
  writeNotNull(
      'ios_execution_params', Util.mapToString(instance.iosExecutionParams));
  return val;
}
