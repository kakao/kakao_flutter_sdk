import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// KO: 장소 정보
/// <br>
/// EN: Location information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Location {
  /// KO: 장소 이름
  /// <br>
  /// EN: Location name
  final String name;

  /// KO: 경도 좌표
  /// <br>
  /// EN: Longitude coordinate
  final String x;

  /// KO: 위도 좌표
  /// <br>
  /// EN: Latitude coordinate
  final String y;

  /// KO: 도착 링크(현재 미지원)
  /// <br>
  /// EN: Link for the destination (Currently not available)
  @JsonKey(name: "rpflag")
  final String? rpFlag;

  /// @nodoc
  Location({required this.name, required this.x, required this.y, this.rpFlag});

  /// @nodoc
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  /// @nodoc
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
