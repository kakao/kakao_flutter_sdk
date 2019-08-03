// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Button _$ButtonFromJson(Map<String, dynamic> json) {
  return Button(
    json['title'] as String,
    json['link'] == null
        ? null
        : Link.fromJson(json['link'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ButtonToJson(Button instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('link', instance.link?.toJson());
  return val;
}
