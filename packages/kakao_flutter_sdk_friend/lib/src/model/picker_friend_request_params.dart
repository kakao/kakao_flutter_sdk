import 'package:json_annotation/json_annotation.dart';

part 'picker_friend_request_params.g.dart';

/// KO: 피커 설정
/// <br>
/// EN: Options for the picker
@JsonSerializable()
class PickerFriendRequestParams {
  /// KO: 피커 이름
  /// <br>
  /// EN: Name of the picker
  final String? title;

  /// KO: 검색 기능 사용 여부
  /// <br>
  /// EN: Enables the search function
  final bool? enableSearch;

  /// KO: 내 프로필 표시 여부
  /// <br>
  /// EN: Displays my profile
  final bool? showMyProfile;

  /// KO: 즐겨찾기 친구 표시 여부
  /// <br>
  /// EN: Marks on favorite friends
  final bool? showFavorite;

  /// KO: 선택한 친구 표시 여부, 멀티 피커에만 사용 가능
  /// <br>
  /// EN: Displays selected friends for multi-picker
  final bool? showPickedFriend;

  /// KO: 선택 가능한 최대 대상 수
  /// <br>
  /// EN: Maximum pickable count
  final int? maxPickableCount;

  /// KO: 선택 가능한 최소 대상 수
  /// <br>
  /// EN: Minimum pickable count
  final int? minPickableCount;

  /// KO: 친구 정보를 받을 URL, 리다이렉트 방식 웹 사용 시 필수
  /// <br>
  /// EN: URL to get the friend information, required for web with redirect method
  final String? returnUrl;

  /// KO: 뒤로 가기 버튼 사용 여부, 리다이렉트 방식 웹 또는 네이티브 앱에서만 사용 가능
  /// <br>
  /// EN: Enables the back button, available for web with redirect method or native app
  final bool? enableBackButton;

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

  /// @nodoc
  factory PickerFriendRequestParams.fromJson(Map<String, dynamic> json) =>
      _$PickerFriendRequestParamsFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$PickerFriendRequestParamsToJson(this);

  /// @nodoc
  PickerFriendRequestParams clone({
    String? title,
    bool? enableSearch,
    bool? showMyProfile,
    bool? showFavorite,
    bool? showPickedFriend,
    int? maxPickableCount,
    int? minPickableCount,
    String? returnUrl,
    bool? enableBackButton,
  }) => PickerFriendRequestParams(
    title: title ?? this.title,
    enableSearch: enableSearch ?? this.enableSearch,
    showMyProfile: showMyProfile ?? this.showMyProfile,
    showFavorite: showFavorite ?? this.showFavorite,
    showPickedFriend: showPickedFriend ?? this.showPickedFriend,
    maxPickableCount: maxPickableCount ?? this.maxPickableCount,
    minPickableCount: minPickableCount ?? this.minPickableCount,
    returnUrl: returnUrl ?? this.returnUrl,
    enableBackButton: enableBackButton ?? this.enableBackButton,
  );
}

/// @nodoc
class DefaultValues {
  static const bool enableSearch = true;
  static const bool showMyProfile = true;
  static const bool showFavorite = true;
  static const bool showPickedFriend = true;
  static const int maxPickableCount = 30;
  static const int minPickableCount = 1;
  static const bool enableBackButton = true;
}
