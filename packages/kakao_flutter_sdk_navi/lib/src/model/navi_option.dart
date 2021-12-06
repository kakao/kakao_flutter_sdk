import 'package:json_annotation/json_annotation.dart';

part 'navi_option.g.dart';

/// 길안내 옵션을 설정합니다.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NaviOption {
  /// 사용할 좌표계
  final NaviCoordType? coordType;

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
  NaviOption(
      {this.coordType,
      this.vehicleType,
      this.rpOption,
      this.routeInfo,
      this.startX,
      this.startY,
      this.startAngle,
      this.returnUri});

  /// @nodoc
  Map<String, dynamic> toJson() => _$NaviOptionToJson(this);

  /// @nodoc
  factory NaviOption.fromJson(Map<String, dynamic> json) =>
      _$NaviOptionFromJson(json);
}

/// 좌표계 타입을 선택합니다.
enum NaviCoordType {
  /// World Geodetic System 84 좌표계
  @JsonValue("wgs84")
  WGS84,

  /// Katec 좌표계 (서버 기본값)
  @JsonValue("katec")
  KATEC
}

/// 안내할 경로를 최적화하기 위한 옵션입니다.
enum RpOption {
  /// Fastest route
  @JsonValue("1")
  FAST, // 빠른길

  /// Free route
  @JsonValue("2")
  FREE, // 무료도로

  /// Shortest route
  @JsonValue("3")
  SHORTEST, // 최단거리

  ///Exclude motorway
  @JsonValue("4")
  NO_AUTO, // 자동차전용제외

  ///Wide road first
  @JsonValue("5")
  WIDE, // 큰길우선

  /// Highway first
  @JsonValue("6")
  HIGHWAY, // 고속도로우선

  ///Normal road first
  @JsonValue("8")
  NORMAL, // 일반도로우선

  ///Recommended route (Current default option if not set)
  @JsonValue("100")
  RECOMMENDED // 추천경로 (기본값)
}

/// 길안내를 사용할 차종(1~7)을 선택합니다.
enum VehicleType {
  /// 1종 (승용차/소형승합차/소형화물화)
  @JsonValue("1")
  FIRST,

  ///2종 (중형승합차/중형화물차)
  @JsonValue("2")
  SECOND,

  /// 3종 (대형승합차/2축 대형화물차)
  @JsonValue("3")
  THIRD,

  /// 4종 (3축 대형화물차)
  @JsonValue("4")
  FOURTH,

  /// 5종 (4축이상 특수화물차)
  @JsonValue("5")
  FIFTH,

  /// 6종 (경차)
  @JsonValue("6")
  SIXTH,

  ///이륜차
  @JsonValue("7")
  TWO_WHEEL
}
