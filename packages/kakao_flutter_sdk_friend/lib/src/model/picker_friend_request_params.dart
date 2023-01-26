import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_friend/src/default_values.dart';

part 'picker_friend_request_params.g.dart';

@JsonSerializable()
class PickerFriendRequestParams {
  /// 친구 피커의 이름
  String? title;

  /// 친구 검색 기능 사용 여부
  bool? enableSearch;

  /// 내 프로필 표시 여부
  bool? showMyProfile;

  /// 즐겨찾기 친구 표시 여부
  bool? showFavorite;

  /// 선택한 친구 표시 여부 (멀티 피커에만 사용 가능)
  bool? showPickedFriend;

  /// 선택 가능한 친구 수의 최대값 (멀티 피커에만 사용 가능)
  int? maxPickableCount;

  /// 선택 가능한 친구 수의 최소값 (멀티 피커에만 사용 가능)
  int? minPickableCount;

  /// 선택한 친구 정보를 받을 서비스 URL
  /// flutter web 리다이렉트 방식 사용 시 필수
  String? returnUrl;

  /// 뒤로가기 버튼 사용 여부 지정
  /// flutter web 리다이렉트 방식 또는 Android/iOS 앱에서만 사용 가능
  bool? enableBackButton;

  PickerFriendRequestParams({
    this.title,
    this.enableSearch = DefaultValues.enableSearch,
    this.showMyProfile = DefaultValues.showMyProfile,
    this.showFavorite = DefaultValues.showFavorite,
    this.showPickedFriend = DefaultValues.showPickedFriend,
    this.maxPickableCount = DefaultValues.maxPickableCount,
    this.minPickableCount = DefaultValues.minPickableCount,
    this.returnUrl,
    this.enableBackButton = DefaultValues.enableBackButton,
  });

  factory PickerFriendRequestParams.fromJson(Map<String, dynamic> json) =>
      _$PickerFriendRequestParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PickerFriendRequestParamsToJson(this);
}
