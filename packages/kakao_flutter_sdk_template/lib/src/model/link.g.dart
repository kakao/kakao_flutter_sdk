// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
  webUrl: json['web_url'] == null ? null : Uri.parse(json['web_url'] as String),
  mobileWebUrl: json['mobile_web_url'] == null
      ? null
      : Uri.parse(json['mobile_web_url'] as String),
  androidExecutionParams: Link._queryStringToMap(
    json['android_execution_params'] as String?,
  ),
  iosExecutionParams: Link._queryStringToMap(
    json['ios_execution_params'] as String?,
  ),
);

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
  'web_url': ?instance.webUrl?.toString(),
  'mobile_web_url': ?instance.mobileWebUrl?.toString(),
  'android_execution_params': ?Link._mapToQueryString(
    instance.androidExecutionParams,
  ),
  'ios_execution_params': ?Link._mapToQueryString(instance.iosExecutionParams),
};
