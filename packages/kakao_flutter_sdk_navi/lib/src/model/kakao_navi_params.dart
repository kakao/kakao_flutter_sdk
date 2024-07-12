import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';

part 'kakao_navi_params.g.dart';

/// @nodoc
@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class KakaoNaviParams {
  /// KO: 목적지
  /// <br>
  /// EN: Destination
  final Location destination;

  /// KO: 경로 검색 옵션
  /// <br>
  /// EN: Options for searching the route
  final NaviOption? option;

  /// KO: 경유지 목록(최대: 3개)
  /// <br>
  /// EN: List of stops (Maximum: 3 places)
  final List<Location>? viaList;

  /// @nodoc
  KakaoNaviParams({required this.destination, this.option, this.viaList});

  /// @nodoc
  Map<String, dynamic> toJson() => _$KakaoNaviParamsToJson(this);

  /// @nodoc
  factory KakaoNaviParams.fromJson(Map<String, dynamic> json) =>
      _$KakaoNaviParamsFromJson(json);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
