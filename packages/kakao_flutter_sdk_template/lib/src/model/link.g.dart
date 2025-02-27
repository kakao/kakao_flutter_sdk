// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
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

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      if (instance.webUrl?.toString() case final value?) 'web_url': value,
      if (instance.mobileWebUrl?.toString() case final value?)
        'mobile_web_url': value,
      if (Util.mapToString(instance.androidExecutionParams) case final value?)
        'android_execution_params': value,
      if (Util.mapToString(instance.iosExecutionParams) case final value?)
        'ios_execution_params': value,
    };
