# kakao_flutter_sdk

Flutter SDK for Kakao API

## Getting Started

Flutter is becoming more wide-spread cross-platform development tool since it provides natively-compiled applications for mobile, web, and desktop from a single codebase.

### Setting up the dependency

The first step is to include Kakao Flutter SDK into your project, in pubspec.yaml.

```yaml
dependencies:
  kakao_flutter_sdk: ^0.1.0
```

### Transitive dependencies

Kakao Flutter SDK has following transitive dependencies:

1. dio (2.1.0)
1. json_annotation (2.3.0)
1. shared_preferences (0.5.3+1)

Below dependencies were considered but was removed due to restrictions against our needs:

1. url_launcher
1. flutter_custom_tabs
1. flutter_web_auth

## Implementation Guide

### Initializing SDK

First, you have to initialize SDK at app startup in order to use it. It is as simple as setting your native app key in global context.

```dart
KakaoContext.clientId = "${put your native app key here}"
```

### Getting Access Token

First, users have to get access token in order to call Kakao API. Access tokens are issued according to OAuth 2.0 spec.

1. kakao account authentication
1. user agreemnet (skip if not necessary)
1. authorization codem (via redirect)
1. issue access token (via POST API)

Sample login code is pasted below:

```dart
void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.request();
    AccessToken token = await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenRepo.instance.toCache(token);
  } catch (e) {
    // some error happened during the course of user login... deal with it.
  }
}
```

After user's first login (access token persisted correctly), you can check the status of _AccessTokenRepo_ in order to skip this process.
Below is the sample code of checking token status and redirecting to login screen if refresh token does not exist.

```dart
String token = await AccessTokenRepo.instance.fromCache();
if (token.refreshToken == null) {
  Navigator.of(context).pushReplacementNamed('/login');
} else {
  Navigator.of(context).pushReplacementNamed("/main");
}
```

> Existence of refresh token is a good criteria for deciding whether user has to authorize again or not, since refresh token can be used to refresh access token.

### Calling Token-based API

After ensuring that access token does exist with above step, you can call token-based API. Below are set of APIs that are currently supported with Kakao Flutter SDK.

1. UserApi
1. TalkApi
1. StoryApi

Below is an example of calling _/v2/user/me_ API with _UserApi_ class.

```dart
try {
  User user = await UserApi.instance.me();
  // do anything you want with user instance
} catch (e) {
  // api or client-side error
}
```

### KakaoLink

KakaoLink API can be used after simply setting your native app key in _KakaoContext_ since it is not a token-based API.
Below is an example of sending KakaoLink message with custom template.

```dart
import 'package:kakao_flutter_sdk/main.dart';

Uri uri = await LinkClient.instance
          .custom(16761, templateArgs: {"key1": "value1"});
await launchWithBrowserTab(uri);
```

## SDK Architecture

### Automatic token refreshing

### Customization
