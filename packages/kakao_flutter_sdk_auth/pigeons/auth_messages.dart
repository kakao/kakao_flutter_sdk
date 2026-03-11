import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'kakao_flutter_sdk_auth',
    dartOut:
        'packages/kakao_flutter_sdk_auth/lib/src/pigeon/auth_messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'packages/kakao_flutter_sdk_auth/android/src/main/kotlin/com/kakao/sdk/flutter/auth/AuthMessages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.kakao.sdk.flutter.auth'),
    swiftOut:
        'packages/kakao_flutter_sdk_auth/ios/kakao_flutter_sdk_auth/Sources/kakao_flutter_sdk_auth/AuthMessages.g.swift',
  ),
)
class PkceDto {
  PkceDto(this.codeVerifier, this.codeChallenge, this.codeChallengeMethod);

  final String codeVerifier;
  final String codeChallenge;
  final String codeChallengeMethod;
}

@HostApi()
abstract class AuthHostApi {
  @async
  String authorizeWithKakaoTalk(
    String appKey,
    String redirectUri,
    String kaHeader,
    PkceDto? pkce,
    String? nonce,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String androidTalkPackageName,
    String iosLoginScheme,
    String iosUniversalLink,
  );

  @async
  String authorize(String url, String redirectUri);

  @async
  String launchAppsUrl(String url);
}
