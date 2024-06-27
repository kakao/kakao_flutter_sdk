// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_api_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoApiException _$KakaoApiExceptionFromJson(Map<String, dynamic> json) =>
    KakaoApiException(
      $enumDecode(_$ApiErrorCauseEnumMap, json['code'],
          unknownValue: ApiErrorCause.unknown),
      json['msg'] as String,
      apiType: json['api_type'] as String?,
      requiredScopes: (json['required_scopes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allowedScopes: (json['allowed_scopes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$KakaoApiExceptionToJson(KakaoApiException instance) {
  final val = <String, dynamic>{
    'code': _$ApiErrorCauseEnumMap[instance.code]!,
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

const _$ApiErrorCauseEnumMap = {
  ApiErrorCause.internalError: -1,
  ApiErrorCause.illegalParams: -2,
  ApiErrorCause.unsupportedApi: -3,
  ApiErrorCause.blockedAction: -4,
  ApiErrorCause.accessDenied: -5,
  ApiErrorCause.deprecatedApi: -9,
  ApiErrorCause.apiLimitExceeded: -10,
  ApiErrorCause.notRegisteredUser: -101,
  ApiErrorCause.alreadyRegisteredUser: -102,
  ApiErrorCause.accountDoesNotExist: -103,
  ApiErrorCause.propertyKeyDoesNotExist: -201,
  ApiErrorCause.appDoesNotExist: -301,
  ApiErrorCause.invalidToken: -401,
  ApiErrorCause.insufficientScope: -402,
  ApiErrorCause.requiredAgeVerification: -405,
  ApiErrorCause.underAgeLimit: -406,
  ApiErrorCause.notTalkUser: -501,
  ApiErrorCause.notFriend: -502,
  ApiErrorCause.userDeviceUnsupported: -504,
  ApiErrorCause.talkMessageDisabled: -530,
  ApiErrorCause.talkSendMessageMonthlyLimitExceed: -531,
  ApiErrorCause.talkSendMessageDailyLimitExceed: -532,
  ApiErrorCause.imageUploadSizeExceeded: -602,
  ApiErrorCause.serverTimeOut: -603,
  ApiErrorCause.imageMaxUploadCountExceed: -606,
  ApiErrorCause.developerDoesNotExist: -903,
  ApiErrorCause.underMaintenance: -9798,
  ApiErrorCause.unknown: 'unknown',
};
