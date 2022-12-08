import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';

part 'calendar_template.g.dart';

/// 톡캘린더의 구독 캘린더 또는 공개 일정 정보를 포함한 메시지 형식입니다.
/// 카카오톡 채널의 구독 캘린더 또는 공개 일정을 사용자의 톡캘린더에 추가하는 기능을 제공합니다.
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class CalendarTemplate extends DefaultTemplate {
  /// 구독 캘린더 또는 공개 일정 ID
  final String id;

  /// id의 타입, event(공개 일정) 또는 calendar(구독 캘린더) 중 하나
  final IdType idType;

  /// 일정에 대해 설명하는 컨텐츠 정보
  final Content content;

  /// 버튼 목록
  /// 기본 버튼의 타이틀 외에 링크도 변경하고 싶을 때 설정 (최대 1개, 오른쪽 위치 보기 버튼은 고정)
  final List<Button>? buttons;

  /// "calendar" 고정 값
  final String objectType;

  /// @nodoc
  CalendarTemplate({
    required this.id,
    required this.idType,
    required this.content,
    this.buttons,
    this.objectType = "calendar",
  });

  /// @nodoc
  factory CalendarTemplate.fromJson(Map<String, dynamic> json) =>
      _$CalendarTemplateFromJson(json);

  /// @nodoc
  Map<String, dynamic> toJson() => _$CalendarTemplateToJson(this);

  /// @nodoc
  @override
  String toString() => toJson().toString();
}

/// id의 타입, event(공개 일정) 또는 calendar(구독 캘린더) 중 하나
enum IdType {
  calendar,
  event,
}
