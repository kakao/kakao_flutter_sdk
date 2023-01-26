// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picker_friend_request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickerFriendRequestParams _$PickerFriendRequestParamsFromJson(
        Map<String, dynamic> json) =>
    PickerFriendRequestParams(
      title: json['title'] as String?,
      enableSearch: json['enableSearch'] as bool? ?? DefaultValues.enableSearch,
      showMyProfile:
          json['showMyProfile'] as bool? ?? DefaultValues.showMyProfile,
      showFavorite: json['showFavorite'] as bool? ?? DefaultValues.showFavorite,
      showPickedFriend:
          json['showPickedFriend'] as bool? ?? DefaultValues.showPickedFriend,
      maxPickableCount:
          json['maxPickableCount'] as int? ?? DefaultValues.maxPickableCount,
      minPickableCount:
          json['minPickableCount'] as int? ?? DefaultValues.minPickableCount,
      returnUrl: json['returnUrl'] as String?,
      enableBackButton:
          json['enableBackButton'] as bool? ?? DefaultValues.enableBackButton,
    );

Map<String, dynamic> _$PickerFriendRequestParamsToJson(
        PickerFriendRequestParams instance) =>
    <String, dynamic>{
      'title': instance.title,
      'enableSearch': instance.enableSearch,
      'showMyProfile': instance.showMyProfile,
      'showFavorite': instance.showFavorite,
      'showPickedFriend': instance.showPickedFriend,
      'maxPickableCount': instance.maxPickableCount,
      'minPickableCount': instance.minPickableCount,
      'returnUrl': instance.returnUrl,
      'enableBackButton': instance.enableBackButton,
    };
