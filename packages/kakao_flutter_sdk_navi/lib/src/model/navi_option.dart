import 'package:json_annotation/json_annotation.dart';

part 'navi_option.g.dart';

/// KO: 경로 검색 옵션
/// <br>
/// EN: Options for searching the route
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NaviOption {
  /// KO: 좌표계 타입
  /// <br>
  /// EN: Type of the coordinate system
  final CoordType? coordType;

  /// KO: 차종(기본값: 카카오내비 앱에 설정된 차종)
  /// <br>
  /// EN: Vehicle type (Default: vehicle type set on the Kakao Navi app)
  final VehicleType? vehicleType;

  /// KO: 경로 최적화 기준
  /// <br>
  /// EN: Criteria to optimize the route
  @JsonKey(name: "rpoption")
  final RpOption? rpOption;

  /// KO: 전체 경로 정보 보기 사용 여부
  /// <br>
  /// EN: Whether to view the full route information
  final bool? routeInfo;

  /// KO: 시작 위치의 경도 좌표
  /// <br>
  /// EN: Longitude coordinate of the start point
  @JsonKey(name: "s_x")
  final String? startX;

  /// KO: 시작 위치의 위도 좌표
  /// <br>
  /// EN: Latitude coordinate of the start point
  @JsonKey(name: "s_y")
  final String? startY;

  /// KO: 시작 차량 각도(최소: 0, 최대: 359)
  /// <br>
  /// EN: Angle of the vehicle at the start point (Minimum: 0, Maximum: 359)
  final int? startAngle;

  /// KO: 전체 경로 보기 종료 시 호출될 URI
  /// <br>
  /// EN: URI to be called upon exiting the full route view
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

/// KO: 좌표계 타입
/// <br>
/// EN: Type of the coordinate system
enum CoordType {
  /// KO: World Geodetic System(WGS) 84
  /// <br>
  /// EN: World Geodetic System(WGS) 84
  wgs84,

  /// KO: Katec, 서버 기본값
  /// <br>
  /// EN: Katec, the default value on the server side
  katec
}

/// KO: 경로 최적화 기준
/// <br>
/// EN: Criteria to optimize the route
enum RpOption {
  /// KO: 가장 빠른 경로
  /// <br>
  /// EN: Fastest route
  @JsonValue("1")
  fast,

  /// KO: 무료 도로
  /// <br>
  /// EN: Free route
  @JsonValue("2")
  free,

  /// KO: 가장 짧은 경로
  /// <br>
  /// EN: Shortest route
  @JsonValue("3")
  shortest,

  /// KO: 자동차 전용 도로 제외
  /// <br>
  /// EN: Exclude motorway
  @JsonValue("4")
  noAuto,

  /// KO: 큰길 우선
  /// <br>
  /// EN: Wide road first
  @JsonValue("5")
  wide,

  /// KO: 고속도로 우선
  /// <br>
  /// EN: Highway first
  @JsonValue("6")
  highway,

  /// KO: 일반 도로 우선
  /// <br>
  /// EN: Normal road first
  @JsonValue("8")
  normal,

  /// KO: 추천 경로(기본값)
  /// <br>
  /// EN: Recommended route (Default)
  @JsonValue("100")
  recommended
}

/// KO: 차종
/// <br>
/// EN: Vehicle type
enum VehicleType {
  /// KO: 1종, 승용차, 소형승합차, 소형화물차
  /// <br>
  /// EN: Class 1, passenger car, small van, small truck
  @JsonValue("1")
  first,

  /// KO: 2종, 중형승합차, 중형화물차
  /// <br>
  /// EN: Class 2, mid-size van, mid-size truck
  @JsonValue("2")
  second,

  /// KO: 3종, 대형승합차, 2축 대형화물차
  /// <br>
  /// EN: Class 3, large van, 2-axis large truck
  @JsonValue("3")
  third,

  /// KO: 4종, 3축 대형화물차
  /// <br>
  /// EN: Class 4, 3-axis large truck
  @JsonValue("4")
  fourth,

  /// KO: 5종, 4축 이상 특수화물차
  /// <br>
  /// EN: Class 5, special truck with four axes or more
  @JsonValue("5")
  fifth,

  /// KO: 6종, 경차
  /// <br>
  /// EN: Class 6, compact car
  @JsonValue("6")
  sixth,

  /// KO: 이륜차
  /// <br>
  /// EN: Two-wheeled vehicle
  @JsonValue("7")
  twoWheel
}
