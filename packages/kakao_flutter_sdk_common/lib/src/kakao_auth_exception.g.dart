// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_auth_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoAuthException _$KakaoAuthExceptionFromJson(Map<String, dynamic> json) =>
    KakaoAuthException(
      $enumDecode(_$AuthErrorCauseEnumMap, json['error'],
          unknownValue: AuthErrorCause.unknown),
      json['error_description'] as String?,
    );

Map<String, dynamic> _$KakaoAuthExceptionToJson(KakaoAuthException instance) =>
    <String, dynamic>{
      'error': _$AuthErrorCauseEnumMap[instance.error]!,
      if (instance.errorDescription case final value?)
        'error_description': value,
    };

const _$AuthErrorCauseEnumMap = {
  AuthErrorCause.invalidRequest: 'invalid_request',
  AuthErrorCause.invalidClient: 'invalid_client',
  AuthErrorCause.invalidScope: 'invalid_scope',
  AuthErrorCause.invalidGrant: 'invalid_grant',
  AuthErrorCause.misconfigured: 'misconfigured',
  AuthErrorCause.unauthorized: 'unauthorized',
  AuthErrorCause.accessDenied: 'access_denied',
  AuthErrorCause.serverError: 'server_error',
  AuthErrorCause.unknown: 'unknown',
};
