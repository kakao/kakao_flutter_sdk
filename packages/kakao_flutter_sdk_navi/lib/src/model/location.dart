import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// 카카오내비에서 장소를 표현
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Location {
  /// name 장소 이름. 예) 우리집, 회사
  final String name;

  /// 경도 좌표
  final String x;

  /// 위도 좌표
  final String y;
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
