import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

class AccountLoginParams {
  final List<Prompt>? prompts;
  final String? loginHint;

  AccountLoginParams({
    this.prompts,
    this.loginHint,
  });
}
