import 'package:json_annotation/json_annotation.dart';

import 'location.dart';
import 'navi_option.dart';

part 'kakao_navi_params.g.dart';

/// @nodoc
@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
  explicitToJson: true,
)
class KakaoNaviParams {
  final Location destination;

  final NaviOption? option;
  final List<Location>? viaList;

  KakaoNaviParams({required this.destination, this.option, this.viaList});

  Map<String, dynamic> toJson() => _$KakaoNaviParamsToJson(this);

  factory KakaoNaviParams.fromJson(Map<String, dynamic> json) =>
      _$KakaoNaviParamsFromJson(json);

  @override
  String toString() => toJson().toString();
}
