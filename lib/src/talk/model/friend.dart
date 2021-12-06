import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// 카카오톡 친구
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Friend {
  /// 사용자 아이디
  final int? id;

  /// 메시지를 전송하기 위한 고유 아이디. 사용자의 계정 상태에 따라 이 정보는 바뀔 수 있으므로 앱내의 사용자 식별자로는 권장하지 않음.
  final String uuid;

  /// 친구의 닉네임
  final String? profileNickname;

  /// 썸네일 이미지 URL
  final String? profileThumbnailImage;

  /// 즐겨찾기 추가 여부
  final bool? favorite;

  /// 메시지 수신이 허용되었는지 여부. 앱가입 친구의 경우는 feed msg 에 해당. 앱미가입친구는 invite msg 에 해당
  final bool? allowedMsg;

  /// @nodoc
  Friend(this.id, this.uuid, this.profileNickname, this.profileThumbnailImage,
      this.favorite, this.allowedMsg);

  /// @nodoc
  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
