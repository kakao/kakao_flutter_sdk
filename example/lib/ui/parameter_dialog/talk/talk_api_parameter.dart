import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class TalkApiParameter {
  final int? offset;
  final int? limit;
  final Order? order;
  final FriendOrder? friendOrder;
  final String channelPublicId;
  final List<String>? publicIds;

  TalkApiParameter({
    this.offset,
    this.limit,
    this.order,
    this.friendOrder,
    this.channelPublicId = '',
    this.publicIds,
  });
}
