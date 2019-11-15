# kakao_flutter_sdk

Flutter SDK for Kakao API.
Currently supports `Android` and `iOS` platform, and will support `web` platform (still in technival preview stage) when it becomes stable.

## Getting Started

Flutter is becoming more wide-spread as a cross-platform development tool since it provides natively-compiled applications for mobile, web, and desktop from a single codebase.
Several requests have been made for Flutter support for Kakao API.

### Setting up the dependency

The first step is to include Kakao Flutter SDK into your project, in `pubspec.yaml`.
**Currently, Kakao Flutter SDK is not publicly released on [pub.dev](https://pub.dev).**
Therefore, you have to specify the dependency as below in your `pubspec.yaml`.

```yaml
dependency_overrides:
  kakao_flutter_sdk:
    git:
      url: git@github.com:CoderSpinoza/kakao-flutter-sdk.git
```

In the near future when it is released on [pub.dev](https://pub.dev), below would suffice.

```yaml
dependencies:
  kakao_flutter_sdk: ^0.3.2
```

### Transitive dependencies

Kakao Flutter SDK has following transitive dependencies:

1. [dio](https://pub.dev/packages/dio) (2.1.0)
1. [json_serializable](https://pub.dev/packages/json_serializable) (2.4.0)
1. [shared_preferences](https://pub.dev/packages/shared_preferences) (0.5.3+1)
1. platform (2.2.0)

Below dependencies were considered but was removed due to restrictions against our needs:

1. url_launcher
1. flutter_custom_tabs
1. flutter_web_auth

SDK calls `Chrome Custom Tabs` and `ASWebAuthenticationSession` natively via platform channel.

### Set up your Kakao App

You have to create an application on [Kakao Developers](https://developers.kakao.com) and set up iOS and Android platforms.
Follow the instructions below:

1. [Getting Started on Android](https://developers.kakao.com/docs/android/getting-started)
1. [Getting Started on iOS](https://developers.kakao.com/docs/ios/getting-started)

## Implementation Guide

### Initializing SDK

First, you have to initialize SDK at app startup in order to use it. It is as simple as setting your native app key in global context.

```dart
KakaoContext.clientId = "${put your native app key here}"
```

### Kakao Login

First, users have to get access token in order to call Kakao API. Access tokens are issued according to OAuth 2.0 spec.

1. kakao account authentication
1. user agreemnet (skip if not necessary)
1. get authorization code (via redirect)
1. issue access token (via POST API)

#### Getting Authorization Code

There are two ways users can get authorization code.

1. Via kakao account login in browser
1. Via KakaoTalk

##### Via browser

SDK uses `ASWebAuthenticationSession` and `Custom Tabs` for opening browser on `iOS` and `Android`, respectively.

```dart
void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.request();
  } on KakaoAuthException catch (e) {
    // some error happened during the course of user login... deal with it.
  } on KakaoClientException catch (e) {
    //
  } catch (e) {
    //
  }
}
```

##### Via KakaoTalk

```dart
void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.requestWithTalk();
  } on KakaoAuthException catch (e) {
    // some error happened during the course of user login... deal with it.
  } on KakaoClientException catch (e) {
    //
  } catch (e) {
    //
  }
}
```

#### Getting Access Token

Sample login code is pasted below:

```dart
void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.request();
    AccessToken token = await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenStore.instance.toCache(token);
  } catch (e) {
    // some error happened during the course of user login... deal with it.
  }
}
```

> Currently, Kakao Flutter SDK does not plan to support Kakao login or KakaoLink via kakaoTalk.
> The SDK tries to support as many platform and environment as possible and mobile-only

After user's first login (access token persisted correctly), you can check the status of _AccessTokenStore_ in order to skip this process.
Below is the sample code of checking token status and redirecting to login screen if refresh token does not exist.

```dart
String token = await AccessTokenStore.instance.fromCache();
if (token.refreshToken == null) {
  Navigator.of(context).pushReplacementNamed('/login');
} else {
  Navigator.of(context).pushReplacementNamed("/main");
}
```

> Existence of refresh token is a good criteria for deciding whether user has to authorize again or not, since refresh token can be used to refresh access token.

### Calling Token-based API

After ensuring that access token does exist with above step, you can call token-based API.
Below are set of APIs that are currently supported with Kakao Flutter SDK.

1. UserApi
1. TalkApi
1. StoryApi

> Tokens are automatically added to Authorization header by AccessTokenInterceptor.

Below is an example of calling _/v2/user/me_ API with `UserApi` class.

```dart
try {
  User user = await UserApi.instance.me();
  // do anything you want with user instance
} on KakaoAuthException catch (e) {
  if (e.code == ApiErrorCause.INVALID_TOKEN) { // access token has expired and cannot be refrsehd. access tokens are already cleared here
    Navigator.of(context).pushReplacementNamed('/login'); // redirect to login page
  }
} catch (e) {
  // other api or client-side errors
}
```

### App key based API

#### KakaoLink

KakaoLink API can be used after simply setting your native app key in _KakaoContext_ since it is not a token-based API.
Below is an example of sending KakaoLink message with custom template.

```dart
import 'package:kakao_flutter_sdk/main.dart';

Uri uri = await LinkClient.instance
          .custom(16761, templateArgs: {"key1": "value1"});
await launchBrowserTab(uri);
```

## SDK Architecture

### Automatic token refreshing

Tokens are automatically refreshed on relveant api errors.

### Dynamic User Agreement

There are

### Customization

## Documentation

Docs are generated by DartDoc and currently published under https://coderspinoza.github.io/kakao-flutter-sdk/.
This documentation page is going to be maintained apart from the page that will be available on [pub.dev](https://pub.dev)

## Development Guide

```sh
$ flutter analyze --no-pub --no-current-package lib
$ flutter packages pub publish --dry-run
```

### Defining Response Models

```sh
$ flutter packages pub run build_runner build --delete-conflicting-outputs
```
