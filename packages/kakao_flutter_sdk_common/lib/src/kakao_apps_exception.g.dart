// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_apps_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoAppsException _$KakaoAppsExceptionFromJson(Map<String, dynamic> json) =>
    KakaoAppsException(
      $enumDecode(_$AppsErrorCauseEnumMap, json['error_code'],
          unknownValue: AppsErrorCause.unknown),
      json['error_msg'] as String,
    );

Map<String, dynamic> _$KakaoAppsExceptionToJson(KakaoAppsException instance) =>
    <String, dynamic>{
      'error_code': _$AppsErrorCauseEnumMap[instance.code]!,
      'error_msg': instance.msg,
    };

const _$AppsErrorCauseEnumMap = {
  AppsErrorCause.internalServerError: 'KAE001',
  AppsErrorCause.invalidRequest: 'KAE002',
  AppsErrorCause.invalidParameter: 'KAE003',
  AppsErrorCause.timeExpired: 'KAE004',
  AppsErrorCause.invalidChannel: 'KAE005',
  AppsErrorCause.illegalStateChannel: 'KAE006',
  AppsErrorCause.unsupported: 'KAE007',
  AppsErrorCause.appTypeError: 'KAE101',
  AppsErrorCause.appScopeError: 'KAE102',
  AppsErrorCause.permissionError: 'KAE103',
  AppsErrorCause.appKeyTypeError: 'KAE104',
  AppsErrorCause.appChannelNotConnected: 'KAE105',
  AppsErrorCause.authError: 'KAE201',
  AppsErrorCause.notRegisteredUser: 'KAE202',
  AppsErrorCause.invalidScope: 'KAE203',
  AppsErrorCause.accountTermsError: 'KAE204',
  AppsErrorCause.loginRequired: 'KAE205',
  AppsErrorCause.invalidShippingAddressId: 'KAE206',
  AppsErrorCause.unknown: 'unknown',
};
