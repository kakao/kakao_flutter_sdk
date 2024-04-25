import 'package:kakao_flutter_sdk_common/src/kakao_api_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_auth_exception.dart';

// This is a copy of the enumMap created by the json_serializable package. Needs to be modified when values are added
const $ApiErrorCauseEnumMap = {
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

// This is a copy of the enumMap created by the json_serializable package. Needs to be modified when values are added
const $AuthErrorCauseEnumMap = {
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
