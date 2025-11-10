import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

/// KO: 카카오계정으로 로그인 기능을 위한 설정<br>
/// <br>
/// EN: Configuration for Login with Kakao Account
class AccountLoginParams {
  /// KO: 동의 화면에 상호작용 추가 요청 프롬프트<br>
  /// <br>
  /// EN: Prompt to add an interaction to the consent screen
  final List<Prompt>? prompts;

  /// KO: 카카오계정 로그인 페이지의 ID란에 자동 입력할 값<br>
  /// <br>
  /// EN: A value to fill in ID field of the Kakao Account login page
  final String? loginHint;

  AccountLoginParams({
    this.prompts,
    this.loginHint,
  });
}
