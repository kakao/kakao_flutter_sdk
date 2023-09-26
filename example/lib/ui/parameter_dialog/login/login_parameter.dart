import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginParameter {
  final List<Prompt> prompts;
  final String? loginHint;
  final List<String> scopes;
  final String? signData;
  final String? nonce;
  final String? settleId;
  final List<String> channelPublicIds;
  final List<String> serviceTerms;

  LoginParameter({
    this.prompts = const [],
    this.loginHint,
    this.scopes = const [],
    this.signData,
    this.nonce,
    this.settleId,
    this.channelPublicIds = const [],
    this.serviceTerms = const [],
  });
}
