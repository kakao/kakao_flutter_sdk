// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdResponse _$UserIdResponseFromJson(Map<String, dynamic> json) {
  return UserIdResponse(
    json['id'] as int,
  );
}

Map<String, dynamic> _$UserIdResponseToJson(UserIdResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  return val;
}
