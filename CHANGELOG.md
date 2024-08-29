## 1.9.6

- Changed the minimum support version of Flutter to 3.22.0 or higher.
- Changed the minimum support version of Dart to 3.4.0 or higher.
- Android: Changed compileSdk and targetSdk to 34.
- Web: Updated web package to 1.0.0 version.
- Removed ci property from the response of the Retrieve user information API.
- Added uuid property to User for the Retrieve user information API.
- Fixed bugs.
    - Android: Fixed a bug that Compilation failure in Kotlin 2.0.0 version.
    - Web: Fixed a bug that authorize() does not work in Flutter SDK 1.9.2 version.
- Updated the internal source code.

## 1.9.5

- Android: Fixed an issue that Login with Kakao Account does not work on devices below Android 13
  using Flutter SDK version 1.9.4.
- Updated the internal source code.

## 1.9.4

- Android: Fixed a bug that the following features do now work when android:taskAffinity in
  MainActivity is set.
    - Login with Kakao Account, Select shipping address, Follow Kakao Talk Channel
- Fixed a bug that removes the refresh token when repeatedly calling Follow Kakao Talk Channel or
  Select shipping address.

## 1.9.3

- New features
    - Web: Supports WebAssembly build
- Changed Dart minimum support version to 3.3.0 or higher.
- Updated the internal source code.

## 1.9.2

- Updated the internal source code.
- Fixed a bug.
    - Web: Fixed an issue related to the popup (Login with Kakao Account, Select shipping address,
      Follow Kakao Talk Channel) on iOS 17.4 and higher versions.

## 1.9.1+2

- Added missing keys in the Privacy Manifest file for the iOS apps.

## 1.9.1+1

- Added missing keys in the Privacy Manifest file for the iOS apps.

## 1.9.1

- Added the Privacy Manifest file for the iOS apps.

## 1.9.0

- Added Select Shipping address API.
- Changed UserShippingAddresses.needsAgreement in the Retrieve shipping address API response to
  nullable.
- Changed Content.title and Content.imageUrl of the message template to nullable.

## 1.8.0

- Supports Follow Kakao Talk Channel(`followChannel()`).
- Fixed a bug.
    - Web: Resolved an issue where message events could not be received when installing certain
      Chrome extensions.
- Updated the internal source code.

## 1.7.0

- Deprecated the Kakao Story module (`kakao_flutter_sdk_story`).
- Supports Universal Link to the Login with Kakao Talk feature in the iOS environment.

## 1.6.1

- Fixed a bug.
    - Web: Fixed the build error in Flutter 3.13.0 or higher.

## 1.6.0

- Added the properties parameter to Retrieve user information API.
- Added new APIs of Add Kakao Talk Channel, Start Kakao Talk Channel chat.
    - The user moves directly to the Kakao Talk without any bridge page. (Kakao Talk v10.0.5 or
      higher required)
    - Existing APIs that return a bridge page URL are also provided.
- Changed the name of Start Kakao Talk Channel chat API that returns a bridge page URL.
    - channelChatUrl() → chatChannelUrl()
- Fixed a bug.
    - Web: Fixed the issue that fails to get the app version when the URL ends with /.
- Improved the test cases for the sample app.
- Updated the internal source code.

## 1.5.0

- Supports Kakao Account easy login.
- Added Revoke consent for service terms API.
- Updated Retrieve consent details for service terms API to v2.
- Supports the multi app.
- Fixed an issue that a deep link or universal link can not be received in a specific iOS
  environment.
    - When using a plugin that provides a feature receiving a deep link or universal link.
    - When launched the app through a deep link or universal link.

## 1.4.3

- Updated to build on Android Gradle Plugin 8.0.
- Changed Dart minimum support version to 2.18.0 or higher.
- Updated internal package and plugin versions.
- Fixed a bug.
    - Web: Fixed UserApiClient.loginWithNewScopes() malfunction issue

## 1.4.2

- Fixed an issue that the app using specific plugins cannot receive deep links or universal links on
  iOS.
    - Flutter SDK version 1.4.0 or later.
    - Using plugins can receive deep link or universal link.
    - Running the app with a deep link or universal link.

## 1.4.1

