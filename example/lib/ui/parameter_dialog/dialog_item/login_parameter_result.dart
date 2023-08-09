import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class ParameterResult {
  final List<Prompt> prompts;
  final String? loginHint;
  final List<String> scopes;
  final String? state;
  final String? nonce;
  final String? settleId;
  final List<String> channelPublicIds;
  final List<String> serviceTerms;

  ParameterResult({
    this.prompts = const [],
    this.loginHint,
    this.scopes = const [],
    this.state,
    this.nonce,
    this.settleId,
    this.channelPublicIds = const [],
    this.serviceTerms = const [],
  });
}
