// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_auth_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoAuthException _$KakaoAuthExceptionFromJson(Map<String, dynamic> json) {
  return KakaoAuthException(
    _$enumDecode(_$AuthErrorCauseEnumMap, json['error'],
        unknownValue: AuthErrorCause.UNKNOWN),
    json['error_description'] as String?,
  );
}

Map<String, dynamic> _$KakaoAuthExceptionToJson(KakaoAuthException instance) {
  final val = <String, dynamic>{
    'error': _$AuthErrorCauseEnumMap[instance.error],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('error_description', instance.errorDescription);
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

const _$AuthErrorCauseEnumMap = {
  AuthErrorCause.INVALID_REQUEST: 'invalid_request',
  AuthErrorCause.INVALID_SCOPE: 'invalid_scope',
  AuthErrorCause.INVALID_GRANT: 'invalid_grant',
  AuthErrorCause.MISCONFIGURED: 'misconfigured',
  AuthErrorCause.UNAUTHORIZED: 'unauthorized',
  AuthErrorCause.ACCESS_DENIED: 'access_denied',
  AuthErrorCause.SERVER_ERROR: 'server_error',
  AuthErrorCause.UNKNOWN: 'UNKNOWN',
};
