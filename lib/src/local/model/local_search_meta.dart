import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/src/local/model/region_info.dart';
import 'package:kakao_flutter_sdk/src/search/model/search_meta.dart';

part 'local_search_meta.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocalSearchMeta extends SearchMeta {
  @JsonKey(name: "same_name")
  RegionInfo regionInfo;

  LocalSearchMeta(
      int totalCount, int pageableCount, bool isEnd, this.regionInfo)
      : super(totalCount, pageableCount, isEnd);

  /// <nodoc>
  factory LocalSearchMeta.fromJson(Map<String, dynamic> json) =>
      _$LocalSearchMetaFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$LocalSearchMetaToJson(this);

  @override
  String toString() => toJson().toString();
}
