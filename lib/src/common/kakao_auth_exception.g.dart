// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_auth_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoAuthException _$KakaoAuthExceptionFromJson(Map<String, dynamic> json) {
  return KakaoAuthException(
    _$enumDecodeNullable(_$AuthErrorCauseEnumMap, json['error'],
        unknownValue: AuthErrorCause.UNKNOWN),
    json['error_description'] as String,
  );
}

Map<String, dynamic> _$KakaoAuthExceptionToJson(KakaoAuthException instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('error', _$AuthErrorCauseEnumMap[instance.error]);
  writeNotNull('error_description', instance.errorDescription);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
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
