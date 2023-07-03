import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var appKey = "sampleappkey";
  KakaoSdk.init(nativeAppKey: appKey);

  var channel = const MethodChannel(CommonConstants.methodChannel);
  setUp(() async {});

  group("/oauth/authorize", () {
    var redirectUri = "kakao$appKey://oauth";
    var expectedCode = "sample_auth_code";
    var state = "state";

    test("200", () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (message) async {
        return "$redirectUri?code=$expectedCode";
      });

      var code = await AuthCodeClient.instance.authorize(
        clientId: appKey,
        redirectUri: redirectUri,
        scopes: ["profile", "account_email"],
      );
      expect(code, expectedCode);
    });

    test("access denied", () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (message) async {
        return "$redirectUri?error_description=User%20denied%20access&error=access_denied&state=$state";
      });

      try {
        await AuthCodeClient.instance
            .authorize(clientId: appKey, redirectUri: redirectUri);
        fail("should not reach here");
      } on KakaoAuthException catch (e) {
        expect(e.error, AuthErrorCause.accessDenied);
      }
    });
  });
}
