import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';
import 'share_type.dart';

part 'picker_settings.g.dart';

/// KO: 카카오톡 공유 대상 선택 화면 설정
/// <br>
/// EN: Settings for the share target selection screen in Kakao Talk
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PickerSettings {
  /// KO: [type]에 공유 대상 선택 화면 유형 전달<br>
  /// [limit]에 선택 가능한 공유 대상 수 전달<br>
  /// <br>
  /// EN: Pass the type of the share target selection screen to [type]<br>
  /// Pass the number of selectable share targets to [limit]<br>
  const PickerSettings({this.type, this.limit});

  /// KO: 공유 대상 선택 화면 유형
  /// <br>
  /// EN: Type of the share target selection screen
  final ShareType? type;

  /// KO: 선택 가능한 공유 대상 수
  /// <br>
  /// EN: Number of selectable share targets
  final int? limit;

  /// @nodoc
  Map<String, dynamic> toSchemeParams() => <String, dynamic>{
    Constants.list: ?type?.value,
    Constants.limit: ?limit,
  };

  Map<String, dynamic> toJson() => _$PickerSettingsToJson(this);

  @override
  String toString() => toJson().toString();
}
