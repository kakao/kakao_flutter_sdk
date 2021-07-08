import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/navi/model/location.dart';
import 'package:kakao_flutter_sdk/src/navi/model/navi_option.dart';

part 'kakao_navi_params.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class KakaoNaviParams {
  final Location destination;
  final NaviOption? option;
  final List<Location>? viaList;

  KakaoNaviParams(this.destination, {this.option, this.viaList});

  /// <nodoc>
  Map<String, dynamic> toJson() => _$KakaoNaviParamsToJson(this);

  /// <nodoc>
  factory KakaoNaviParams.fromJson(Map<String, dynamic> json) =>
      _$KakaoNaviParamsFromJson(json);
}
