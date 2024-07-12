import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// KO: 친구 정보
/// <br>
/// EN: Friend information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  /// KO: 회원번호
  /// <br>
  /// EN: Service user ID
  final int? id;

  /// KO: 고유 ID
  /// <br>
  /// EN: Unique ID
  final String uuid;

  /// KO: 프로필 닉네임
  /// <br>
  /// EN: Profile nickname
  final String? profileNickname;

  /// KO: 프로필 썸네일 이미지
  /// <br>
  /// EN: Profile thumbnail image
  final String? profileThumbnailImage;

  /// KO: 즐겨찾기 친구 여부
  /// <br>
  /// EN: Whether a favorite friend
  final bool? favorite;

  /// KO: 메시지 수신 허용 여부
  /// <br>
  /// EN: Whether to allow receiving messages
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

/// KO: 친구 목록 조회 설정
/// <br>
/// EN: Context for retrieving friend list
class FriendsContext {
  /// KO: 친구 목록 시작 지점
  /// <br>
  /// EN: Start point of the friend list
  int? offset;

  /// KO: 페이지당 결과 수
  /// <br>
  /// EN: Number of results in a page
  int? limit;

  /// KO: 정렬 방식
  /// <br>
  /// EN: Sorting method
  Order? order;

  /// KO: 페이지당 결과 수
  /// <br>
  /// EN: Number of results in a page
  FriendOrder? friendOrder;

  /// KO: 친구 목록 요청 URL
  /// <br>
  /// EN: URL to request the friend list
  Uri url;

  /// @nodoc
  FriendsContext({this.offset, this.limit, this.order, this.friendOrder})
      : url = Uri.parse('');

  FriendsContext.fromUrl(this.url) {
    offset = int.parse(url.queryParameters['offset']!);
    limit = int.parse(url.queryParameters['limit']!);

    if (url.queryParameters['order'] == Order.asc.name) {
      order = Order.asc;
    } else if (url.queryParameters['order'] == Order.desc.name) {
      order = Order.desc;
    } else {
      order = null;
    }

    if (url.queryParameters['friend_order'] == FriendOrder.nickname.name) {
      friendOrder = FriendOrder.nickname;
    } else if (url.queryParameters['friend_order'] ==
        FriendOrder.favorite.name) {
      friendOrder = FriendOrder.favorite;
    } else {
      friendOrder = null;
    }
  }
}

/// KO: 정렬 방식
/// <br>
/// EN: Sorting method
enum Order {
  /// KO: 오름차순
  /// <br>
  /// EN: Ascending
  asc,

  /// KO: 내림차순
  /// <br>
  /// EN: Descending
  desc
}

/// KO: 친구 정렬 방식
/// <br>
/// EN: Method to sort the friend list
enum FriendOrder {
  /// KO: 닉네임순 정렬
  /// <br>
  /// EN: Sort by nickname
  nickname,

  /// KO: 즐겨찾기 우선 정렬
  /// <br>
  /// EN: Sort favorite friends first
  favorite
}
