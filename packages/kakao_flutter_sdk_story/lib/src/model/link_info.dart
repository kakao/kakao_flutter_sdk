import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

/// 카카오스토리 포스팅을 위한 스크랩 API 응답 클래스
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class LinkInfo {
  /// 스크랩 한 주소의 URL
  /// shorten URL 의 경우 resolution 한 실제 URL
  final String? url;

  /// 요청시의 URL 원본
  /// resolution 을 하기 전의 URL
  final String? requestedUrl;

  /// 스크랩한 호스트 도메인
  final String? host;

  /// 웹 페이지의 제목
  final String? title;

  /// 웹 페이지의 대표 이미지 주소의 url array
  /// 최대 3개
  @JsonKey(name: "image")
  final List<String>? images;

  /// 웹 페이지의 설명
  final String? description;

  /// 웹 페이지의 섹션 정보
  final String? section;

  /// 웹 페이지의 콘텐츠 타입
  /// 예) video, music, book, article, profile, website 등
  final String? type;

  /// @nodoc
  LinkInfo(this.url, this.requestedUrl, this.host, this.title, this.images,
      this.description, this.section, this.type);

  /// @nodoc
  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}
