# kakao_flutter_sdk

Flutter SDK for Kakao API.
Currently supports `Android` and `iOS` platform, and will support `web` platform (still in beta stage) in the _near future_.

## Checklist for Flutter Web Support

There are several steps necessary to enable web support for Kakao Flutter SDK.

- [x] Distinguish KA header for javascript environment
- [x] Authorize with `window.open()` (default method)
- [ ] Provide a way to authorize with `location.href`
- [ ] Allow CORS for Kakao API Server
- [ ] Release with web support

> `Login via KakaoTalk` will be currently unavailable for web since it requires access token polling and other more complex mechanisms.

## Getting Started

Flutter is becoming more wide-spread as a cross-platform development tool since it provides natively-compiled applications for mobile, web, and desktop from a single codebase.
Several requests have been made for Flutter support for Kakao API, and hence here it is.

Unlike [flutter_kakao_login](https://pub.dev/packages/flutter_kakao_login), which is also a great plugin, this plugin aims to re-write Kakao SDK mostly in Dart, and reduce platform-dependent code as much as possible.

### Dependencies

The first step is to import Kakao Flutter SDK into your project, in `pubspec.yaml`.
Specify Kakao SDK dependency as below in your `pubspec.yaml`.

```yaml
dependencies:
  kakao_flutter_sdk: ^0.8.1
```

### dependencies

Kakao Flutter SDK has following dependencies:

1. [dio](https://pub.dev/packages/dio) (4.0.0)
1. [json_annotation](https://pub.dev/packages/json_serializable) (4.0.1)
1. [shared_preferences](https://pub.dev/packages/shared_preferences) (2.0.5)
1. platform (3.0.0)
1. package_info_plus (1.0.4)

Below dependencies were considered but were removed due to restrictions against our needs:

1. url_launcher
1. flutter_custom_tabs
1. flutter_web_auth

> They all provide overly-simplified common interface between Android and iOS and is not suitable for OAuth 2.0 process involving default browsers.
> SDK calls `Chrome Custom Tabs` and `ASWebAuthenticationSession` natively via platform channel for OAuth 2.0 Authentication.

### Kakao Application Setup

You have to create an application on [Kakao Developers](https://developers.kakao.com) and set up iOS and Android platforms.
Follow the instructions below:

1. [Getting Started on Android](https://developers.kakao.com/docs/latest/ko/kakaologin/android#before-you-begin)
1. [Getting Started on iOS](https://developers.kakao.com/docs/latest/ko/kakaologin/ios#before-you-begin)
1. [Getting Started on Web](https://developers.kakao.com/docs/latest/ko/kakaologin/js#before-you-begin)

Below are additional steps you have to take for Android and iOS platform.

1. [키 해시(Key Hash) 등록](https://developers.kakao.com/docs/latest/ko/getting-started/sdk-android#add-key-hash) to use Kakao API.
1. [plist 설정 & URL Scheme 설정](https://developers.kakao.com/docs/latest/ko/getting-started/sdk-ios#set-plist)

Also, minimum iOS version for Kakao Flutter SDK is 11.
Therefore, you have to specify 11 is your iOS application's `Podfile` like below:

```
platform :ios, '11.0'
```

Otherwise, you will encounter errors such as:

```
[!] CocoaPods could not find compatible versions for pod "kakao_flutter_sdk":
```

## Implementation Guide

### Initializing SDK

First, you have to initialize SDK at app startup in order to use it. It is as simple as setting your native app key in global context.

```dart
KakaoContext.clientId = "${put your native app key here}"
// KakaoContext.javascriptClientId = "${put your javascript key here}" // not yet supported
```

### Kakao Login

Now, you can use method `loginWithKakaoTalk()` and `loginWithKakaoAccount()` in `UserApi`.
If you use these methods, you don't need to implement codes which is getting authorization code and getting access token.

```dart
// login with KakaoTalk (0.6.4 ~ )
void loginButtonClicked() async {
  try {
    await UserApi.instance.loginWithKakaoTalk();
    // perform actions after login
  } catch (e) {
    print('error on login: $e');
  }
}
```

If you want to use `loginWithKakaoAccount()`, Go to 'Via browser' and set 'For Android' and 'For iOS'.

```dart
// login with KakaoAccount (0.6.4 ~ )
void loginButtonClicked() async {
  try {
    await UserApi.instance.loginWithKakaoAccount();
    // perform actions after login
  } catch (e) {
    print('error on login: $e');
  }
}
```

You can request reauthentication regardless of a user's login status to enhance security. Set prompts to Prompt.LOGIN. 
Then, the login screen is prompted even though a user has already been logged in on the same web browser on the device.

```dart
// login with KakaoAccount (0.6.4 ~ )
void loginButtonClicked() async {
  try {
    await UserApi.instance.loginWithKakaoAccount(prompts: [Prompt.LOGIN]);
    // perform actions after login
  } catch (e) {
    print('error on login: $e');
  }
}
```

First, users have to get access token in order to call Kakao API. Access tokens are issued according to [OAuth 2.0 spec](https://oauth.net/2).

1. Authenticate with Kakao Account
1. User Agreement (skip if not necessary)
1. Get Authorization Code (via redirect)
1. Issue access token (via POST API)

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

**For Android**, Since default browser will redirect authorization code to your app via custom scheme, you are **required** to specify `com.kakao.sdk.flutter.AuthCodeCustomTabsActivity` in your `AndroidManifest.xml'.
Replace your `native app key` from Kakao developers site in the placeholder for `data` tag in `intent-filter` tag.
Otherwise, the login process will halt with no further UI response.


```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="your.package.name">
    <application
      ...
      >
      ...
        <activity android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity">
          <intent-filter android:label="flutter_web_auth">
              <action android:name="android.intent.action.VIEW" />
              <category android:name="android.intent.category.DEFAULT" />
              <category android:name="android.intent.category.BROWSABLE" />
              <data android:scheme="kakao${your_native_app_key_here}" android:host="oauth"/>
          </intent-filter>
        </activity>
        ...
      </application>
</manifest>
```

You can look for sample code [here](https://github.com/kakao/kakao_flutter_sdk/blob/master/example/android/app/src/main/AndroidManifest.xml).


**For iOS**, you have to register schemes for all **browser redirect**, **KakaoTalk login**, and **kakaolink**.
This can be done by registering `LSApplicationQueriesSchems` in your `info.plist` as below.

```xml
 <key>LSApplicationQueriesSchemes</key>
  <array>
      <!-- common -->
      <string>kakao${native_app_key_here}</string>

      <!-- KakaoTalk login -->
      <string>kakaokompassauth</string>
      <string>storykompassauth</string>

      <!-- KakaoLink -->
      <string>kakaolink</string>         
      <string>kakaotalk-5.9.7</string>
  </array>
```

For details, follow the instruction in the official [kakao SDK guide](https://developers.kakao.com/docs/latest/ko/getting-started/sdk-ios-v1#app-key).

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


##### Via browser or KakaoTalk??

It is up to you whether to use default browser or KakaoTalk for user login.

- Default browser will prompt users with Kakao account login for the first time if they have no Kakao account cookie in their default browser.
However, it wil reuse browser cookie in subsequent login attempts so that user does not have to reenter their email and passwords.
- If you use KakaoTalk, users will encounter error when KakaoTalk is not installed (which means you have to deal with the error and retry with browser or notify users to do so).


Below example shows how you can divide user login logic depending on whether user has KakaoTalk installed or not.

```dart
import 'package:kakao_flutter_sdk/common.dart'; // import utility methods
import 'package:kakao_flutter_sdk/user.dart'; // must be imported if version is 0.6.4 or higher

...
  // login sample code (0.6.4 ~ ) 
  void login() async {
    try {
      final installed = await isKakaoTalkInstalled();
      installed ? await UserApi.instance.loginWithKakaoTalk() : await UserApi.instance.loginWithKakaoAccount();
      // perform actions after login
    } catch (e) {
      
    }
  }

  // login sample code ( ~ 0.6.3)
  void login() async {
    try {
      final installed = await isKakaoTalkInstalled();
      final authCode = installed ? await AuthCodeClient.instance.requestWithTalk() : await AuthCodeClient.instance.request();
    } on KakaoAuthException catch (e) {

    } on KakaoClientException catch(e) {

    }
  }
...
```


#### Getting Access Token

> In version 0.8.0, `AccessTokenStore` was incorrectly renamed to `TokenManageable`.
>
> So, It has been renamed to **`TokenManager`** since version 0.8.1.
>
> Also,  Method `fromStore()` has been renamed to `getToken()` and `toStore()` has been rename to `setToken()`.
 

Then, you have to issue access token for the user with authorization code acuiqred from the process above.
Sample login code is pasted below:

```dart
void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.request(); // via browser
    // String authCode = await AuthCodeClient.instance.requestWithTalk() // or with KakaoTalk
    AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
    TokenManager.instance.setToken(token); // Store access token in TokenManager for future API requests.
  } catch (e) {
    // some error happened during the course of user login... deal with it.
  }
}
```

> ~~Currently, Kakao Flutter SDK does not plan to support Kakao login or KakaoLink via kakaoTalk.
> The SDK tries to support as many platform and environment as possible and mobile-only.~~

> Kakao Flutter SDK supports Kakao Login via KakaoTalk on Android and iOS now.

After user's first login (access token persisted correctly), you can check the status of _TokenManager_ in order to skip this process.
Below is the sample code of checking token status and redirecting to login screen if refresh token does not exist.

```dart
AccessToken token = await TokenManager.instance.getToken();
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

#### Dynamic User Agreement

There are cases when users have to agree in order to call specific API endpoints or receive additional fields in an API.

##### When 403 forbidden error is returned from API server

If your Kakao Flutter SDK version is 0.7.0 or higher, An additional consent window will appear automatically.
So you don't need to handle `ApiErrorCause.INSUFFICIENT_SCOPE`.

```dart

Future<void> requestFriends() async {
  try {
    FriendsResponse friends = await TalkApi.instance.friends();
    // do anything you want with user instance
  } on KakaoAuthException catch (e) {
    if (e.code == ApiErrorCause.INVALID_TOKEN) { // access token has expired and cannot be refrsehd. access tokens are already cleared here
      Navigator.of(context).pushReplacementNamed('/login'); // redirect to login page
    } else if (e.code == ApiErrorCause.INSUFFICIENT_SCOPE) {
      // If code is ApiErrorCause.INSUFFICIENT_SCOPE, error instance will contain missing required scopes.
      // If your Kakao Flutter SDK version is 0.7.0 or higher, An additional consent window will appear automatically.
    }
  } catch (e) {
    // other api or client-side errors
  }
}

Future<void> retryAfterUserAgrees(List<String> requiredScopes) async {
    // Getting a new access token with current access token and required scopes.
    String authCode = await AuthCodeClient.instance.requestWithAgt(e.requiredScopes);
    AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
    TokenManager.instance.setToken(token); // Store access token in TokenManager for future API requests.
    await requestFriends();
}

```

##### Certain fields are missing

This can happen when `/v2/user/me` API is called with `UserApi#me()` method.
`UserApi#me()` never throws `ApiErrorCause.INSUFFICIENT_SCOPE` error because it is dependent on many scopes, not only one scope.
Therefore you have to construct a list of scopes yourself like below.

```dart

void requestMe() async {
  try {
    User user = await UserApi.instance.me();
    if (user.kakaoAccount.emailNeedsAgreement || user.kakaoAccount.genderNeedsAgreement) {
      // email and gender can be retrieved after user agreement
      // you can also check for other scopes.
      await retryAfterUserAgrees(["account_email", "gender"]);
      return;
    }
    // do anything you want with user instance
  } on KakaoAuthException catch (e) {
    if (e.code == ApiErrorCause.INVALID_TOKEN) { // access token has expired and cannot be refrsehd. access tokens are already cleared here
      Navigator.of(context).pushReplacementNamed('/login'); // redirect to login page
    }
  } catch (e) {
    // other api or client-side errors
  }
}

Future<void> retryAfterUserAgrees(List<String> requiredScopes) async {
    // Getting a new access token with current access token and required scopes.
    String authCode = await AuthCodeClient.instance.requestWithAgt(requiredScopes);
    AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
    TokenManager.instance.setToken(token); // Store access token in TokenManager for future API requests.
    await requestMe();
}
```

### App key based API

Below are set of APIs that can be called with app key after just initializing SDK.
These APIs are relatively easy to use compared to token-based APIs.

1. LinkApi
1. LocalApi
1. SearchApi
1. PushApi

#### KakaoLink

KakaoLink API can be used after simply setting your native app key in _KakaoContext_ since it is not a token-based API.
Below is an example of sending KakaoLink message with custom template.

```dart
import 'package:kakao_flutter_sdk/main.dart';

Uri uri = await LinkClient.instance
          .custom(16761, templateArgs: {"key1": "value1"});
await launchBrowserTab(uri);
```

#### KakaoNavi

The Flutter SDK uses the default browser to run directions with the web version of Kakao Navigation. The URL used is generated using the navigateUrl() API. You can also use this API to obtain only URL values as needed.
You can use coordinate system WGS64 or KATEC in [CoordType]. Default is KATEC.
If you want more detail, Visit this [Kakao Developers Guide](https://developers.kakao.com/docs/latest/en/kakaonavi/android#set-parameter).

```dart
// (0.7.0 ~ )
void _navigationButtonClicked() async {
  try {
    var url = await NaviApi.instance
        .navigateWebUrl(Location("카카오 판교오피스", "321286", "533707"));
    print(url);
    await launchBrowserTab(url);
  } catch (e) {
    print(e);
  }
}
```

## SDK Architecture

### Automatic token refreshing

Tokens are automatically refreshed on relevant api errors (ApiErrorCause.INVALID_TOKEN).

### Automatic additional consent (0.7.0 ~ )

An additional consent window will appear automatically on relevant api errors (ApiErrorCause.INSUFFICIENT_SCOPE). 

## How to Contribute

If you want to contribute to this repository, Please read [Development Guide](https://github.com/kakao/kakao_flutter_sdk/wiki/Development-Guide) and [Submitting Pull Requests](https://github.com/kakao/kakao_flutter_sdk/wiki/Submitting-Pull-Requests) pages.


## References

### Firebase Auth + Kakao Login with custom token

- https://github.com/fysoul17/kakao_flutter_sdk/tree/master/example_firebase
- https://github.com/FirebaseExtended/custom-auth-samples
- https://github.com/fysoul17/firebase_auth_simplify


## License

This software is licensed under the [Apache 2 license](LICENSE), quoted below.

Copyright 2019 Kakao Corp. <https://www.kakaocorp.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this project except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
