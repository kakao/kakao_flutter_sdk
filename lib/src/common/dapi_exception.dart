import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk/common.dart';

part 'dapi_exception.g.dart';

@JsonSerializable(includeIfNull: false)
class DapiException extends KakaoException {
  /// <nodoc>
  DapiException(this.errorType, this.message) : super(message);

  final String errorType;
  final String message;

  /// <nodoc>
  factory DapiException.fromJson(Map<String, dynamic> json) =>
      _$DapiExceptionFromJson(json);

  /// <nodoc>
  Map<String, dynamic> toJson() => _$DapiExceptionToJson(this);

  @override
  String toString() => "${this.runtimeType}: ${toJson().toString()}";
}
