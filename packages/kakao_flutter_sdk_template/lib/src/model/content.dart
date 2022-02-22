import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'content.g.dart';

/// 콘텐츠의 내용을 담고 있는 오브젝트
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Content {
  /// 콘텐츠의 타이틀
  final String title;

  /// 콘텐츠의 이미지 URL
  final Uri imageUrl;

  /// 콘텐츠 클릭 시 이동할 링크 정보
  final Link link;
  final String? description;

  /// 콘텐츠의 이미지 너비 (단위: 픽셀)
  final int? imageWidth;

  /// 콘텐츠의 이미지 높이 (단위: 픽셀)
  final int? imageHeight;

  /// @nodoc
  Content({
    required this.title,
    required this.imageUrl,
    required this.link,
    this.description,
    this.imageWidth,
    this.imageHeight,
  });

  /// @nodoc
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
