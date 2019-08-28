import 'package:json_annotation/json_annotation.dart';

part 'region_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RegionInfo {
  @JsonKey(name: "region")
  List<String> regions;
  String keyword;
  String selectedRegion;

  RegionInfo(this.regions, this.keyword, this.selectedRegion);

  /// <nodoc>
  factory RegionInfo.fromJson(Map<String, dynamic> json) =>
      _$RegionInfoFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$RegionInfoToJson(this);

  @override
  String toString() => toJson().toString();
}
