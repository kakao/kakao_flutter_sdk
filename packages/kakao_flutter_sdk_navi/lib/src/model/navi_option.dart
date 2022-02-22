import 'package:json_annotation/json_annotation.dart';

part 'navi_option.g.dart';

/// 길안내 옵션
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NaviOption {
  /// 사용할 좌표계
  final CoordType? coordType;

  /// 차종
  final VehicleType? vehicleType;

  /// 경로 옵션
  @JsonKey(name: "rpoption")
  final RpOption? rpOption;

  /// 전체 경로정보 보기 사용여부
  final bool? routeInfo;

  /// 시작 위치의 경도 좌표
  @JsonKey(name: "s_x")
  final String? startX;

  /// 시작 위치의 위도 좌표
  @JsonKey(name: "s_y")
  final String? startY;

  /// 시작 차량 각도 (0 ~ 359)
  final int? startAngle;

  /// 길안내 종료(전체 경로보기시 종료) 후 호출 될 URI.
  final String? returnUri;

  /// @nodoc
  NaviOption({
    this.coordType,
    this.vehicleType,
    this.rpOption,
    this.routeInfo,
    this.startX,
    this.startY,
    this.startAngle,
    this.returnUri,
  });

  /// @nodoc
  Map<String, dynamic> toJson() => _$NaviOptionToJson(this);

  /// @nodoc
  factory NaviOption.fromJson(Map<String, dynamic> json) =>
      _$NaviOptionFromJson(json);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// 좌표계 타입 선택
enum CoordType {
  /// World Geodetic System 84 좌표계
  wgs84,

  /// Katec 좌표계 (서버 기본값)
  katec
}

/// 안내할 경로를 최적화하기 위한 옵션
enum RpOption {
  /// 빠른 길
  @JsonValue("1")
  fast,

  /// 무료 도로
  @JsonValue("2")
  free,

  /// 최단거리
  @JsonValue("3")
  shortest,

  /// 자동차 전용 제외
  @JsonValue("4")
  noAuto,

  /// 큰 길 우선
  @JsonValue("5")
  wide,

  /// 고속도로 우선
  @JsonValue("6")
  highway,

  ///일반도로 우선
  @JsonValue("8")
  normal,

  /// 추천 경로 (기본값)
  @JsonValue("100")
  recommended
}

/// 길안내를 사용할 차종(1~7) 선택
enum VehicleType {
  /// 1종 (승용차/소형승합차/소형화물화)
  @JsonValue("1")
  first,

  ///2종 (중형승합차/중형화물차)
  @JsonValue("2")
  second,

  /// 3종 (대형승합차/2축 대형화물차)
  @JsonValue("3")
  third,

  /// 4종 (3축 대형화물차)
  @JsonValue("4")
  fourth,

  /// 5종 (4축이상 특수화물차)
  @JsonValue("5")
  fifth,

  /// 6종 (경차)
  @JsonValue("6")
  sixth,

  ///이륜차
  @JsonValue("7")
  twoWheel
}
