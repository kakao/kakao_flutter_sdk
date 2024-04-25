import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/social.dart';

part 'location_template.g.dart';

/// KO: 위치 메시지용 기본 템플릿
/// <br>
/// EN: Default template for location messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LocationTemplate extends DefaultTemplate {
  /// KO: 주소
  /// <br>
  /// EN: Address
  final String address;

  /// KO: 메시지 콘텐츠
  /// <br>
  /// EN: Contents for the message
  final Content content;

  /// KO: 장소 이름
  /// <br>
  /// EN: Name of the place
  final String? addressTitle;

  /// KO: 소셜 정보
  /// <br>
  /// EN: Social information
  final Social? social;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 버튼 문구
  /// <br>
  /// EN: Label for the button
  final String? buttonTitle;

  /// KO: 메시지 템플릿 타입, "location"으로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "location"
  final String objectType;

  /// @nodoc
  LocationTemplate({
    required this.address,
    required this.content,
    this.addressTitle,
    this.social,
    this.buttons,
    this.buttonTitle,
    this.objectType = "location",
  });

  /// @nodoc
  factory LocationTemplate.fromJson(Map<String, dynamic> json) =>
      _$LocationTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$LocationTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
