// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapi_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DapiException _$DapiExceptionFromJson(Map<String, dynamic> json) {
  return DapiException(
    json['errorType'] as String,
    json['message'] as String,
  );
}

Map<String, dynamic> _$DapiExceptionToJson(DapiException instance) =>
    <String, dynamic>{
      'errorType': instance.errorType,
      'message': instance.message,
    };
