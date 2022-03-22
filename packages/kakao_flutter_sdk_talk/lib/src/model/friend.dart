import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// 카카오톡 친구 정보
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  /// 회원번호
  final int? id;

  /// 메시지를 전송하기 위한 고유 아이디
  /// 사용자의 계정 상태에 따라 이 정보는 바뀔 수 있으므로 앱내의 사용자 식별자로는 권장하지 않음
  final String uuid;

  /// 친구의 닉네임
  final String? profileNickname;

  /// 썸네일 이미지 URL
  final String? profileThumbnailImage;

  /// 즐겨찾기 추가 여부
  final bool? favorite;

  /// 메시지 수신이 허용되었는지 여부
  /// 앱가입 친구의 경우는 feed msg 에 해당
  /// 앱미가입친구는 invite msg 에 해당
  final bool? allowedMsg;

  /// @nodoc
  Friend(this.id, this.uuid, this.profileNickname, this.profileThumbnailImage,
      this.favorite, this.allowedMsg);

  /// @nodoc
  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$FriendToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// 친구 목록 조회 Context
class FriendsContext {
  int? offset;
  int? limit;
  Order? order;
  FriendOrder? friendOrder;
  Uri url;

  FriendsContext({this.offset, this.limit, this.order, this.friendOrder})
      : url = Uri.parse('');

  FriendsContext.fromUrl(this.url) {
    offset = int.parse(url.queryParameters['offset']!);
    limit = int.parse(url.queryParameters['limit']!);

    if (url.queryParameters['order'] == describeEnum(Order.asc)) {
      order = Order.asc;
    } else if (url.queryParameters['order'] == describeEnum(Order.desc)) {
      order = Order.desc;
    } else {
      order = null;
    }

    if (url.queryParameters['friend_order'] ==
        describeEnum(FriendOrder.nickname)) {
      friendOrder = FriendOrder.nickname;
    } else if (url.queryParameters['friend_order'] ==
        describeEnum(FriendOrder.favorite)) {
      friendOrder = FriendOrder.favorite;
    } else {
      friendOrder = null;
    }
  }
}

/// 목록 조회에 사용되는 정렬 방식
enum Order { asc, desc }

/// 친구 목록 정렬 기준
enum FriendOrder {
  /// 이름 순 정렬
  nickname,

  /// 즐겨찾기 순 정렬
  favorite
}
