import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginParameter {
  final List<Prompt> prompts;
  final String? loginHint;
  final List<String> scopes;
  final String? nonce;
  final List<String> channelPublicIds;
  final List<String> serviceTerms;

  LoginParameter({
    this.prompts = const [],
    this.loginHint,
    this.scopes = const [],
    this.nonce,
    this.channelPublicIds = const [],
    this.serviceTerms = const [],
  });
}
