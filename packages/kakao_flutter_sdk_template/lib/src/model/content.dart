import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/model/link.dart';

part 'content.g.dart';

/// KO: 메시지 콘텐츠
/// <br>
/// EN: Contents for the message
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class Content {
  /// KO: 제목
  /// <br>
  /// EN: Title
  final String? title;

  /// KO: 바로가기 URL
  /// <br>
  /// EN: Link URL
  final Uri? imageUrl;

  /// KO: 바로가기 URL
  /// <br>
  /// EN: Link URL
  final Link link;

  /// KO: 설명
  /// <br>
  /// EN: Description
  final String? description;

  /// KO: 이미지 너비(단위: 픽셀)
  /// <br>
  /// EN: Image width (Unit: Pixel)
  final int? imageWidth;

  /// KO: 이미지 높이(단위: 픽셀)
  /// <br>
  /// EN: Image height (Unit: Pixel)
  final int? imageHeight;

  /// @nodoc
  Content({
    this.title,
    this.imageUrl,
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