- Added `Prompt.create` value to the prompts parameter of Kakao Login.
- Fixed the following bugs.
    - iOS: Fixed `isKakaoTalkSharingAvailable()` malfunction issue.
    - Web: Fixed an issue that the pop-up does not disappear when `loginWithKakaoTalk()` is executed
      in the Samsung Internet browser of an Android device.

## 1.4.0

- Added the `friend` module for the Friend picker function.
- Improved calling method of Custom URL Scheme.
- Changed `refreshToken`, `refreshTokenExpiresAt` fields type of `OAuthToken` class to nullable.
- Changed the minimum support version of Android to 5.0 (API 21).
- Updated the internal source code.

## 1.3.1

- Fixed an issue that `launchBrowserTab()` does not work on Android devices.

## 1.3.0

- Supported Flutter Web officially.
- Added Calendar template for Message APIs.
- Changed the minimum support version of DART to 2.14.0.
- Removed `package_info_plus` package dependency.
- Updated the internal package and plugin versions.
- Updated the internal source code.

## 1.3.0-beta.4

- Fixed issue where app is closed when attempting to log in with Kakao Talk on iOS.
- Fixed issue where app is closed when attempting Kakao Talk sharing via web on iOS.

## 1.3.0-beta.3

- Fixed a bug in a web app.

## 1.3.0-beta.2

- Fixed a bug in a web app.

## 1.3.0-beta.1

- Added beta support for a web app.
    - IMPORTANT: This beta version does not affect the existing functions provided for mobile apps
      in a release phase.
- Fixed the build error in iOS environment which occurs when Use_frameworks! is not set in Podfile.
- Improved error handling logic by deleting the stored tokens when token decryption fails.

## 1.2.2

- Changed the type of fromUpdatedAt parameter for Retrieving shipping address API.
    - int? → DateTime?
- Fixed issue where the views for Consent screen are recreated when attempting to log in with Kakao
  Talk on an Android device.
- Added nonce to idToken in response to Login with Kakao Talk.

## 1.2.1

- Fix the build error related to `UniqueKey` that occurs in Flutter versions of 2.x.x.

## 1.2.0

- Changed the module name:
    - kakao_flutter_sdk_link → kakao_flutter_sdk_share
- Changed the class name:
    - LinkClient → ShareClient
    - LinkResult → SharingResult
- Changed the method name:
    - refreshAccessToken() → refreshToken()
    - isKakaoLinkAvailable() → isKakaoTalkSharingAvailable()
    - defaultTemplate() → shareDefault()
    - customTemplate() → shareCustom()
    - scrapTemplate() → shareScrap()
    - defaultTemplateUri() → makeDefaultUrl()
    - customTemplateUri() → makeCustomUrl()
    - scrapTemplateUri() → makeScrapUrl()
- Changed the property name:
    - accessTokenExpiresAt → expiresAt

## 1.1.1

- Updated to be compatible with Flutter 3.0.

## 1.1.0

- Added OpenID Connect functionality.
- Added expiresAt property to OAuthToken.
    - accessTokenExpiresAt (Validity period of access token) will be replaced with expiresAt in
      version 1.2.0.

## 1.0.0

