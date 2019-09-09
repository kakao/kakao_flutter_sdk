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

Map<String, dynamic> _$DapiExceptionToJson(DapiException instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('errorType', instance.errorType);
  writeNotNull('message', instance.message);
  return val;
}
