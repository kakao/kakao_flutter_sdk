// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Button _$ButtonFromJson(Map<String, dynamic> json) {
  return Button(
    title: json['title'] as String,
    link: Link.fromJson(json['link'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ButtonToJson(Button instance) => <String, dynamic>{
      'title': instance.title,
      'link': instance.link.toJson(),
    };