- Released the official Kakao SDK for Flutter.
- For more detailed changes, refer
  to [What's new in Flutter SDK 1.0](https://developers.kakao.com/docs/latest/getting-started/sdk-flutter-migration).

## 0.9.0

- Modify nullability of `OAuthToken` field
- Modify return type of `issueAccessToken`
- Modify return type of `TokenManager` methods
- Modify parameter of `AuthApi.refreshAccessToken()`
- Add `TokenManagerProvider` for custom token storage
- Add `navigate()` and `shareDestination()` in `NaviApi`
- Rename model classes and field based on `Kakao Developers's Android/iOS v2 SDK`
- Add @Deprecate annotation to push, search and local API

## 0.8.2

- Improve token reissue logic
- Improve the logic of getting additional consent
- Add 'ItemContent' property in `FeedTemplate`
- Fix the bug where blank characters were marked + on Kakao Link in iOS
- Fix the bug of null errors when saving the token after calling `AuthApi.refreshAccessToken()`

## 0.8.1

- Rename `AccessTokenStore` to `TokenManager` (In version 0.8.0, It was incorrectly renamed
  to `TokenManageable`)

## 0.8.0

- Add 'productName', 'currencyUnit' and 'currencyUnitPosition' property in commerce template
- Rename `AccessTokenStore` to `TokenManageable`
- Improve to automatically recall the api after additional consent when the scope is insufficient
- Fix the bug in parsing Api error
- Fix the bug in reissuing access token automatically

## 0.7.1

- Fix the bug that caused the crash when logged in via KakaoTalk when KakaoTalk was not installed
- Fix the bug that intercepts url that sdk cannot handle in iOS
- Migrated from the deprecated package_info plugin to package_info_plus

## 0.7.0

- Add `signup()`, `scopes()` and `revokeScopes()` in `UserApi`
- Add prompt Login to `loginWithKakaoAccount()` in `UserApi`.
- Add `isKakaoLinkAvailable()`, `uploadImage()`, `scrapImage()` in `LinkClient`
- Add Kakao Navi API
- Add `navigateWebUrl()` in `NaviApi`
- Implement additional consents automatically when a -402 error occurs
- Rename ApiErrorCause based on `Kakao Developers's Android/iOS v2 SDK`

## 0.6.4

- Add fields `profileNicknameNeedsAgreement` and `profileImageNeedsAgreement` in `Account`
- Modify string value (url, key) regarding channel api
- Modify field type in `Address`
- Add `loginWithKakaoTalk()` and `loginWithKakaoAccount()` in `UserApi`

## 0.6.3

- Fix key of TalkProfile

## 0.6.2

- Fix to login with a browser other than Chrome
- Update Model Nullability

## 0.6.1

- Migrate to `Flutter 2.0 null-safety`
- Update `dio` version to `4.0.0`
- Update `json_annotation` version to `4.0.1`
- Update `shared_preferences` version to `2.0.5`
- Update `platform` version to `3.0.0`
- Update `package_info` version to `2.0.0`
- Rename model classes and fields based on `Kakao Developers's Android/iOS v2 SDK`
- Add `hasToken` method of `AuthApi` public

## 0.6.0-beta.2

- null safety migration.

## 0.6.0-beta.1

- Update `platform` version to `3.0.0-nullsafety.2`.

## 0.5.4

- Fix Android compile error.

## 0.5.3

- Fix Android compile error.

## 0.5.2

- Reformat all code with `dartfmt -w .`.

## 0.5.1

- Update `platform` version to 3.0.0-nullsafety.2 to get rid of build errors in flutter 1.22.0.
- Fix errors that drops pub score.

## 0.5.0

- Update KA header according to changed Kakao API specification. This will allow users to change
  account while logging in.
- Update library dependencies.
- Update dev versions (flutter 1.20.0, iOS 14.0, Xcode 12)

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
- fix wrong json keys for `androidExecParams` and `iosExecParms` in `Link` class of `template`
  module.

## 0.3.0

- Release according to recent Kakao API update.
- Add message send API to `TalkApi`. Also update `Friend` model to include `uuid` and `favorite`
  field.
- Add live account profile data to `Account` and `groupUserToken` field to `User`.

## 0.2.3

- Provide `presentationContextProvider` to `ASWebAuthenticationSession` in login. (fix for iOS13.0)
- Make `isRetriable` method of `AccessTokenInterceptor` public so that the interceptor can be used
  in a customized way. Third-party can override this method for their own API client
  if `Authorization` header matches the format `Bearer ${kakao_access_token}` for their API (which
  is a very uncommon need).

## 0.2.2

- Update `dio` package to `3.0.0` and fix compile errors due to interface changes. Changes that were
  merged in 2.2.1 were ported to 3.0.0, presumably to ensure version compatibility in ^2.2.x.

## 0.2.1

- Stabilize against flutter `1.9.1`.
- Update `dio` package to `2.2.1` and fix compile errors due to interface changes.

## 0.2.0

- SDK for Kakao Search API
- SDK for Kakao Local API
- Set secure_resource to true for /v2/user/me API.

## 0.1.2

- Remove meta package from explicit dependency.

## 0.1.1

- Update description field in `pubspec.yaml` to be longer than 60 characters.
- Update `meta` package version from `1.1.6` to `1.1.7`.

## 0.1.0

- Kakao Flutter SDK Initial Release
