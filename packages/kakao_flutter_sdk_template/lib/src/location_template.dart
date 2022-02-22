import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';
import 'package:kakao_flutter_sdk_template/src/model/social.dart';

part 'location_template.g.dart';

/// 주소를 이용하여 특정 위치를 공유할 수 있는 메시지 템플릿
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LocationTemplate extends DefaultTemplate {
  /// 공유할 위치의 주소. 예) 경기 성남시 분당구 판교역로 235
  final String address;

  /// 위치에 대해 설명하는 컨텐츠 정보
  final Content content;

  /// 카카오톡 내의 지도 뷰에서 사용되는 타이틀
  /// 예) 카카오판교오피스
  final String? addressTitle;

  /// 댓글수, 좋아요수 등, 컨텐츠에 대한 소셜 정보
  final Social? social;

  /// 버튼 목록
  /// 기본 버튼의 타이틀 외에 링크도 변경하고 싶을 때 설정 (최대 1개, 오른쪽 위치 보기 버튼은 고정)
  final List<Button>? buttons;

  /// 기본 버튼 타이틀(자세히 보기)을 변경하고 싶을 때 설정
  /// 이 값을 사용하면 클릭 시 이동할 링크는 content에 입력된 값이 사용됨
  final String? buttonTitle;

  /// "location" 고정 값
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
