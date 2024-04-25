import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_friend/src/default_values.dart';

part 'picker_friend_request_params.g.dart';

/// KO: 피커 설정
/// <br>
/// EN: Options for the picker
@JsonSerializable()
class PickerFriendRequestParams {
  /// KO: 피커 이름
  /// <br>
  /// EN: Name of the picker
  String? title;

  /// KO: 검색 기능 사용 여부
  /// <br>
  /// EN: Enables the search function
  bool? enableSearch;

  /// KO: 내 프로필 표시 여부
  /// <br>
  /// EN: Displays my profile
  bool? showMyProfile;

  /// KO: 즐겨찾기 친구 표시 여부
  /// <br>
  /// EN: Marks on favorite friends
  bool? showFavorite;

  /// KO: 선택한 친구 표시 여부, 멀티 피커에만 사용 가능
  /// <br>
  /// EN: Displays selected friends for multi-picker
  bool? showPickedFriend;

  /// KO: 선택 가능한 최대 대상 수
  /// <br>
  /// EN: Maximum pickable count
  int? maxPickableCount;

  /// KO: 선택 가능한 최소 대상 수
  /// <br>
  /// EN: Minimum pickable count
  int? minPickableCount;

  /// KO: 친구 정보를 받을 URL, 리다이렉트 방식 웹 사용 시 필수
  /// <br>
  /// EN: URL to get the friend information, required for web with redirect method
  String? returnUrl;

  /// KO: 뒤로 가기 버튼 사용 여부, 리다이렉트 방식 웹 또는 네이티브 앱에서만 사용 가능
  /// <br>
  /// EN: Enables the back button, available for web with redirect method or native app
  bool? enableBackButton;

  /// @nodoc
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
