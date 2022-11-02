import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_friend/src/default_values.dart';

part 'picker_friend_request_params.g.dart';

@JsonSerializable()
class PickerFriendRequestParams {
  String? title;
  bool? enableSearch;
  bool? showMyProfile;
  bool? showFavorite;
  bool? showPickedFriend;
  int? maxPickableCount;
  int? minPickableCount;
  String? returnUrl;
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
