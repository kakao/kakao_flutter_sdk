## 0.4.2

- Add `synched_at` and `connected_at` to `User` class.
- Add `DEPRECATED_API` enum to `ApiErrorCause` enum class.

## 0.4.1

- Fix `No Valid SDK` error on `pub.dev`, which lowers maintenance score.

## 0.4.0

- Fix bug in LocationTemplate json write logic
- Prepare for flutter web support

## 0.3.2

- Talk Channel SDK

## 0.3.1

- Minor fixes
- fix wrong json keys for `androidExecParams` and `iosExecParms` in `Link` class of `template` module.

## 0.3.0

- Release according to recent Kakao API udpate.
- Add message send API to `TalkApi`. Also update `Friend` model to include `uuid` and `favorite` field.
- Add live account profile data to `Account` and `groupUserToken` field to `User`.

## 0.2.3

- Provide `presentationContextProvider` to `ASWebAuthenticationSession` in login. (fix for iOS13.0)
- Make `isRetryable` method of `AccessTokenInterceptor` public so that the interceptor can be used in a customized way. Third-party can override this method for their own API client if `Authorization` header matches the format `Bearer ${kakao_access_token}` for their API (which is a very uncommon need).

## 0.2.2

- Update `dio` package to `3.0.0` and fix compile errors due to interface changes. Changes that were merged in 2.2.1 were ported to 3.0.0, presumably to ensure version compatibility in ^2.2.x.

## 0.2.1

- Stabilize agains flutter `1.9.1`.
- Update `dio` package to `2.2.1` and fix compile errors due to interface changes.

## 0.2.0

- SDK for Kakao Search API
- SDK for Kakao Local API
- Set secure_resource to true for /v2/user/me API.

## 0.1.2

- Remove meta package from expliciit dependency.

## 0.1.1

- Update description field in `pubspec.yaml` to be longer than 60 characters.
- Update `meta` package version from `1.1.6` to `1.1.7`.

## 0.1.0

- Kakao Flutter SDK Initial Release
