import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_template/src/default_template.dart';
import 'package:kakao_flutter_sdk_template/src/model/button.dart';
import 'package:kakao_flutter_sdk_template/src/model/content.dart';

part 'calendar_template.g.dart';

/// KO: 캘린더 메시지용 기본 템플릿
/// <br>
/// EN: Default template for calendar messages
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class CalendarTemplate extends DefaultTemplate {
  /// KO: 구독 캘린더 또는 공개 일정 ID
  /// <br>
  /// EN: ID for subscribed calendar or public event
  final String id;

  /// KO: ID 타입
  /// <br>
  /// EN: ID type
  final IdType idType;

  /// KO: 일정 설명
  /// <br>
  /// EN: Event description
  final Content content;

  /// KO: 메시지 하단 버튼
  /// <br>
  /// EN: Button at the bottom of the message
  final List<Button>? buttons;

  /// KO: 메시지 템플릿 타입, "calendar"로 고정
  /// <br>
  /// EN: Type of the message template, fixed as "calendar"
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

/// KO: ID 타입
/// <br>
/// EN: ID type
enum IdType {
  /// KO: 구독 캘린더
  /// <br>
  /// EN: Subscribed calendar
  calendar,

  /// KO: 공개 일정
  /// <br>
  /// EN: Public event
  event,
}
