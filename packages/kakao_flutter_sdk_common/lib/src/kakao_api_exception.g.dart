// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_api_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoApiException _$KakaoApiExceptionFromJson(Map<String, dynamic> json) {
  return KakaoApiException(
    _$enumDecode(_$ApiErrorCauseEnumMap, json['code'],
        unknownValue: ApiErrorCause.UNKNOWN),
    json['msg'] as String,
    apiType: json['api_type'] as String?,
    requiredScopes: (json['required_scopes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    allowedScopes: (json['allowed_scopes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$KakaoApiExceptionToJson(KakaoApiException instance) {
  final val = <String, dynamic>{
    'code': _$ApiErrorCauseEnumMap[instance.code],
    'msg': instance.msg,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('api_type', instance.apiType);
  writeNotNull('required_scopes', instance.requiredScopes);
  writeNotNull('allowed_scopes', instance.allowedScopes);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ApiErrorCauseEnumMap = {
  ApiErrorCause.INTERNAL_ERROR: -1,
  ApiErrorCause.ILLEGAL_PARAMS: -2,
  ApiErrorCause.UNSUPPORTED_API: -3,
  ApiErrorCause.BLOCKED_ACTION: -4,
  ApiErrorCause.ACCESS_DENIED: -5,
  ApiErrorCause.DEPRECATED_API: -9,
  ApiErrorCause.API_LIMIT_EXCEEDED: -10,
  ApiErrorCause.NOT_REGISTERED_USER: -101,
  ApiErrorCause.ALREADY_REGISTERD_USER: -102,
  ApiErrorCause.ACCOUNT_DOES_NOT_EXIST: -103,
  ApiErrorCause.PROPERTY_KEY_DOES_NOT_EXIST: -201,
  ApiErrorCause.APP_DOES_NOT_EXIST: -301,
  ApiErrorCause.INVALID_TOKEN: -401,
  ApiErrorCause.INSUFFICIENT_SCOPE: -402,
  ApiErrorCause.INVALID_ORIGIN: -403,
  ApiErrorCause.REQUIRED_AGE_VERIFICATION: -405,
  ApiErrorCause.UNDER_AGE_LIMIT: -406,
  ApiErrorCause.NOT_TALK_USER: -501,
  ApiErrorCause.NOT_FRIEND: -502,
  ApiErrorCause.USER_DEVICE_UNSUPPORTED: -504,
  ApiErrorCause.TALK_MESSAGE_DISABLED: -530,
  ApiErrorCause.TALK_SEND_MESSAGE_MONTHLY_LIMIT_EXCEED: -531,
  ApiErrorCause.TALK_SEND_MESSAGE_DAILY_LIMIT_EXCEED: -532,
  ApiErrorCause.NOT_STORY_USER: -601,
  ApiErrorCause.STORY_IMAGE_UPOLOAD_SIZE_EXCEEDED: -602,
  ApiErrorCause.TIME_OUT: -603,
  ApiErrorCause.STORY_INVALID_SCRAP_URL: -604,
  ApiErrorCause.STROY_INVALID_POST_ID: -605,
  ApiErrorCause.STORY_MAX_UPLOAD_COUNT_EXCEED: -606,
  ApiErrorCause.DEVELOPER_DOES_NOT_EXIST: -903,
  ApiErrorCause.UNDER_MAINTENANCE: -9798,
  ApiErrorCause.UNKNOWN: 'UNKNOWN',
};
