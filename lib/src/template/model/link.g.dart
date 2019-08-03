// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
    webUrl: json['web_url'] as String,
    mobileWebUrl: json['mobile_web_url'] as String,
    androidExecParams: json['android_params'] as String,
    iosExecParams: json['ios_params'] as String,
  );
}

Map<String, dynamic> _$LinkToJson(Link instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('web_url', instance.webUrl);
  writeNotNull('mobile_web_url', instance.mobileWebUrl);
  writeNotNull('android_params', instance.androidExecParams);
  writeNotNull('ios_params', instance.iosExecParams);
  return val;
}
